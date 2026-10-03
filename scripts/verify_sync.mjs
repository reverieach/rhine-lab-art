import { chromium, devices } from './browser.mjs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import assert from 'node:assert/strict';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const output = path.join(root, '.artifacts');
const browser = await chromium.launch({ headless: true });
const errors = [], report = { date: '2026-10-03', device: 'Chrome desktop + emulated Pixel 7', errors };
try {
  const desktop = await browser.newContext({ viewport: { width: 1440, height: 900 } });
  const mobile = await browser.newContext({ ...devices['Pixel 7'], viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
  const a = await desktop.newPage(), b = await mobile.newPage();
  for (const page of [a, b]) page.on('pageerror', error => errors.push(error.message));
  const base = process.env.PREVIEW_URL || 'http://localhost:4199';
  await a.goto(base);
  await a.waitForFunction(() => window.AppState && AppState.get('ViewController/visibleV') > 0.99 && window.Multiplayer?.room, undefined, { timeout: 60000 });
  const shareURL = await a.evaluate(() => {
    // 使用原站自己的 QRCode URL，包括房间键与作品顺序。
    const roomType = Multiplayer.room.id.split('/')[0].replace(/^community_/, '');
    return `${location.origin}/?roomqr=${roomType}&workids=${CMSData.workPages.toJSON().map(x => x.index).join(',')}`;
  });
  await b.goto(shareURL);
  await b.waitForFunction(() => window.AppState && AppState.get('ViewController/visibleV') > 0.99 && Multiplayer.room?.players.length === 2, undefined, { timeout: 60000 });
  await a.waitForFunction(() => Multiplayer.room?.players.length === 2, undefined, { timeout: 15000 });
  report.roomJoined = true;
  await a.mouse.move(800, 450);
  await a.mouse.wheel(0, 4800);
  await a.waitForTimeout(4500);
  const progress = async page => page.evaluate(() => {
    const controller = AppState.get('ViewController/scroll').renderManager.controller;
    return { fraction: controller.scroll / controller.totalHeight, route: AppState.get('Router/state'), peerCount: Multiplayer.room.players.length };
  });
  report.desktop = await progress(a); report.mobile = await progress(b);
  assert.ok(Math.abs(report.desktop.fraction - report.mobile.fraction) < 0.025, '跨视口滚动没有同步');
  report.scrollSynchronized = true;
  await a.locator('a[aria-label="Contact"]').focus(); await a.keyboard.press('Enter');
  await b.waitForFunction(() => AppState.get('ViewController/contact') === true, undefined, { timeout: 10000 });
  report.contactSynchronized = true;
  await a.screenshot({ path: path.join(output, 'sync-desktop.png') });
  await b.screenshot({ path: path.join(output, 'sync-mobile.png') });
  await a.keyboard.press('Escape');
  await b.waitForFunction(() => !AppState.get('ViewController/contact'), undefined, { timeout: 10000 });
  report.contactCloseSynchronized = true;
  assert.equal(errors.length, 0, JSON.stringify(errors));
  console.log('通过：桌面与模拟手机加入同房间、滚动位置和联系面板同步。');
} catch (error) {
  report.failure = error.message; throw error;
} finally {
  await fs.writeFile(path.join(output, 'sync-verification.json'), JSON.stringify(report, null, 2) + '\n');
  await browser.close();
}
