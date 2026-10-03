// 静态资源、视频 Range、SPA 深链接及本地作品查询服务。
import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { WebSocketServer } from 'ws';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const publicDir = path.join(root, 'public');
const port = Number(process.env.PORT || 4199);
const missing = new Map();
const threads = new Map();
const mime = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.webp': 'image/webp',
  '.gif': 'image/gif', '.svg': 'image/svg+xml', '.mp4': 'video/mp4', '.webm': 'video/webm',
  '.mp3': 'audio/mpeg', '.woff': 'font/woff', '.woff2': 'font/woff2', '.otf': 'font/otf',
  '.wasm': 'application/wasm', '.ktx2': 'image/ktx2', '.vs': 'text/plain', '.bin': 'application/octet-stream'
};
function json(res, data, status = 200) {
  res.writeHead(status, { 'Content-Type': mime['.json'], 'Cache-Control': 'no-store' });
  res.end(JSON.stringify(data));
}
async function readBody(req) {
  let body = '';
  for await (const chunk of req) { body += chunk; if (body.length > 65536) throw new Error('请求过大'); }
  return body ? JSON.parse(body) : {};
}
async function assistant(req, res, action) {
  const data = await readBody(req);
  if (action === 'createThread') {
    const id = crypto.randomUUID(); threads.set(id, { query: '', project: null }); return json(res, { id });
  }
  const thread = threads.get(data.threadId);
  if (!thread) return json(res, { error: 'Unknown thread' }, 404);
  if (action === 'createMessage') { thread.query = data.content || ''; return json(res, { message: thread.query }); }
  if (action === 'createRun') {
    const projects = JSON.parse(await fsp.readFile(path.join(publicDir, 'remote/cms/projects-dev.json'), 'utf8'));
    const translations = [['色散', 'dispersion'], ['星环', 'star ring'], ['画廊', 'gallery'], ['环绕', 'orbit'], ['弹弓', 'slingshot'], ['光爆', 'genesis'], ['玻璃', 'glass'], ['动效', 'motion'], ['交互', 'interaction']];
    let query = thread.query.toLowerCase();
    translations.forEach(([a, b]) => { query = query.replaceAll(a, b); });
    const terms = query.match(/[a-z0-9]+/g)?.filter(x => x.length > 2 && !['the', 'and', 'for', 'looking', 'show', 'what', 'are', 'you', 'some', 'projects', 'can', 'please'].includes(x)) || [];
    const ranked = projects.map(project => {
      const fields = `${project.name} ${project.clientName} ${project.tags} ${project.description}`.toLowerCase();
      return { project, score: terms.reduce((n, term) => n + (fields.includes(term) ? (project.name.toLowerCase().includes(term) ? 5 : 1) : 0), 0) };
    }).sort((a, b) => b.score - a.score || a.project.priority - b.project.priority);
    thread.project = ranked[0].project;
    return json(res, { slug: thread.project.slug });
  }
  if (action === 'listMessage') return json(res, { text: thread.project?.description || 'Explore our selected work.' });
  return json(res, { error: 'Unsupported operation' }, 404);
}

const server = http.createServer(async (req, res) => {
  try {
    const pathname = decodeURIComponent(new URL('http://localhost' + req.url).pathname).replace(/^\/+/, '/');
    if (pathname === '/__health') return json(res, { ok: true, missing: [...missing.entries()].map(([path, count]) => ({ path, count })) });
    if (pathname.startsWith('/api/assistant/') && req.method === 'POST') return await assistant(req, res, pathname.split('/').at(-1));
    let file = path.resolve(publicDir, '.' + pathname);
    if (!file.startsWith(publicDir + path.sep) && file !== publicDir) return json(res, { error: 'Forbidden' }, 403);
    let stat;
    try { stat = await fsp.stat(file); } catch {}
    if (stat?.isDirectory()) { file = path.join(file, 'index.html'); try { stat = await fsp.stat(file); } catch { stat = null; } }
    if (!stat?.isFile()) {
      if (!path.extname(pathname) && !pathname.startsWith('/assets/') && !pathname.startsWith('/remote/')) {
        file = path.join(publicDir, 'index.html'); stat = await fsp.stat(file);
      } else { missing.set(pathname, (missing.get(pathname) || 0) + 1); return json(res, { error: 'Resource not found', path: pathname }, 404); }
    }
    const headers = { 'Content-Type': mime[path.extname(file).toLowerCase()] || 'application/octet-stream', 'Accept-Ranges': 'bytes', 'Cache-Control': 'no-cache' };
    const range = req.headers.range?.match(/^bytes=(\d*)-(\d*)$/);
    let start = 0, end = stat.size - 1, status = 200;
    if (range) {
      start = range[1] ? Number(range[1]) : Math.max(0, stat.size - Number(range[2]));
      end = range[1] && range[2] ? Math.min(Number(range[2]), end) : end;
      if (start > end || start >= stat.size) { res.writeHead(416, { 'Content-Range': `bytes */${stat.size}` }); return res.end(); }
      status = 206; headers['Content-Range'] = `bytes ${start}-${end}/${stat.size}`;
    }
    headers['Content-Length'] = end - start + 1;
    res.writeHead(status, headers);
    if (req.method === 'HEAD') return res.end();
    fs.createReadStream(file, { start, end }).pipe(res);
  } catch (error) { if (!res.headersSent) json(res, { error: error.message }, 500); else res.destroy(); }
});

// 原站 GameCenter 社区房间协议的本地实现，支持两端滚动、指针和详情同步。
const rooms = new Map();
function send(socket, event, data = {}) {
  if (socket.readyState === 1) socket.send(JSON.stringify({ ...data, _evt: event }));
}
function players(room) { return [...room.members].map(socket => ({ id: socket.playerId, data: socket.user || {} })); }
function leave(socket) {
  const room = socket.room;
  if (!room) return;
  room.members.delete(socket);
  for (const member of room.members) send(member, 'player_disconnect', { gcID: socket.playerId });
  if (room.host === socket.playerId && room.members.size) {
    const next = [...room.members][0]; room.host = next.playerId; send(next, 'become_host');
  }
  if (!room.members.size) rooms.delete(room.id);
  socket.room = null;
}
const wss = new WebSocketServer({ server, path: '/ws', handleProtocols: () => 'permessage-deflate' });
wss.on('connection', socket => {
  socket.playerId = crypto.randomUUID();
  socket.on('message', (buffer, binary) => {
    const text = binary ? null : buffer.toString();
    if (text === 'ping') return socket.send('pong');
    if (!text) return;
    try {
      if (text.startsWith('binary:')) {
        if (!socket.room) return;
        const data = JSON.parse(text.slice(7));
        const payload = JSON.stringify(Array.isArray(data) ? data : [{ ...data, from: socket.playerId }]);
        for (const member of socket.room.members) if (member.readyState === 1) member.send(payload);
        return;
      }
      const data = JSON.parse(text), event = data._evt;
      if (event === 'findAny') {
        let room = !data.forceNewRoom && [...rooms.values()].find(r => r.type === data.type && r.members.size < r.max);
        if (!room) {
          room = { id: `${data.type}/${crypto.randomUUID()}`, type: data.type, members: new Set(), max: 2 };
          rooms.set(room.id, room);
        }
        return send(socket, 'findAny_response', { id: room.id });
      }
      if (event === 'join' || event === 'watch') {
        leave(socket);
        let room = rooms.get(data.id);
        if (!room) { room = { id: data.id, type: data.id.split('/')[0], members: new Set(), max: data.MAX_IN_ROOM || 2 }; rooms.set(room.id, room); }
        if (room.members.size >= room.max) return send(socket, `${event}_response`, { success: false });
        const previous = [...room.members];
        socket.user = data.user || {}; socket.room = room; room.members.add(socket); room.host ||= socket.playerId;
        send(socket, `${event}_response`, { success: true, myID: socket.playerId, host: room.host === socket.playerId, players: players(room) });
        for (const member of previous) send(member, 'open_connection', { gcID: socket.playerId, data: socket.user });
        return;
      }
      if (event === 'leave') { leave(socket); return send(socket, 'leave_response', { success: true }); }
      if (event === 'update_user_data') {
        socket.user = data.data || {};
        for (const member of socket.room?.members || []) if (member !== socket) send(member, 'update_user_data', { data: { gcID: socket.playerId, data: socket.user } });
        return;
      }
      if (event === 'request_state' && socket.room) return send(socket, 'rebroadcast_players', { data: players(socket.room) });
      if (event === 'roomCount') return send(socket, 'roomCount_response', { count: rooms.get(data.roomId)?.members.size || 0 });
      if (['pin', 'unpin', 'broadcast', 'server_data', 'start_game', 'end_game'].includes(event)) {
        for (const member of socket.room?.members || []) send(member, event, data);
      }
    } catch (error) { send(socket, 'protocol_error', { message: error.message }); }
  });
  socket.on('close', () => leave(socket));
});
server.listen(port, '0.0.0.0', () => console.log(`Daily Design · 原站动效：http://localhost:${server.address().port}`));
