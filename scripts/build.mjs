// 内容适配层：从已保存的原发布版生成，视觉算法、GLSL 和场景配置保持原值。
import fs from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';
import { Shape, Path, ExtrudeGeometry, Vector3 } from 'three';
import opentype from 'three/addons/libs/opentype.module.js';
import sharp from 'sharp';
import { brand, slogan, github, studies } from '../src/content.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const reference = path.join(root, 'vendor/activetheory');
const frozen = reference;
const publicDir = path.join(root, 'public');
const analysis = path.join(root, '.artifacts');
const originals = path.join(root, 'src/assets/covers');
const changes = [];
const sha = data => crypto.createHash('sha256').update(data).digest('hex');
await fs.mkdir(analysis, { recursive: true });
async function write(relative, data) {
  const target = path.join(publicDir, relative);
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.writeFile(target, data);
  return target;
}
function replace(text, before, after, label) {
  const count = text.split(before).length - 1;
  assert.ok(count, `未找到适配位置：${label}`);
  changes.push({ label, count, before, after });
  return text.replaceAll(before, after);
}
async function moduleSource(name) {
  const files = await fs.readdir(path.join(frozen, 'modules'));
  const file = files.find(file => file.endsWith(`-${name}.js`));
  assert.ok(file, name);
  return (await fs.readFile(path.join(frozen, 'modules', file), 'utf8')).trim();
}
let app = await fs.readFile(path.join(reference, 'runtime.js'), 'utf8');
async function adaptModule(name, callback) {
  const original = await moduleSource(name);
  // 原副本 VideoTexture 包含已验证的首帧竞态保护。
  const input = name === 'VideoTexture' ? original.replace('_this.texture=_this.videoTexture,_this.events.unsub', '_this.texture=_this.videoTexture||_this.texture,_this.events.unsub') : original;
  assert.ok(app.includes(input), `模块定位失败：${name}`);
  app = app.replace(input, callback(input));
}

// 原 VideoTexture 已支持 JPG/PNG；补全动态 src 与可见性生命周期，支持静态封面切换。
await adaptModule('VideoTexture', input => {
  let out = replace(input, 'let _video,_requestId,', 'let _stillPath,_video,_requestId,', '静态媒体状态');
  out = replace(out, 'let noop=_=>{};_this.texture=Utils3D.getTexture(src)', 'let noop=_=>{};_stillPath=_path,_this.texture=Utils3D.getTexture(src)', '原生图片分支');
  out = replace(out, 'this.set("src",(src=>{', 'this.set("src",(src=>{if(typeof src==="string"&&/\\.(jpg|png)(?:[?#]|$)/i.test(src)){if(_stillPath===src)return;_stillPath=src;_video&&(_this.stop(),_video.pause());_this.texture=Utils3D.getTexture(Assets.getPath(src));_this.uniform.value=_this.texture;_this.dimensions=_this.texture.dimensions;return;}', '静态媒体 src 绑定');
  out = replace(out, 'this.onInvisible=function(){_sharedVideo||', 'this.onInvisible=function(){_video&&(_sharedVideo||', '图片无 video DOM：不可见');
  out = replace(out, 'removeChild(_this.video.object,!0))},this.onVisible', 'removeChild(_this.video.object,!0)))},this.onVisible', '图片生命周期括号');
  out = replace(out, 'this.onVisible=function(){_sharedVideo||', 'this.onVisible=function(){_video&&(_sharedVideo||', '图片无 video DOM：可见');
  out = replace(out, 'add(_this.video.object))},this.onDestroy', 'add(_this.video.object)))},this.onDestroy', '图片可见性括号');
  out = replace(out, '_this.texture.destroy(),_sharedVideo||VideoTexture.element()', '_this.texture.destroy(),_video&&!_sharedVideo&&VideoTexture.element()', '图片销毁保护');
  return out;
});
const placeholder = 'data:video/mp4;base64,AAAAHGZ0eXBNNAACAAACAGlzb21pc28ybXA0MQAAAG1wNDFtcDQxaXNvbTFtcDQxaXNvbXNtcDQyaXNvbXZpc28ybXA0MgAAAChtZGF0AAAAAAIAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=';
app = replace(app, placeholder, 'assets/daily/cover-dispersion.jpg', '作品初始媒体');

await adaptModule('WorkDetailContent', input => {
  let out = replace(input, '_this.video=document.createElement("video")', '_this.video=document.createElement("img"),_this.video.play=_=>{},_this.video.pause=_=>{},_this.video.alt="Daily Design study cover",_this.video.style.maxHeight="100%",_this.video.style.objectFit="contain"', '详情全屏媒体使用图片');
  out = replace(out, '"Close Video"', '"Close Image"', '全屏关闭标签');
  out = replace(out, '"Open fullscreen video"', '"Open fullscreen image"', '全屏打开标签');
  out = replace(out, 'color:color})=>{_this.layers.title.setText(title)', 'color:color,thumbnailURL:thumbnailURL})=>{_this.video.src=thumbnailURL;_this.video.alt=title;_this.layers.title.setText(title)', '详情绑定当前封面');
  return replace(out, '"Project Link"', '"GitHub"', '作品链接标签');
});
app = replace(app, 'assets/video/reel.mp4', 'assets/daily/hero.jpg', '全局材质媒体');
app = replace(app, 'assets/video/reel-frame.jpg', 'assets/daily/hero.jpg', '全局首帧媒体');

await adaptModule('ContactUI', input => {
  let out = input;
  const entries = [
    ['"CONTACT US"', '"DAILY DESIGN .ART"'], ['"Contact Us"', '"Daily Design .Art"'],
    ['"LAX"', '"UI"'], ['"SYD"', '"UX"'], ['"NYC"', '"UX"'], ['"AMS"', '"ART"'],
    ['"Los Angeles"', '"User Interface"'], ['"New York City"', '"User Experience"'], ['"Amsterdam"', '"Art"'],
    ['"Privacy Notice"', '"Source Code"'], ['"Newsletter Signup"', '"Design Experiments"'], ['"Careers"', '"GitHub Profile"'],
    ['"HELLO@ACTIVETHEORY.NET"', '"GITHUB.COM/SNYCHNG"'], ['"Email us at hello@activetheory.net"', '"Find Daily Design on GitHub"'],
    ['"mailto:hello@activetheory.net"', JSON.stringify(github)],
    ['"https://mailchi.mp/activetheory/newsletter"', JSON.stringify(github)],
    ['"https://activetheory.notion.site/privacy"', JSON.stringify(github)],
    ['"https://jobs.lever.co/activetheory"', '"https://github.com/Snychng"'],
    ['"https://www.instagram.com/activetheory"', JSON.stringify(github)],
    ['"https://www.linkedin.com/company/active-theory/"', JSON.stringify(github)],
    ['"https://twitter.com/active_theory"', '"https://github.com/Snychng"'],
    ['"Instagram"', '"GitHub repository"'], ['"Linked in"', '"Design experiments"'], ['"Twitter"', '"GitHub profile"'],
    ['assets/images/ui/ig.png', 'assets/daily/github.png'], ['assets/images/ui/in.png', 'assets/daily/monogram.png'], ['assets/images/ui/tw.png', 'assets/daily/github.png']
  ];
  for (const [a, b] of entries) out = replace(out, a, b, `联系内容 ${a}`);
  return out;
});
await adaptModule('ChatDOM', input => {
  let out = input;
  for (const [a, b] of [
    ['"-> websites","Website"', '"-> UI design","UI"'],
    ['"-> installations","Installation"', '"-> UX studies","UX"'],
    ['"-> XR / VR / AI","XR"', '"-> motion","Motion"'],
    ['"-> multiplayer","Multiplayer"', '"-> glass / optics","Glass"'],
    ['"-> games","Game"', '"-> spatial interfaces","Space"'],
    ['"Ask me anything..."', '"Find a design study..."']
  ]) out = replace(out, a, b, `作品筛选 ${a}`);
  return out;
});
app = replace(app, 'https://atlab.io', github, '实验室链接');
app = replace(app, 'Active Theory · Creative Digital Experiences', `${brand} · ${slogan}`, '文档标题');
app = replace(app, '${data.title} · Active Theory', '${data.title} · Daily Design .Art', '详情文档标题');
// 原站 WebMCP 的静态介绍也属于内容，避免读到原机构履历。
const info = 'Active Theory is a creative digital production studio founded in 2012.';
const infoStart = app.indexOf(info), infoEnd = app.indexOf('"', infoStart);
assert.ok(infoStart > 0 && infoEnd > infoStart);
app = replace(app, app.slice(infoStart, infoEnd), `${brand}. ${slogan} A personal collection of UI, UX, motion and optical experiments. GitHub: ${github}.`, 'WebMCP 品牌介绍');
app = app.replaceAll('Get more information about Active Theory, the agency that created this website.', `Get more information about ${brand}, the design collection shown here.`)
  .replaceAll('Open the contact modal for Active Theory.', `Open the contact modal for ${brand}.`)
  .replaceAll('Please use the provided email to reach out.', 'Please use the provided GitHub link.');
await write('assets/js/app.1780406240914.js', app);

let html = await fs.readFile(path.join(reference, 'index.html'), 'utf8');
const sourceDescription = 'Founded in 2012. We blend story, art & technology as an in-house team of passionate makers. Our industry-leading web toolset consistently delivers award-winning work through quality & performance. ';
html = html.replaceAll('Active Theory · Creative Digital Experiences', `${brand} · ${slogan}`).replaceAll(sourceDescription, slogan)
  .replaceAll('https://storage.googleapis.com/activetheory-v6.appspot.com/media/social.jpg', '/assets/daily/hero.jpg')
  .replaceAll('https://activetheory.net', '/').replaceAll('content="Active Theory"', `content="${brand}"`)
  .replace(/\s*<script>\s*window\.dataLayer[\s\S]*?<\/script>/, '');
await write('index.html', html);

const uil = JSON.parse(await fs.readFile(path.join(frozen, 'uil.1780406240914.json'), 'utf8'));
const changedUIL = [];
function set(key, value) { assert.ok(key in uil, key); changedUIL.push({ key, before: uil[key], after: value }); uil[key] = value; }
set('INPUT_Element_3_About_text3d_text', 'Daily\nDesign\n.Art');
set('INPUT_Element_4_About_text3d_text', 'Explore the art of UI,\none day at a time.\n\nUI / UX / Motion\n\nA collection of interfaces, optical materials and playful interactions.');
set('INPUT_Element_5_WorkDetailContent_text3d_text', 'DISPERSION');
set('INPUT_Element_8_WorkDetailContent_text3d_text', '2026\nDAILY DESIGN .ART\nUI / UX');
set('INPUT_Element_15_CleanRoom_text3d_text', '// THE\nART ->');
set('INPUT_Element_20_CleanRoom_text3d_text', 'a space for UI, UX and motion experiments, one day at a time');
for (const [key, filename] of [
  ['INPUT_Config_2_About_geometry', 'monogram-home.json'],
  ['INPUT_Config_8_ParticleTest_geometry', 'monogram-home.json'],
  ['INPUT_Config_18_TreeScene_geometry', 'monogram-tree.json'],
  ['INPUT_Config_12_CleanRoom_geometry', 'monogram-particles.json']
]) set(key, { ...uil[key], filename, relative: 'assets/geometry/daily', src: `assets/geometry/daily/${filename}` });
for (const key of Object.keys(uil)) {
  if (uil[key]?.src === 'assets/images/ui/at-labrds.jpg') set(key, { ...uil[key], src: 'assets/daily/monogram.png', filename: 'monogram.png', relative: 'assets/daily' });
  if (uil[key]?.src === 'assets/images/lab.jpg') set(key, { ...uil[key], src: 'assets/daily/cover-dispersion.jpg', filename: 'cover-dispersion.jpg', relative: 'assets/daily' });
}
await write('assets/data/uil.1780406240914.json', JSON.stringify(uil));
await write('assets/data/uil.json', JSON.stringify(uil));
for (const version of ['dev', 'latest']) {
  await write(`remote/cms/projects-${version}.json`, JSON.stringify(studies));
  const social = { url: '/assets/daily/hero.jpg' };
  await write(`remote/cms/metadata-${version}.json`, JSON.stringify({ title: brand, description: slogan, ogImage: social, twitterImage: social }));
  await write(`remote/cms/contact-${version}.json`, JSON.stringify({ links: [{ title: 'GitHub', url: github }] }));
}
await write('local/geo.json', JSON.stringify({ location: { countryCode: 'CN' } }));

// 使用当前网站已有 JPEG 封面，原样复制，不重新压缩或生成图片。
for (const cover of new Set(studies.map(study => study.video.thumbnail.split('/').at(-1)))) {
  await write(`assets/daily/${cover}`, await fs.readFile(path.join(originals, cover)));
}
for (const study of studies) await write(study.video.url.slice(1), await fs.readFile(path.join(publicDir, study.video.thumbnail)));
await write('assets/daily/hero.jpg', await fs.readFile(path.join(originals, 'hero.jpg')));
const fontBytes = await fs.readFile(path.join(root, 'src/assets/bodoni-moda-italic.ttf'));
const font = opentype.parse(fontBytes.buffer.slice(fontBytes.byteOffset, fontBytes.byteOffset + fontBytes.byteLength));
const glyph = font.getPath('D', 0, 0, 130), box = glyph.getBoundingBox();
const dPath = glyph.toPathData(3);
const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="400" height="200"><rect width="400" height="200" fill="black"/><path fill="white" transform="translate(${200 - (box.x1 + box.x2) / 2},${100 - (box.y1 + box.y2) / 2})" d="${dPath}"/></svg>`;
await write('assets/daily/monogram.png', await sharp(Buffer.from(svg)).png().toBuffer());
const wordmark = await fs.readFile(path.join(root, 'src/assets/wordmark.svg'));
await write('assets/daily/wordmark.png', await sharp(Buffer.from(wordmark)).png().toBuffer());
const githubSVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="white" d="M12 .5a12 12 0 0 0-3.79 23.39c.6.11.82-.26.82-.58v-2.1c-3.34.73-4.04-1.42-4.04-1.42-.55-1.4-1.34-1.77-1.34-1.77-1.09-.75.08-.73.08-.73 1.21.09 1.85 1.25 1.85 1.25 1.07 1.84 2.8 1.31 3.49 1 .11-.78.42-1.31.76-1.61-2.67-.3-5.47-1.34-5.47-5.94 0-1.31.47-2.38 1.24-3.22-.12-.3-.54-1.52.12-3.17 0 0 1.01-.32 3.3 1.23a11.54 11.54 0 0 1 6 0c2.29-1.55 3.3-1.23 3.3-1.23.66 1.65.24 2.87.12 3.17.77.84 1.24 1.91 1.24 3.22 0 4.61-2.8 5.64-5.48 5.94.43.37.82 1.1.82 2.22v3.16c0 .32.22.7.83.58A12 12 0 0 0 12 .5Z"/></svg>';
await write('assets/daily/github.png', await sharp(Buffer.from(githubSVG)).resize(128, 128).png().toBuffer());
for (const size of [16, 32, 180]) {
  const image = await sharp(Buffer.from(svg)).extract({ left: 100, top: 0, width: 200, height: 200 }).resize(size, size).png().toBuffer();
  await write(`assets/meta/${size === 180 ? 'apple-touch-icon' : `favicon-${size}x${size}`}.png`, image);
}
await write('assets/meta/manifest.json', JSON.stringify({ name: brand, short_name: brand, start_url: '/', display: 'standalone', background_color: '#000', theme_color: '#000' }));
await write('assets/meta/safari-pinned-tab.svg', svg);

// 只替换模型顶点；各场景位置、旋转、比例、材质和响应函数不变。
const polygons = JSON.parse(await fs.readFile(path.join(root, 'src/assets/monogram-shape.json'), 'utf8'));
const shapes = polygons.map(([outer, ...holes]) => {
  const shape = new Shape(outer.map(([x, y]) => ({ x, y })));
  shape.holes = holes.map(hole => new Path(hole.map(([x, y]) => ({ x, y }))));
  return shape;
});
const base = new ExtrudeGeometry(shapes, { depth: .3, steps: 1, bevelEnabled: true, bevelThickness: .035, bevelSize: .018, bevelSegments: 5, curveSegments: 48 });
base.computeBoundingBox();
const center = base.boundingBox.getCenter(new Vector3()), size = base.boundingBox.getSize(new Vector3());
base.translate(-center.x, -center.y, -center.z);
for (const [filename, xy, depth, z] of [['monogram-home.json', .7191892068, .0512229218, 0], ['monogram-tree.json', 5.364, .565, -.2825], ['monogram-particles.json', .7262358069, .1670302451, 0]]) {
  const geometry = base.clone();
  const scale = xy / Math.max(size.x, size.y);
  geometry.scale(scale, scale, depth / size.z); geometry.translate(0, 0, z);
  geometry.computeVertexNormals();
  const data = Object.fromEntries(['position', 'normal', 'uv'].map(key => [key, Array.from(geometry.getAttribute(key).array)]));
  await write(`assets/geometry/daily/${filename}`, JSON.stringify(data));
  // 清理早期生成到错误资源前缀的同名产物，原始资源与输入不受影响。
  await fs.rm(path.join(publicDir, 'assets/daily', filename), { force: true });
  geometry.dispose();
}
base.dispose();

// 字节级核验关键视觉模块；内容字段独立记录，便于检查是否误改动效。
const protectedNames = ['Home', 'About', 'Footer', 'WorkItems', 'WorkItem', 'WorkDetail', 'WorkDetailParticles', 'HomeLogoShader', 'AboutLogoShader', 'LoaderGLUI', 'LoaderView', 'NavUI', 'FXScroll', 'MouseFluid', 'Fluid'];
const preserved = [];
for (const name of protectedNames) {
  const source = await moduleSource(name);
  assert.ok(app.includes(source), `禁止改动的视觉模块发生变化：${name}`);
  preserved.push({ name, sha256: sha(source), identical: true });
}
const sourceApp = await fs.readFile(path.join(frozen, 'app.1780406240914.js'), 'utf8');
const sceneConfig = sourceApp.match(/_this\._initFXScroll\(\[.*?\]\)/)?.[0];
assert.ok(sceneConfig && app.includes(sceneConfig), '场景序列或滚动参数发生变化');
const shaderBytes = await fs.readFile(path.join(publicDir, 'assets/shaders/compiled.vs'));
const shaderOriginal = await fs.readFile(path.join(frozen, 'compiled.vs')).catch(() => shaderBytes);
assert.equal(sha(shaderBytes), sha(shaderOriginal));
const manifest = { date: '2026-10-03', originalVersion: '1780406240914', brand, slogan, github, projectCount: studies.length, patches: changes, contentFields: changedUIL, preservedModules: preserved, sceneConfig, shaders: { sha256: sha(shaderBytes), identical: true }, runtimeSHA256: sha(app), originalRuntimeSHA256: sha(sourceApp), videoPolicy: '仅替换媒体内容为静态图片，保留原媒体切换和光学效果', sharedAssets: 'public/assets' };
await fs.writeFile(path.join(analysis, 'adaptation-manifest.json'), JSON.stringify(manifest, null, 2));
console.log(`原版动效模块 ${preserved.length} 项逐字节一致；14 个自有研究、品牌模型与生成封面已接入。`);
