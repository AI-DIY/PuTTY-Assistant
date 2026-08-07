# PuTTY-Assistant 静态站

此目录是 `ai.jiaolian.help/putty-ai` 的静态站点内容目录。`/putty-ai` 路径作为旧入口保留，用于承接历史搜索和下载链接；`/putty-assistant` 会重定向到该路径。页面品牌已更新为 PuTTY-Assistant。随附的 Nginx 配置会将它挂载为该路径的站点根目录。

## 发布内容

- `index.html`：中文产品介绍页面，包含 Open Graph、JSON-LD 和 FAQ 结构化数据。
- `styles.css`：不依赖构建工具的响应式样式。
- `assets/putty-ai-interface.png`：PuTTY-Assistant 已验证版本的真实界面截图。
- `downloads/`：v1.0.4 Windows x64 压缩包与 SHA-256 校验文件。
- `robots.txt` 与 `sitemap.xml`：搜索引擎抓取入口。

## 部署后检查

1. 确认 `http://ai.jiaolian.help/putty-ai` 返回首页，且 `/putty-ai/downloads/PuTTY-AI-v1.0.4-windows-x64.zip` 返回文件下载而不是 HTML 错误页。
2. 在站长平台提交 `http://ai.jiaolian.help/putty-ai/sitemap.xml`。
3. 发布新版本时，同时更新 `index.html` 中的版本、发布日期、校验值、下载链接和 `sitemap.xml` 的日期。
4. 需要 HTTPS 时，应在此 Nginx 容器前配置 TLS 终止，并将页面中的规范 URL、站点地图和 robots 文件统一改为 HTTPS 地址。

页面中的源码链接指向 <https://github.com/AI-DIY/PuTTY-Assistant>。当前站点介绍的是 AI 助手阶段；面向封闭式内网、堡垒机合规、操作审计和安全控制的 Terminal-Agent 正在另一个仓库中开发：<https://github.com/AI-DIY/Terminal-Agent>。
