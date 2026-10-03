// 实际浏览器交互与原版对应状态对照；截图为工程检查，不替代用户验收。
import { chromium, devices } from './browser.mjs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import assert from 'node:assert/strict';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const output = path.join(root, '.artifacts');
const base = process.env.PREVIEW_URL || 'http://localhost:4199';
await fs.mkdir(path.join(output, 'screenshots'), { recursive: true });
const browser = await chromium.launch({ headless: true, args: ['--autoplay-policy=no-user-gesture-required'] });
const report = { date: '2026-10-03', browser: browser.version(), cases: [], errors: [] };
const probe = await browser.newPage();
report.graphics = await probe.evaluate(() => {
  const gl = document.createElement('canvas').getContext('webgl2');
  if (!gl) return { webgl2: false };
  const debug = gl.getExtension('WEBGL_debug_renderer_info');
  return { webgl2: true, renderer: debug && gl.getParameter(debug.UNMASKED_RENDERER_WEBGL), vendor: debug && gl.getParameter(debug.UNMASKED_VENDOR_WEBGL) };
});
console.log('浏览器图形上下文：', JSON.stringify(report.graphics));
await probe.close();

async function inspect(mobile) {
  const original = false;
  const name = `${mobile ? 'mobile' : 'desktop'}-${original ? 'reference' : 'daily'}`;
  const url = base;
  const context = await browser.newContext(mobile ? { ...devices['Pixel 7'], viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 } : { viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  const page = await context.newPage();
  const errors = [], graphicsErrors = [], missing = [], external = [], videoRequests = [];
  page.on('pageerror', e => errors.push(e.message));
  page.on('console', e => { if (/GL_INVALID_|OUT_OF_MEMORY|WebGL: too many errors/.test(e.text())) graphicsErrors.push(e.text()); });
  page.on('response', r => { if (r.status() >= 400) missing.push(r.url()); });
  await context.route('**/*', route => {
    const request = route.request().url();
    if (/\.mp4(?:\?|$)|\.webm(?:\?|$)/.test(request)) videoRequests.push(request);
    if (!request.startsWith(url) && !request.startsWith('data:') && !request.startsWith('blob:')) { external.push(request); return route.abort(); }
    return route.continue();
  });
  const item = { name, viewport: page.viewportSize(), shots: [], interactions: {}, errors, graphicsErrors, missing, external, videoRequests };
  report.cases.push(item);
  try {
    await page.goto(url, { waitUntil: 'domcontentloaded' });
    await page.waitForFunction(() => location.pathname.endsWith('/unsupported.html') || window.AppState && AppState.get('ViewController/visibleV') > .99 && AppState.get('FXScroll/initialized'), null, { timeout: 90000 });
    assert.ok(!page.url().endsWith('/unsupported.html'), `当前浏览器被原站 GPU 检测拒绝：${JSON.stringify(report.graphics)}`);
    await page.evaluate(() => CMSData.workPages.refresh(CMS_DATA.projects.slice(0, 14)));
    await page.waitForTimeout(5500);
    async function shot(label) {
      const file = `${name}-${label}.png`;
      await page.screenshot({ path: path.join(output, 'screenshots', file) });
      const state = await page.evaluate(() => {
        const scroll = AppState.get('ViewController/scroll');
        return {
          route: AppState.get('Router/state'), totalHeight: scroll.renderManager.controller.totalHeight,
          scroll: scroll.renderManager.controller.scroll, project: AppState.get('Work/project')?.perma,
          contact: !!AppState.get('ViewController/contact'),
          views: scroll.views.map(v => ({ name: v.fragName, start: v.start, end: v.end, progress: v.scrollProgress, camera: v.layers?.camera?.group?.position?.toArray?.() || null })),
          workCards: CMSData.workPages.length, videos: document.querySelectorAll('video').length
        };
      });
      item.shots.push({ label, file, state });
      console.log(`${name}: ${label}`);
    }
    await shot('home');
    const before = await page.evaluate(() => AppState.get('ViewController/scroll').views[0].layers.particles.layers.logo.rotation.y);
    if (mobile) {
      const cdp = await context.newCDPSession(page);
      await cdp.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [{ x: 100, y: 400 }] });
      for (let i = 1; i <= 20; i++) { await cdp.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [{ x: 100 + i * 6, y: 400 }] }); await page.waitForTimeout(25); }
      await cdp.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] }); await cdp.detach();
    } else { await page.mouse.move(580, 420); await page.mouse.down(); await page.mouse.move(780, 440, { steps: 20 }); await page.mouse.up(); }
    await page.waitForTimeout(600);
    const after = await page.evaluate(() => AppState.get('ViewController/scroll').views[0].layers.particles.layers.logo.rotation.y);
    assert.ok(Math.abs(after - before) > .01); item.interactions.dragRotatesLogo = true;
    await page.locator('a[aria-label="Work"]').focus(); await page.keyboard.press('Enter');
    await page.waitForFunction(() => AppState.get('Router/state') === 'work'); item.interactions.workNavigation = true;
    // 包含切场中间状态，检查斜切玻璃同时显示两个场景。
    for (const [label, scene, fraction] of [['home-mid', 'Home', .65], ['home-about-transition', 'Home', .97], ['about', 'About', .5], ['work', 'Work', .35], ['tree', 'TreeScene', .5], ['lab', 'CleanRoom', .5], ['footer', 'Footer', .62]]) {
      await page.evaluate(({ scene, fraction }) => { const scroll = AppState.get('ViewController/scroll'), view = scroll.views.find(v => v.fragName === scene); scroll.scrollTo(view.start + (view.end - view.start) * fraction, 0); }, { scene, fraction });
      await page.waitForTimeout(2400); await shot(label);
    }
    await page.evaluate(() => { const scroll = AppState.get('ViewController/scroll'); scroll.scrollTo(scroll.views[2].start + 100, 0); });
    await page.waitForTimeout(2800);
    if (mobile) await page.touchscreen.tap(195, 250);
    else { await page.mouse.move(900, 440); await page.waitForTimeout(600); await page.mouse.click(900, 440); }
    await page.waitForFunction(() => !!AppState.get('Work/project'), null, { timeout: 10000 });
    await page.waitForTimeout(350); await shot('detail-opening');
    await page.waitForTimeout(1800); await shot('detail'); item.interactions.projectDetails = true;
    if (!original) {
      const current = await page.evaluate(() => AppState.get('Work/project').thumbnailURL);
      await page.locator('a[aria-label="Open fullscreen image"]').evaluate(link => link.click());
      await page.waitForFunction(() => { const img = document.querySelector('.VideoModal img'); return img?.offsetWidth > 100 && img.complete && img.naturalWidth > 0; });
      assert.ok((await page.locator('.VideoModal img').getAttribute('src')).endsWith(current));
      await shot('fullscreen-image'); await page.getByRole('button', { name: 'Close Image', exact: true }).click();
      item.interactions.fullscreenCover = true;
    }
    await page.keyboard.press('Escape'); await page.waitForFunction(() => !AppState.get('Work/project')); await page.waitForTimeout(1000);
    item.interactions.escapeClosesDetails = true;
    await page.locator('a[aria-label="Contact"]').focus(); await page.keyboard.press('Enter');
    await page.waitForFunction(() => AppState.get('ViewController/contact')); await page.waitForTimeout(500); await shot('contact-opening');
    await page.waitForTimeout(1700); await shot('contact'); item.interactions.contactOpens = true;
    // 原站聊天面板隐藏有 3 秒过渡；等完成后再关闭联系人，避免测试打断它。
    await page.locator('.ChatDOM .wrapper').waitFor({ state: 'hidden' });
    await page.keyboard.press('Escape'); await page.waitForFunction(() => !AppState.get('ViewController/contact')); item.interactions.escapeClosesContact = true;
    if (!original) {
      // 手机的聊天入口仅在 Work 中段显示；先进入真实可操作状态。
      await page.evaluate(() => { const s = AppState.get('ViewController/scroll'), w = s.views[2]; s.scrollTo(w.start + (w.end - w.start) * .35, 0); });
      await page.locator('.ChatDOM a[title="-> motion"]').waitFor({ state: 'visible' });
      await page.waitForFunction(() => AppState.get('ViewController/uniforms')?.uChatOpen?.value > .99);
      await page.locator('.ChatDOM a[title="-> motion"]').click();
      await page.waitForFunction(() => {
        const projects = CMSData.workPages.toJSON();
        return projects.length > 0 && projects.every(project => project.tags.includes('motion'));
      });
      const tags = await page.evaluate(() => CMSData.workPages.toJSON().map(p => p.tags));
      assert.ok(tags.length && tags.every(tag => tag.includes('motion'))); item.interactions.filter = { tag: 'motion', count: tags.length };
      const input = page.locator('.ChatDOM textarea').first(); await input.fill('Dispersion'); await input.press('Enter');
      await page.waitForFunction(() => AppState.get('Work/project')?.perma === 'dispersion', null, { timeout: 15000 });
      await page.waitForFunction(() => !AppState.get('InteractAIAssistant/isThinking')); await page.waitForTimeout(3000);
      await shot('search-detail'); item.interactions.search = 'dispersion';
      assert.equal(await page.locator('video').count(), 0); assert.equal(videoRequests.length, 0);
    }
    assert.equal(errors.length, 0, JSON.stringify(errors)); assert.equal(graphicsErrors.length, 0, JSON.stringify(graphicsErrors)); assert.equal(external.length, 0, JSON.stringify(external));
    assert.ok(missing.every(url => /\/assets\/images\/(lab\.gif|pbr\/damaged_road_normal\.jpg)$/.test(url)), JSON.stringify(missing));
    item.passed = true;
  } catch (error) {
    item.failure = error.message;
    item.loadState = await page.evaluate(() => ({
      url: location.href,
      title: document.title,
      ready: document.readyState,
      canvasCount: document.querySelectorAll('canvas').length,
      visible: window.AppState?.get('ViewController/visibleV'),
      initialized: window.AppState?.get('FXScroll/initialized')
    })).catch(() => null);
    console.error(JSON.stringify(item));
    throw error;
  } finally { await context.close(); await fs.writeFile(path.join(output, 'runtime-verification.json'), JSON.stringify(report, null, 2)); }
}
try {
  for (const mobile of [false, true]) await inspect(mobile);
  report.passed = true; console.log('通过：独立网站桌面与手机的六场景、过渡、拖拽、详情、联系、筛选与静态媒体。');
} catch (error) { report.failure = error.message; throw error; }
finally { await browser.close(); await fs.writeFile(path.join(output, 'runtime-verification.json'), JSON.stringify(report, null, 2)); }
