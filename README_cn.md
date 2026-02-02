# 🦞 OpenClaw 自定义 Docker：“无限”版

> **解锁 OpenClaw 的全部潜力：集成 Homebrew、Python AI 栈和动态工具扩展。**
> *不再受限。赋予您的 Agent 在运行时安装任何工具的能力。*

[![Docker Image](https://img.shields.io/badge/Docker%20Hub-591124281yj228%2Fopenclaw__ready-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/591124281yj228/openclaw_ready) ![Homebrew](https://img.shields.io/badge/Homebrew-Integrated-orange?logo=homebrew) ![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-green)


[![Docker Image Version](https://img.shields.io/docker/v/591124281yj228/openclaw_ready/latest)](https://hub.docker.com/r/591124281yj228/openclaw_ready)

> **Docker Hub 仓库地址：** [https://hub.docker.com/r/591124281yj228/openclaw_ready](https://hub.docker.com/r/591124281yj228/openclaw_ready)

---
---

## 🧐 为什么会有这个项目？

### 官方镜像的痛点
OpenClaw 的官方 Docker 镜像出于安全考虑，强制以非 root 用户 (`USER node`) 运行。虽然这很安全，但也意味着 **你无法运行 `apt-get install`**，更无法在不重新构建整个镜像的情况下，在运行时动态添加像 `ffmpeg`、`yt-dlp` 这样的工具或复杂的 Python 库。

### 解决方案：“无限”版
我们通过将 **Homebrew (Linuxbrew)** 直接集成到镜像中解决了这个问题。这允许 Agent（以 `node` 身份运行）将软件包安装到它自己的家目录中，而 *无需* root 权限。

---

## 📂 项目结构（重要！）

请确认您的目录结构与下方的截图 (`01.png`) 保持一致。

**注意：自定义配置文件位于项目的【根目录】下，而官方源代码则位于【子文件夹】中。**

![Project Structure Screenshot](01.png)

### 目录布局

```text
.
├── 01.png                  <-- 项目结构截图
├── README.md               <-- 本说明文件
│
├── ⭐ docker-compose.yml   <-- [自定义] 主配置文件 (请运行这个!)
├── ⭐ install_all.sh       <-- [自定义] “魔法脚本” (扩展安装工具)
├── ⭐ Dockerfile           <-- [自定义] 增强版构建文件
│
├── 📁 openclaw_custom/     <-- [官方] 源代码子文件夹
│   ├── src/
│   ├── package.json
│   └── ...
│
├── 📁 data/                <-- [自动生成] 持久化数据
├── 📁 workspace/           <-- [自动生成] Agent 工作区
└── 📁 chrome-data/         <-- [自动生成] 浏览器会话数据