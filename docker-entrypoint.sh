#!/bin/bash
set -e

echo "🔧 [启动脚本] 正在以 Root 身份初始化..."

# 1. 强制修复 Windows 挂载目录的权限 (改为 node 用户所有)
echo "   -> 修复挂载卷权限..."
chown -R node:node /home/node/.openclaw
chown -R node:node /home/node/clawd
mkdir -p /home/node/.config/chromium
chown -R node:node /home/node/.config

# 2. 确保自定义脚本也能被执行
chown node:node /app/install_all.sh
chmod +x /app/install_all.sh

echo "✅ [启动脚本] 权限修复完成！"
echo "🚀 [启动脚本] 正在切换为 'node' 用户启动 OpenClaw..."

# 3. 【核心魔法】降级为 node 用户执行主程序
# "$@" 代表 Dockerfile 里的 CMD 命令
exec gosu node "$@"