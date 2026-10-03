// 自行启动随机端口，执行真实入口检查，结束后关闭本次服务器。
import { spawn } from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
await fs.mkdir(path.join(root, '.artifacts'), { recursive: true });
async function run(file, env = {}) {
  await new Promise((resolve, reject) => {
    const child = spawn(process.execPath, [file], { cwd: root, env: { ...process.env, ...env }, stdio: 'inherit' });
    child.on('error', reject);
    child.on('exit', (code, signal) => code === 0 ? resolve() : reject(new Error(`${file} 失败：${code ?? signal}`)));
  });
}
await run('scripts/build.mjs');
const server = spawn(process.execPath, ['scripts/server.mjs'], { cwd: root, env: { ...process.env, PORT: '0' }, stdio: ['ignore', 'pipe', 'inherit'] });
try {
  const url = await new Promise((resolve, reject) => {
    const timeout = setTimeout(() => reject(new Error('服务器启动超时')), 15000);
    let output = '';
    server.stdout.on('data', chunk => {
      output += chunk.toString();
      const found = output.match(/http:\/\/localhost:(\d+)/);
      if (found) { clearTimeout(timeout); resolve(found[0]); }
    });
    server.once('error', error => { clearTimeout(timeout); reject(error); });
    server.once('exit', code => { clearTimeout(timeout); reject(new Error(`服务器提前退出：${code}`)); });
  });
  const env = { PREVIEW_URL: url };
  await run('scripts/check.mjs', env);
  await run('scripts/verify.mjs', env);
  await run('scripts/verify-media.mjs', env);
  console.log('通过：独立构建、服务协议、桌面/手机交互及当前卡片媒体检查。');
} finally {
  if (server.exitCode === null && server.signalCode === null) {
    const exited = new Promise(resolve => server.once('exit', resolve));
    server.kill('SIGTERM');
    await exited;
  }
}
