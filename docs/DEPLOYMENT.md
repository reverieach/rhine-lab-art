# 部署说明

需要 Node.js 24+。先执行 `npm ci` 和 `npm run build`，再用 `npm start` 启动。服务读取 `HOST` 与 `PORT` 环境变量，不需要云 API 密钥。

## Ubuntu / Nginx

`deploy/rhine-lab.service` 与 `deploy/rhine-lab.nginx.conf` 是部署示例，不包含任何生产凭据。

1. 将项目放到 `/opt/rhine-lab`，或同步调整 service 文件中的运行目录。
2. 创建无登录权限的 `rhine-lab` 服务用户，使其能够读取项目。核对 Node 可执行文件路径；示例使用 `/usr/local/bin/node`。
3. 安装 systemd 单元，执行 `systemctl daemon-reload` 并启用服务。示例仅监听 `127.0.0.1:4199`。
4. 将 Nginx 示例中的 `example.com` 换成自己的域名，安装为站点配置；执行 `nginx -t` 后再重载。
5. 为自己的域名配置 DNS、HTTPS 和续期。不要用本仓库的 HTTP 示例覆盖已经配置好的证书与跳转。只按需要开放公网 80/443，Node 的 4199 端口保持内部访问。

检查首页、`/work/daybreak` 等深链接、十四幅展品、音乐与 `/ws`。证书续期需要单独验证。域名合规要求与云平台账户流程由部署者按实际环境办理；本仓库不记录任何个人备案或账户信息。

## Render 模板

连接仓库并使用根目录的 `render.yaml`。构建命令为 `npm ci --include=dev && npm run build`，启动命令为 `npm start`。模板声明 `plan: free`，实际可用性、费用和限额以创建时的平台页面为准；该模板不构成已部署或国内可达的保证。
