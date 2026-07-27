# PuTTY AI 静态宣传站

此目录是 `ai.jiaolian.help` 的静态站点根目录。将其中全部内容上传到站点根目录即可发布。

## 发布内容

- `index.html`：中文产品介绍页面，包含 Open Graph、JSON-LD 和 FAQ 结构化数据。
- `styles.css`：不依赖构建工具的响应式样式。
- `assets/putty-ai-interface.png`：PuTTY AI 已验证版本的真实界面截图。
- `downloads/`：v1.0.4 Windows x64 压缩包与 SHA-256 校验文件。
- `robots.txt` 与 `sitemap.xml`：搜索引擎抓取入口。

## 部署后检查

1. 将 `https://ai.jiaolian.help/` 设为 HTTPS 主地址，并将 HTTP 请求重定向到 HTTPS。
2. 确认 `/downloads/PuTTY-AI-v1.0.4-windows-x64.zip` 返回文件下载，而不是 HTML 错误页。
3. 在站长平台提交 `https://ai.jiaolian.help/sitemap.xml`。
4. 发布新版本时，同时更新 `index.html` 中的版本、发布日期、校验值、下载链接和 `sitemap.xml` 的日期。

页面中的源码链接指向 <https://github.com/AI-DIY/PuTTY-AI>。
