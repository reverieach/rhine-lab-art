// 封面可复用，但原站媒体标识与激活条件必须只对应当前卡片。
import { chromium } from './browser.mjs';
import fs from 'node:fs/promises';
import assert from 'node:assert/strict';
const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
const report = { errors: [], states: [] };
page.on('pageerror', error => report.errors.push(error.message));
try {
  await page.goto(process.env.PREVIEW_URL || 'http://localhost:4199');
  await page.waitForFunction(() => window.AppState && AppState.get('ViewController/visibleV') > .99, null, { timeout: 90000 });
  await page.evaluate(() => CMSData.workPages.refresh(CMS_DATA.projects.slice(0, 14)));
  await page.waitForTimeout(4500);
  for (const fraction of [.08, .32, .64, .88]) {
    await page.evaluate(fraction => { const s = AppState.get('ViewController/scroll'), w = s.views[2]; s.scrollTo(w.start + (w.end - w.start) * fraction, 0); }, fraction);
    // 软件 OpenGL 的帧率与纹理上传较慢，按真实目标卡片的淡入状态等待。
    await page.waitForFunction(fraction => {
      const scroll = AppState.get('ViewController/scroll'), work = scroll.views[2];
      if (Math.abs(scroll.renderManager.controller.scroll - (work.start + (work.end - work.start) * fraction)) > 2) return false;
      const items = work.layers.items.viewState.views, src = AppState.get('WorkItems/videoURL');
      const blend = view => view.group.children.find(mesh => mesh.shader?.uniforms?.uVideoBlend)?.shader.uniforms.uVideoBlend.value ?? 0;
      const matching = items.filter(view => view.data.videoURL === src);
      return matching.length === 1 && blend(matching[0]) > .9 && items.filter(view => blend(view) > .9).length === 1;
    }, fraction, { timeout: 30000 });
    const state = await page.evaluate(() => {
      const items = AppState.get('ViewController/scroll').views[2].layers.items.viewState.views;
      const src = AppState.get('WorkItems/videoURL');
      return { src, matching: items.filter(view => view.data.videoURL === src).map(view => view.data.title), blends: items.map(view => ({ title: view.data.title, blend: view.group.children.find(mesh => mesh.shader?.uniforms?.uVideoBlend)?.shader.uniforms.uVideoBlend.value })) };
    });
    report.states.push({ fraction, ...state });
    assert.equal(state.matching.length, 1);
    assert.equal(state.blends.filter(item => item.blend > .9).length, 1);
  }
  assert.equal(report.errors.length, 0);
  report.passed = true;
  console.log('通过：四处相机位置均只有当前卡片激活原媒体切换。');
} catch (error) {
  report.failure = error.message;
  report.loadState = await page.evaluate(() => {
    const s = AppState.get('ViewController/scroll');
    return { url: location.href, src: AppState.get('WorkItems/videoURL'), scroll: s?.renderManager.controller.scroll,
      items: s?.views[2]?.layers.items.viewState.views.map(view => ({ title: view.data.title, src: view.data.videoURL, blend: view.group.children.find(mesh => mesh.shader?.uniforms?.uVideoBlend)?.shader.uniforms.uVideoBlend.value })) };
  }).catch(() => null);
  console.error(JSON.stringify(report));
  throw error;
}
finally {
  await fs.writeFile(new URL('../.artifacts/media-verification.json', import.meta.url), JSON.stringify(report, null, 2));
  await browser.close();
}
