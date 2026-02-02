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

## 📂 Project Structure (Important!)

Please verify your directory structure matches the screenshot below (`01.png`).

**The custom configuration files reside in the ROOT directory, while the official source code sits in a sub-folder.**

![Project Structure Screenshot](01.png)

### Directory Layout

```text
.
├── 01.png                  <-- Project screenshot
├── README.md               <-- This file
│
├── ⭐ docker-compose.yml   <-- [Custom] Main setup file (Run this!)
├── ⭐ install_all.sh       <-- [Custom] The "Magic Script"
├── ⭐ Dockerfile           <-- [Custom] Enhanced build file
│
├── 📁 openclaw_custom/     <-- [Official] Source Code Sub-folder
│   ├── src/
│   ├── package.json
│   └── ...
│
├── 📁 data/                <-- [Auto] Persistent Data
├── 📁 workspace/           <-- [Auto] Agent Workspace
└── 📁 chrome-data/         <-- [Auto] Browser Session Data