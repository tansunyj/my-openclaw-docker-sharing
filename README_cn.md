---

### 📄 中文版 (README_CN.md)

```markdown
# 🦞 OpenClaw 自定义镜像：无界版 (Limitless Edition)

> **解锁 OpenClaw 的全部潜能：集成 Homebrew、Python AI 全栈环境及动态扩展能力。**
> *打破官方镜像的限制，赋予你的 Agent 运行时安装任何工具的能力。*

[![Docker Image](https://img.shields.io/badge/Docker%20Hub-591124281yj228%2Fopenclaw__ready-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/591124281yj228/openclaw_ready) ![Homebrew](https://img.shields.io/badge/Homebrew-Integrated-orange?logo=homebrew) ![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-green)

---

## 🧐 为什么要搞这个项目？

### 官方镜像的痛点
出于安全考虑，官方镜像使用非 root 用户 (`USER node`) 运行。这意味着**你无法使用 `apt-get` 安装软件**，也无法在不重新构建整个镜像的情况下临时添加工具（如 `ffmpeg`, `yt-dlp` 或复杂的 Python 库）。

### 我们的解决方案：无界版
我们通过在镜像中预装 **Homebrew (Linuxbrew)** 解决了这个问题。这使得以 `node` 用户运行的 Agent 无需 root 权限，即可将软件包安装到自己的主目录中，实现真正的动态扩展。

---

## 📂 项目结构与来源说明

理解文件夹结构对于正确运行本项目至关重要。

**如下图（`01.png`）所示，核心环境文件都位于 `openclaw_custom` 文件夹内。**

![项目结构截图](01.png)

### 目录层级说明

`openclaw_custom` 文件夹是一个**混合体**：它的基础代码 clone 自 **[OpenClaw 官方仓库](https://github.com/openclaw/openclaw)**，并在此基础上覆盖了我们的自定义 Docker 环境文件。

```text
.
├── 01.png              <-- 上方的截图文件
├── README.md           <-- 英文说明
├── README_CN.md        <-- 本文件
│
└── openclaw_custom/    <-- 🚨 核心工作目录 (关键!) 🚨
    │                       (源自: [https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw))
    ├── docker-compose.yml  <-- [自定义] 主启动文件
    ├── install_all.sh      <-- [自定义] “魔法”扩展脚本
    ├── Dockerfile          <-- [自定义] 增强版构建源码
    └── ... (OpenClaw 官方源代码文件)