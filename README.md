# 🦞 OpenClaw Custom Docker: The "Limitless" Edition

> **Unlock the full potential of OpenClaw with Homebrew, Python AI stacks, and dynamic tool extension.**
> *No more boundaries. Empower your Agent to install any tool at runtime.*

[![Docker Image](https://img.shields.io/badge/Docker%20Hub-591124281yj228%2Fopenclaw__ready-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/591124281yj228/openclaw_ready) ![Homebrew](https://img.shields.io/badge/Homebrew-Integrated-orange?logo=homebrew) ![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-green)

---

## 🧐 Why This Project?

### The Problem with the Official Image
If you use the official OpenClaw Docker image, you might have hit a wall: **"I want my Agent to use `ffmpeg`, `yt-dlp`, or execute complex Python scripts, but the environment is locked down."**

The official image runs as a non-root user (`USER node`) for security. While secure, this means **you cannot run `apt-get install`**, and you cannot add tools like `ffmpeg` or `python` libraries at runtime without rebuilding the entire image.

### The Solution: "Limitless" Edition
We solved this by integrating **Homebrew (Linuxbrew)** directly into the image. This allows the Agent (running as `node`) to install packages to its own home directory *without* needing root access.

| Feature | ❌ Official Image | ✅ This Custom Image |
| :--- | :--- | :--- |
| **Package Manager** | `apt` (Locked/Disabled at runtime) | **`brew` (User Level) + `pip`** |
| **Runtime Install** | ❌ (Requires Rebuild) | **✅ (Instant via `install_all.sh`)** |
| **AI Stack** | Node.js only | **Python, Torch, Whisper, Pandas** |
| **Media Tools** | None | **FFmpeg, yt-dlp, MoviePy** |
| **Setup Time** | Fast (Basic) | **Instant (Pre-built on Docker Hub)** |

---

## 🚀 Quick Start (Fastest Way)

You don't need to build from source. I have pushed the production-ready image to Docker Hub.

### 1. Create `docker-compose.yml`

Copy and paste the following configuration. It uses the pre-built image and maps the extension script.

```yaml
version: '3.8'

services:
  openclaw-gateway:
    # ⬇️ Uses the pre-built custom image with Brew & Python support
    image: 591124281yj228/openclaw_ready:latest
    container_name: openclaw-gateway
    restart: unless-stopped
    ports:
      - "18789:18789"
    volumes:
      # Data Persistence
      - ./data:/home/node/.openclaw
      - ./workspace:/home/node/clawd
      # Browser Session Persistence
      - ./chrome-data:/home/node/.config/chromium
      # ⬇️ The Magic Script (Must match your local file path)
      - ./install_all.sh:/app/install_all.sh
    environment:
      - NODE_ENV=production
      # ⚠️ CHANGE THIS TOKEN!
      - OPENCLAW_GATEWAY_TOKEN=admin123456
      - CLAWDBOT_CONFIG_PATH=/home/node/.openclaw/config.json
      - OPENCLAW_PREFER_PNPM=1
    deploy:
      resources:
        limits:
          # AI models (Whisper/Torch) need RAM
          memory: 4G