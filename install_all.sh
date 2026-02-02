#!/bin/bash
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# 1. 权限检查 (现在你默认就是 Root，这步肯定通过)
if [ "$(id -u)" -ne 0 ]; then echo "❌ 请以 root 运行"; exit 1; fi

# 2. 菜单部分保持不变...
CHOICES=$(whiptail --title "OpenClaw 扩展中心" --checklist \
"核心已在运行(Root模式)。勾选下方组件开启增强功能：" 22 70 12 \
"FFMPEG"     "视频编解码器 (Brew)" OFF \
"YT_DLP"     "视频下载工具 (Brew)" OFF \
"WHISPER"    "语音转文字 (Python)" OFF \
"TORCH"      "AI 框架 (CPU - 1GB+)" OFF \
"MOVIEPY"    "视频自动剪辑 (Python)" OFF \
"PLAYWRIGHT" "浏览器内核" OFF \
"PANDAS"     "数据处理 (Python)" OFF \
"EXTRA"      "其他(Requests/Pillow/PDF)" OFF 3>&1 1>&2 2>&3)

for CHOICE in $CHOICES; do
    case "${CHOICE//\"/}" in
        # Brew 必须用 node 用户跑 (Root 跑 Brew 会报错)，这行保持原样非常完美！
        "FFMPEG") su node -c "brew install ffmpeg" ;;
        "YT_DLP") su node -c "brew install yt-dlp" ;;
        
        # Python 库直接装到系统层 (Root环境)，完全没问题
        "WHISPER") python3 -m pip install --break-system-packages openai-whisper --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        "TORCH") python3 -m pip install --break-system-packages torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu ;;
        "MOVIEPY") python3 -m pip install --break-system-packages moviepy --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        
        # Playwright: 既然是 Root 运行，就让它装在 /root 目录下，不需要 chown 给 node 了
        "PLAYWRIGHT") npx playwright install chromium ;; 
        
        "PANDAS") python3 -m pip install --break-system-packages pandas --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
        "EXTRA") python3 -m pip install --break-system-packages requests pillow nano-pdf --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple ;;
    esac
done
echo "🎉 选定组件安装完毕！"