---

### 📄 文件 2：中文版 (README_CN.md)
*建议保存为 `README_CN.md`，并在英文版开头加一行链接指向这里。*

```markdown
# 🦞 OpenClaw 自定义镜像：无界版 (Limitless Edition)

> **解锁 OpenClaw 的全部潜能：集成 Homebrew、Python AI 全栈环境及动态扩展能力。**
> *打破官方镜像的限制，赋予你的 Agent 运行时安装任何工具的能力。*

[![Docker Image](https://img.shields.io/badge/Docker%20Hub-591124281yj228%2Fopenclaw__ready-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/591124281yj228/openclaw_ready) ![Homebrew](https://img.shields.io/badge/Homebrew-Integrated-orange?logo=homebrew) ![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-green)

---

## 🧐 为什么要搞这个项目？

### 官方镜像的痛点
如果你深入使用过 OpenClaw 官方镜像，你可能遇到过这堵墙：**“我想让 Agent 使用 `ffmpeg` 处理视频，或者用 `yt-dlp` 下载素材，甚至运行复杂的 Python 脚本，但容器环境是被锁死的。”**

出于安全考虑，官方镜像使用非 root 用户 (`USER node`) 运行。这意味着**你无法使用 `apt-get` 安装软件**，也无法在不重新构建整个镜像的情况下临时添加工具。

### 我们的解决方案：无界版
我们通过在镜像中预装 **Homebrew (Linuxbrew)** 解决了这个问题。这使得以 `node` 用户运行的 Agent 无需 root 权限，即可将软件包安装到自己的主目录中，实现真正的动态扩展。

| 特性 | ❌ 官方镜像 | ✅ 本自定义镜像 |
| :--- | :--- | :--- |
| **包管理器** | `apt` (运行时被禁用) | **`brew` (随时可用) + `pip`** |
| **运行时扩展** | ❌ (必须重构镜像) | **✅ (通过 `install_all.sh` 一键安装)** |
| **AI 能力栈** | 仅 Node.js | **Python, Torch, Whisper, Pandas** |
| **媒体工具** | 无 | **FFmpeg, yt-dlp, MoviePy** |
| **部署速度** | 需编译 (较慢) | **极速 (Docker Hub 现成镜像)** |

---

## 🚀 快速开始 (推荐)

你不需要从源码编译。我已经将生产环境就绪的镜像推送到 Docker Hub。

### 1. 创建 `docker-compose.yml`

复制并使用以下配置，它直接拉取构建好的镜像，并挂载了扩展脚本。

```yaml
version: '3.8'

services:
  openclaw-gateway:
    # ⬇️ 使用预构建的增强版镜像 (含 Brew & Python 支持)
    image: 591124281yj228/openclaw_ready:latest
    container_name: openclaw-gateway
    restart: unless-stopped
    ports:
      - "18789:18789"
    volumes:
      # 数据持久化
      - ./data:/home/node/.openclaw
      - ./workspace:/home/node/clawd
      # 浏览器 Session 持久化 (重启不掉登录态)
      - ./chrome-data:/home/node/.config/chromium
      # ⬇️ 挂载魔法脚本 (确保本地有这个文件)
      - ./install_all.sh:/app/install_all.sh
    environment:
      - NODE_ENV=production
      # ⚠️ 请务必修改此 Token!
      - OPENCLAW_GATEWAY_TOKEN=admin123456
      - CLAWDBOT_CONFIG_PATH=/home/node/.openclaw/config.json
      # 使用 pnpm 保证构建稳定性
      - OPENCLAW_PREFER_PNPM=1
    deploy:
      resources:
        limits:
          # 运行 AI 模型 (Whisper/Torch) 需要较大内存
          memory: 4G