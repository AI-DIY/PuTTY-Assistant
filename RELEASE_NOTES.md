# PuTTY-Assistant v1.0.6

项目已从旧名称 `PuTTY AI` 更名为 `PuTTY-Assistant`。历史压缩包文件名暂时保留 `PuTTY-AI-...`，以兼容已有下载链接。

Release date: 2026-07-29

This maintenance release makes the initial window geometry visible for both
new and previously saved PuTTY sessions.

- Sizes the first window from the active monitor's working area (68% wide by
  62% high), producing a balanced terminal-and-AI workspace on modern screens.
- Prevents a saved classic 80x24 terminal grid from recreating the cramped
  first-window proportions seen in v1.0.5.
- Preserves the classic terminal-grid defaults; the larger initial workspace is
  now controlled directly by window layout rather than terminal configuration.
- Updates the executable version and Windows x64 distribution to v1.0.6.

Windows users can download `PuTTY-AI-v1.0.6-windows-x64.zip`, extract it, and
run `putty.exe`.

# PuTTY-Assistant v1.0.5

Release date: 2026-07-29

This maintenance release improves the first-launch workspace proportions for
the native Windows client.

- Expands the default terminal grid from 80x24 to 104x36, giving the terminal
  and persistent AI panel a more balanced initial canvas.
- Keeps existing saved sessions unchanged: their configured terminal dimensions
  continue to take precedence.
- Updates the executable version and Windows x64 distribution to v1.0.5.

Windows users can download `PuTTY-AI-v1.0.5-windows-x64.zip`, extract it, and
run `putty.exe`.

# PuTTY-Assistant v1.0.4

Release date: 2026-07-27

This release packages the current Windows client as v1.0.4 after completing the full release regression suite.

- Updates the executable version and Windows x64 distribution to v1.0.4.
- Adds a reviewed global functional test matrix and release-site consistency check.
- Verifies standalone C tests, Unicode normalization vectors, normal and high-risk UI flows, and a public SSH handshake before publication.

Windows users can download `PuTTY-AI-v1.0.4-windows-x64.zip`, extract it, and run `putty.exe`.

# PuTTY-Assistant v1.0.3

Release date: 2026-07-27

This maintenance release fixes Windows UI responsiveness and repainting regressions and raises the configurable terminal-context limit to 1,000,000 characters.

- Prevents cross-process session metadata queries from blocking PuTTY when switching between applications or when another PuTTY UI thread is unresponsive.
- Prevents stale frame pixels after resizing from the left, right, top, or bottom edge.
- Preserves a 1,000,000-character context limit through saving and a later process startup.
- Adds end-to-end regression coverage for window switching, suspended UI threads, interactive resizing, and settings persistence.

Windows users can download `PuTTY-AI-v1.0.3-windows-x64.zip`, extract it, and run `putty.exe`.

# PuTTY-Assistant v1.0.2

发布日期：2026-07-26

这是 `v1.0.1` 之后的维护版本，集中完成 AI 侧边栏、流式输出、窗口框架、自动化启动和连接稳定性优化。项目由独立开发者维护，与 PuTTY、OpenAI、模型服务商或堡垒机产品供应商不存在隶属、授权、赞助或官方关联。

## 主要功能

- 原生 Windows SSH 客户端与 AI 侧边栏。
- Chat Completions 兼容接口、流式响应和中文多轮会话。
- Markdown 富文本渲染，区分用户、助手、系统和错误消息。
- 终端上下文默认关闭，启用后会先进行敏感信息脱敏。
- 候选命令只回填、不自动执行；高风险命令需要二次确认。
- 支持自动化启动、UTF-8 临时配置文件和连接保活。
- 按设计实现无原生标题栏界面、贯穿整窗的 44/46 像素双层主机栏、冷灰色 440 像素 AI 面板，以及黑色全局栏中的最小化、最大化/还原和关闭按钮。
- 顶部主机标签可在多个 PuTTY 进程之间切换，每个主机保留独立的 AI 多轮会话。
- 全局最小化、最大化/还原和关闭会同步作用于所有运行中的 PuTTY 会话，关闭时保留每个会话原有的确认保护。
- 主机信息栏会显示已配置或 SSH `login as:` 提示中实际输入的登录用户；无法可靠获取时自动隐藏用户项和会话标签占位符。
- 终端上下文改为输入区下方的切换按钮；会话历史始终在当前主机内保留且不再显示保存选项；清空对话使用独立按钮。
- 候选命令改为代码块悬浮“填入终端”，危险命令显示“检查并填入”。
- 流式 Markdown 重绘会保留用户向上阅读的位置，回到底部后恢复自动跟随。
- 首次窗口在当前显示器工作区居中；上下文文字和开关紧凑排列；用户与明确标注的“AI 助手”回复使用细线分隔。
- 主窗口使用连续的一像素自绘外框，终端与 AI 面板完整包在同一边框内，并关闭 DWM 残留非客户区绘制。
- “你”和“AI 助手”使用统一的中英文字体、字号和字重；流式 Markdown 重绘不再覆盖角色标题格式。

## 隐私与安全

- 正式版不会记录原始启动命令行，避免密码、用户名和主机信息进入诊断日志。
- 持久化 API Key 使用 Windows DPAPI 按当前用户加密，不以明文写入注册表。
- 元数据审计日志不记录问题、回复、终端上下文、命令正文或 API Key。

## 下载与校验

Windows 用户下载 `PuTTY-AI-v1.0.2-windows-x64.zip`，解压后直接运行 `putty.exe`。发布页同时提供独立的 `putty.exe` 和 SHA-256 校验值，压缩包内也包含文件级 `SHA256SUMS.txt`。
