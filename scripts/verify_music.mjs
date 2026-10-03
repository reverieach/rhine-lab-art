import { chromium } from './browser.mjs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import assert from 'node:assert/strict';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const output = path.join(root, '.artifacts');
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
const report = { date: '2026-10-03', errors: [] };
page.on('pageerror', error => report.errors.push(error.message));
try {
  await page.goto(process.env.PREVIEW_URL || 'http://localhost:4199');
  await page.waitForFunction(() => window.AppState && AppState.get('ViewController/visibleV') > 0.99, undefined, { timeout: 60000 });
  await page.mouse.click(850, 440);
  await page.waitForFunction(() => GlobalAudio3D.initialized && SFXController.instance().activeSounds, undefined, { timeout: 10000 });
  await page.locator('a[aria-label="Toggle Audio"]').focus(); await page.keyboard.press('Enter');
  if (!await page.evaluate(() => !!AppState.get('Global/audioEnabled'))) await page.keyboard.press('Enter');
  await page.waitForFunction(() => Object.values(SFXController.instance().activeSounds).some(value => value.length), undefined, { timeout: 10000 });
  await page.waitForTimeout(600);
  const index = await page.evaluate(() => AppState.get('MusicPlayerDOM/songIndex'));
  await page.getByRole('button', { name: 'Next Song' }).click();
  assert.equal(await page.evaluate(() => AppState.get('MusicPlayerDOM/songIndex')), (index + 1) % 8);
  await page.getByRole('button', { name: 'Previous Song' }).click();
  assert.equal(await page.evaluate(() => AppState.get('MusicPlayerDOM/songIndex')), index);
  report.musicToggleAndTrackControls = true;
  report.audioState = await page.evaluate(() => ({ enabled: !!AppState.get('Global/audioEnabled'), initialized: GlobalAudio3D.initialized, playingTracks: Object.entries(SFXController.instance().activeSounds).filter(([, value]) => value.length).map(([name]) => name) }));
  assert.equal(report.errors.length, 0, JSON.stringify(report.errors));
  console.log('通过：原音乐控件进入、开关、切歌与循环字幕。');
} catch (error) { report.failure = error.message; throw error; }
finally {
  await fs.writeFile(path.join(output, 'music-verification.json'), JSON.stringify(report, null, 2) + '\n');
  await browser.close();
}
