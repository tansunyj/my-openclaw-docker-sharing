# 🦞 OpenClaw Custom Docker: The "Limitless" Edition

> **Unlock the full potential of OpenClaw with Homebrew, Python AI stacks, and dynamic tool extension.**
> *No more boundaries. Empower your Agent to install any tool at runtime.*

[![Docker Image](https://img.shields.io/badge/Docker%20Hub-591124281yj228%2Fopenclaw__ready-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/591124281yj228/openclaw_ready) ![Homebrew](https://img.shields.io/badge/Homebrew-Integrated-orange?logo=homebrew) ![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-green)

---

## 🧐 Why This Project?

### The Problem with the Official Image
The official OpenClaw Docker image runs as a non-root user (`USER node`) for security. While secure, this means **you cannot run `apt-get install`**, and you cannot add tools like `ffmpeg`, `yt-dlp`, or complex Python libraries at runtime without rebuilding the entire image.

### The Solution: "Limitless" Edition
We solved this by integrating **Homebrew (Linuxbrew)** directly into the image. This allows the Agent (running as `node`) to install packages to its own home directory *without* needing root access.

---

## 📂 Project Structure & Origin

It is crucial to understand the folder structure to run this project correctly.

**As shown in the screenshot below (`01.png`), the core environment files are located inside the `openclaw_custom` folder.**

![Project Structure Screenshot](01.png)

### Directory Layout

The `openclaw_custom` directory is a **hybrid**: it contains the source code cloned from the **[Official OpenClaw Repository](https://github.com/openclaw/openclaw)**, overlayed with our custom Docker environment files.

```text
.
├── 01.png              <-- Screenshot
├── README.md           <-- This file
├── README_CN.md        <-- Chinese documentation
│
└── openclaw_custom/    <-- 🚨 CORE WORKING DIRECTORY 🚨
    │                       (Base: [https://github.com/openclaw/openclaw](https://github.com/openclaw/openclaw))
    ├── docker-compose.yml  <-- [Custom] Main setup file
    ├── install_all.sh      <-- [Custom] The "Magic Script"
    ├── Dockerfile          <-- [Custom] Enhanced build file
    └── ... (Official OpenClaw Source Files)