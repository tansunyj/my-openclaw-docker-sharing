#!/bin/bash
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# 检查权限
if [ "$(id -u)" -ne 0 ]; then echo "❌ 请以 root 运行"; exit 1; fi

# 菜单：勾选即安装，不勾就不装，完全由你控制
CHOICES=$(whiptail --title "OpenClaw 扩展中心" --checklist \
"核心已在运行。勾选下方组件开启增强功能：" 22 70 12 \
"FFMPEG"   "视频编解码器 (Brew)" OFF \
"YT_DLP"   "视频下载工具 (Brew)" OFF \
"WHISPER"  "语音转文字 (Python)" OFF \
"TORCH"    "AI 框架 (CPU - 1GB+)" OFF \
"MOVIEPY"  "视频自动剪辑 (Python)" OFF \
"PLAYWRIGHT" "浏览器内核" OFF \
"PANDAS"   "数据处理 (Python)" OFF \
"EXTRA"    "其他(Requests/Pillow/PDF)" OFF 3>&1 1>&2 2>&3)

for CHOICE in $CHOICES; do
    case "${CHOICE//\"/}" in
        "FFMPEG") su node -c "brew install ffmpeg" ;;
        "YT_DLP") su node -c "brew install yt-dlp" ;;
        "WHISPER") python3 -m pip install --break-system-packages openai-whisper --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        "TORCH") python3 -m pip install --break-system-packages torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu ;;
        "MOVIEPY") python3 -m pip install --break-system-packages moviepy --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        "PLAYWRIGHT") npx playwright install chromium && chown -R node:node /root/.cache/ms-playwright ;;
        "PANDAS") python3 -m pip install --break-system-packages pandas --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        "EXTRA") python3 -m pip install --break-system-packages requests pillow nano-pdf --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
    esac
done
echo "🎉 选定组件安装完毕！"