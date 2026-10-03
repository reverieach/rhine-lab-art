# open-active-theory

Daily Design .Art 品牌网站：沿用 Active Theory 发布版 Hydra/WebGL 的六场景、镜头、粒子、流体、玻璃折射与交互，替换为自有品牌、D 模型、UI/UX 研究、静态封面和 GitHub 联系方式。

仓库只包含这个网站的源码、必要运行资源、构建和验证脚本。没有其他原型、研究截图、录屏、社交封面、平台生图请求、账户资料或 node_modules。资源已收进仓库，不需要原 ui-ux 工作区、相邻 ActiveTheory 目录或 macOS 系统字体。

## 安装与运行

需要 Node.js 20 或更新版本。

```bash
git clone https://github.com/Snychng/open-active-theory.git
cd open-active-theory
npm ci
npm run build
npm run dev
```

网站入口为 `http://localhost:4199/`。`PORT=4200 npm run dev` 可指定端口。按 `Ctrl+C` 停止对应终端中的服务。服务同时提供深链接、本地作品检索和 WebSocket 同步；仅用静态文件服务不能覆盖检索与同步功能。

## 检查

```bash
npx playwright install chromium
npm test
```

`npm test` 会构建网站、启动随机端口，检查原动效参数/模块、资源与服务协议，再实际运行桌面和模拟手机的六场景、拖拽、详情、联系、筛选、检索、静态媒体和卡片激活流程。结束时自动关闭测试服务器。已有 Google Chrome 的本地环境也可运行 `PLAYWRIGHT_CHANNEL=chrome npm test`。

以下专项检查需要先启动网站，可用 `PREVIEW_URL` 指定地址：

```bash
npm run check
npm run verify
npm run verify:sync
npm run verify:music
npm run verify:media
```

检查记录与截图写入 `.artifacts/`，不提交 Git。CI 在 Ubuntu、Node.js 22 和 Playwright Chromium 上执行 `npm test`，通过 Xvfb 与 Mesa 软件 OpenGL 提供 WebGL 上下文；原站会拒绝 SwiftShader，保留此检测。失败时保存浏览器诊断报告。工程检查不代替用户视觉验收、真实手机操作或扬声器输出确认。

## 技术与源码

| 路径/技术 | 作用 |
| --- | --- |
| `src/content.mjs` | Daily Design .Art、slogan、14 项自有 UI/UX 研究与联系方式 |
| `src/assets/` | 自有 D 轮廓、Bodoni Moda 字体及许可、字标 SVG、网站实际使用的封面 |
| `vendor/activetheory/` | 公开发布版的构建基线、受保护模块与来源记录；已移除旧接口凭证字面量 |
| `scripts/build.mjs` | 精确适配运行时、UIL 与 CMS，生成品牌几何、贴图和页面，并核验核心动效未改动 |
| `public/` | 网站可直接使用的运行包、GLSL、模型、纹理、字形图集、解码器与音乐 |
| `scripts/server.mjs` | Node.js 原生 HTTP 与 ws，资源、Range、路由、关键词检索及设备同步 |
| Hydra / WebGL / GLSL | 实时场景、GLUI 文字、GPU 粒子与流体、折射、场景转场及后期合成 |
| Three.js / opentype / Sharp | 构建时生成 D 几何、纹理与图标；网页运行时继续使用 Hydra |
| Playwright | 桌面/手机浏览器交互与资源检查 |

渲染链路：输入与滚动 → 场景状态与相机 → 模型、文字和粒子 → 双场景纹理转场 → 流体折射、色散、Bloom 与光芒合成 → Canvas。

## 保留、替换与边界

- 保留 Home、About、Work、TreeScene、CleanRoom、Footer 六场景及原加载、滚动、拖拽、玻璃、粒子、详情、导航、音乐和同步机制。
- 15 个关键视觉模块保留原发布版实现；UIL 仅替换品牌模型、文字和媒体字段，其他 2578 项保持原值。新仓库没有重新设计原站动效。
- 品牌为 Daily Design .Art，slogan 为 `Explore the art of UI, one day at a time.`。作品链接仍沿用原项目配置 `https://github.com/Snychng/daily-design`。
- 四处品牌几何/纹理使用自有斜体 D，14 项作品属于自有实验或明确标注的概念研究，不声称商业案例。
- 作品视频已按用户要求替换为静态封面，承载媒体的折射、淡入和全屏交互保留；没有保留项目视频。
- 原站私有 AI 由本地关键词检索承接客户端协议，没有原服务或生成式模型；无需任何 API 密钥。
- 原站本身缺失的 `lab.gif` 和 `damaged_road_normal.jpg` 继续沿用引擎回退，不把替代材质说成原始资源。
- 随机粒子、GPU 档位与品牌内容会产生画面差异，工程核验不等于每帧像素完全一致。

规则见 [AGENTS.md](AGENTS.md)，独立仓库取舍见 [.agents/notes](.agents/notes/README.md)，第三方来源见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
