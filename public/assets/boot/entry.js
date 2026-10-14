import { BootSequence } from './boot.js';
import { logo, brandHeading } from './brand.js';
const overlay = document.createElement('section');
overlay.id = 'rhine-boot';
overlay.setAttribute('aria-label', 'Rhine Lab system initialization');
overlay.innerHTML = `<div id="rhine-stage" data-mode="boot">
<div id="boot-background" class="boot-background"><svg viewBox="0 0 1920 1080" preserveAspectRatio="none"><g fill="none" stroke="#fff" stroke-width="3"><path d="M-210 705C-45 705 182 704 247 567C337 377 99 306 4 435S27 680 169 631C309 584 227 314 279 111S568-113 568-113"/><circle cx="1450" cy="648" r="346"/><circle cx="1450" cy="648" r="348"/></g></svg><div class="boot-white"></div></div>
<header class="brand">${brandHeading}</header><section class="boot">
<div class="access-text"></div><div class="boot-logo">${logo}</div><div class="auth-status"><span>▪</span><span id="auth-message"></span><i></i></div>
<div class="scan"><svg viewBox="0 0 1920 1080"><g fill="none" stroke="#080a08" stroke-width="2" stroke-linecap="round"><path/><path stroke="#fff"/><path/><path/><path/><path/><circle class="orbit-dot" r="8" fill="#ed821b" stroke="none"/><circle class="orbit-dot" r="8" fill="#ed821b" stroke="none"/><circle class="scan-core" cx="960" cy="540" r="5" fill="#080a08" stroke="none"/></g></svg><span></span></div>
<div class="welcome"><div class="welcome-panel"></div><div class="welcome-heading"></div><div class="welcome-company"><strong>RHINE LAB.LLC.</strong><strong class="welcome-highlight" aria-hidden="true">RHINE LAB.LLC.</strong></div><div class="welcome-database"></div><div class="welcome-logo">${logo}</div></div></section>
<div class="powered">POWERED BY <b>RHINE LAB</b><i></i></div></div>
<div class="load-status"><span role="status">INITIALIZING ARCHIVE</span><button disabled>PREPARING SCENE</button></div>`;
document.body.append(overlay);
const stage = overlay.querySelector('#rhine-stage');
const sequence = new BootSequence(stage);
const status = overlay.querySelector('[role="status"]');
const button = overlay.querySelector('button');
function resize() {
  const portrait = innerWidth / innerHeight < .8;
  const width = portrait ? 900 : 1920;
  const scale = portrait ? innerWidth / 900 : Math.min(innerWidth / 1920, innerHeight / 1080);
  stage.classList.toggle('portrait', portrait);
  stage.style.width = width + 'px';
  stage.style.height = (portrait ? innerHeight / scale : 1080) + 'px';
  stage.style.transform = `translate(-50%,-50%) scale(${scale})`;
}
resize(); addEventListener('resize', resize);
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
const begin = performance.now();
let skip = reduced, settled = 0, released = false;
button.addEventListener('click', () => { skip = true; });
function tick(now) {
  const time = Math.min(20.9, skip ? 20.9 : (now - begin) / 1000 + 1.76);
  sequence.update(time);
  const engine = window.rhineBoot;
  const percent = Math.min(99, Math.floor(engine.percent * 100));
  status.textContent = engine.loaded ? 'ARCHIVE ONLINE / 14 RECORDS' : `LOADING SCENE / ${String(percent).padStart(2, '0')}%`;
  button.disabled = !engine.loaded;
  button.textContent = engine.loaded ? 'ENTER ARCHIVE ↗' : 'PREPARING SCENE';
  if (time === 20.9 && engine.loaded) {
    settled ||= now;
    if (now - settled > 850 && !released) {
      released = true;
      engine.release();
      removeEventListener('resize', resize);
      return;
    }
  }
  requestAnimationFrame(tick);
}
requestAnimationFrame(tick);
