# README 展示截图

## 当前莱茵生命版本

以下三张来自 2026-10-14 本地网站的实际浏览器录制，网站代码对应 `ba6554a`。使用 FFmpeg 从 1920×1080 H.264 成片提取 PNG；没有生成式重绘、锐化或额外放大，保留成片两侧的窄黑边。它们是实时网页的录制帧，不是原始 CG 文件，也不代表无损截图。成片与录制脚本保留在本地，不提交仓库。

| 展示文件 | 成片时点 | 场景 |
| --- | --- | --- |
| rhine-boot.png | 20 秒 | RhineLabUI 深色欢迎页 |
| rhine-archive.png | 45 秒 | CG 卡片与原始粒子场景 |
| rhine-belonging.png | 96 秒 | 第十三张展品 Belonging 与鼠标扰动 |

画面包含第三方 CG、标志和渲染素材，来源与许可见根目录 `THIRD_PARTY_NOTICES.md`；截图不会改变其权利归属。

## 原项目历史截图

这六张图来自独立网站实际运行的 scripts/verify.mjs 检查，采集日期 2026-10-03，Chrome 154.0.8037.93。网页应用版本对应已发布的 4bbbc9d；用于采集的桌面与移动端浏览器检查均通过。

桌面视口 1440 × 900；移动端为 Pixel 7 模拟，视口 390 × 844、deviceScaleFactor 1。图像从 .artifacts/screenshots/ 原样复制为 PNG，没有裁切、修图或生成式重绘。

| 展示文件 | 原采集文件 | 场景 | 原文件时间（UTC） |
| --- | --- | --- | --- |
| brand-scene.png | desktop-daily-home-about-transition.png | 品牌与 Home/About 转场 | 2026-10-03T10:42:26.525Z |
| home.png | desktop-daily-home.png | Home 首屏 | 2026-10-03T10:42:17.961Z |
| work.png | desktop-daily-work.png | Work 作品墙 | 2026-10-03T10:42:32.022Z |
| lab.png | desktop-daily-lab.png | CleanRoom 光学实验 | 2026-10-03T10:42:37.707Z |
| detail.png | desktop-daily-detail.png | Dispersion 详情 | 2026-10-03T10:42:47.646Z |
| mobile-work.png | mobile-daily-work.png | 移动端 Work | 2026-10-03T10:43:25.463Z |

## 更新方式

1. 按仓库 README 安装依赖与浏览器，运行 npm test 获取新的网页运行截图。
2. 实际打开截图，核对场景、文字、加载状态和图形错误后，按上表选择对应画面。
3. 仅复制确认的展示图至本目录；同步 README 图注与本文件的采集条件。
4. 原始检查记录继续保留于被 Git 忽略的 .artifacts/，不提交整套报告与截图。

静态截图不能证明完整动效或真实手机验收。
