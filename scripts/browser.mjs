// CI 的 Mesa 模式通过 Xvfb 使用真实 WebGL 上下文；不改动原站 GPU 检测。
import { chromium as engine, devices } from 'playwright';
export { devices };
export const chromium = {
  launch: (options = {}) => engine.launch({
    ...(process.env.PLAYWRIGHT_CHANNEL ? { channel: process.env.PLAYWRIGHT_CHANNEL } : {}),
    ...options,
    ...(process.env.PLAYWRIGHT_MESA ? { headless: false } : {}),
    args: [
      ...(process.env.PLAYWRIGHT_MESA ? ['--use-gl=angle', '--use-angle=gl', '--ignore-gpu-blocklist'] : []),
      ...(options.args ?? [])
    ]
  })
};
