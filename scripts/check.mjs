import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const reference = path.join(root, 'vendor/activetheory');
const source = reference;
const publicDir = path.join(root, 'public');
const report = JSON.parse(await fs.readFile(path.join(root, '.artifacts/adaptation-manifest.json')));
const sha = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const app = await fs.readFile(path.join(publicDir, 'assets/js/app.1780406240914.js'), 'utf8');
assert.equal(sha(app), report.runtimeSHA256);
const files = await fs.readdir(path.join(source, 'modules'));
for (const module of report.preservedModules) {
  const original = (await fs.readFile(path.join(source, 'modules', files.find(file => file.endsWith(`-${module.name}.js`))), 'utf8')).trim();
  assert.ok(app.includes(original), module.name);
}
// 原版的全部相机、网格变换、粒子行为、材质参数与文字动画样式均逐字段比较。
const originalUIL = JSON.parse(await fs.readFile(path.join(source, 'uil.1780406240914.json')));
const brandedUIL = JSON.parse(await fs.readFile(path.join(publicDir, 'assets/data/uil.1780406240914.json')));
const allowed = new Set(report.contentFields.map(field => field.key));
function verifyMotionFields(candidate) {
  assert.deepEqual(Object.keys(candidate), Object.keys(originalUIL));
  let count = 0;
  for (const key of Object.keys(originalUIL)) {
    if (allowed.has(key)) continue;
    assert.deepEqual(candidate[key], originalUIL[key], key); count++;
  }
  return count;
}
// 检查器必须拒绝被改动的相机参数，不只是接受自己的输出。
const invalidUIL = structuredClone(brandedUIL);
const cameraKey = Object.keys(originalUIL).find(key => key.startsWith('CAMERA_'));
invalidUIL[cameraKey] = [9, 9, 9];
assert.throws(() => verifyMotionFields(invalidUIL));
const preservedFields = verifyMotionFields(brandedUIL);
assert.equal(sha(await fs.readFile(path.join(publicDir, 'assets/shaders/compiled.vs'))), report.shaders.sha256);
const projects = JSON.parse(await fs.readFile(path.join(publicDir, 'remote/cms/projects-dev.json')));
assert.equal(projects.length, 14); assert.equal(new Set(projects.map(p => p.slug)).size, 14);
assert.equal(new Set(projects.map(p => p.video.url)).size, 14, '当前卡片媒体标识必须独立');
for (const project of projects) {
  assert.match(project.projectURL, /^https:\/\/github\.com\/Snychng/);
  for (const url of [project.video.url, project.video.thumbnail, project.projectLogo.url]) {
    assert.ok((await fs.stat(path.join(publicDir, url))).isFile(), url);
    assert.ok(!/\.mp4|remote\/media/.test(url));
  }
}
for (const filename of ['scripts/build.mjs', 'scripts/server.mjs', 'public/assets/js/app.1780406240914.js']) execFileSync(process.execPath, ['--check', path.join(root, filename)]);
const base = process.env.PREVIEW_URL || 'http://localhost:4199';
assert.equal((await fetch(base + '/work/dispersion')).status, 200);
const response = await fetch(base + '/assets/geometry/daily/monogram-home.json'); assert.equal(response.status, 200);
assert.ok((await response.json()).position.length > 1000);
const referenceShader = await fetch(base + '/assets/shaders/compiled.vs'); assert.equal(sha(Buffer.from(await referenceShader.arrayBuffer())), report.shaders.sha256);
const worker = await fetch(base + '//assets/geometry/home/jellyfish.bin', { headers: { Range: 'bytes=0-63' } });
assert.equal(worker.status, 206); assert.equal((await worker.arrayBuffer()).byteLength, 64);
const post = async (action, data) => {
  const r = await fetch(base + '/api/assistant/' + action, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
  assert.equal(r.status, 200); return r.json();
};
const { id } = await post('createThread');
await post('createMessage', { threadId: id, content: '色散' });
assert.equal((await post('createRun', { threadId: id })).slug, 'dispersion');
assert.ok((await post('listMessage', { threadId: id })).text.length > 30);
await fs.writeFile(path.join(root, '.artifacts/static-verification.json'), JSON.stringify({ passed: true, preservedModules: report.preservedModules.length, preservedUILFields: preservedFields, replacedContentFields: allowed.size, shadersIdentical: true, projectMedia: 14, services: ['deep-link', 'geometry', 'shader-readback', 'worker-range', 'local-search'] }, null, 2));
console.log(`通过：${report.preservedModules.length} 个原版模块、${preservedFields} 项原版参数、GLSL 回读、14 项媒体、深链接、worker 资源与本地检索。`);
