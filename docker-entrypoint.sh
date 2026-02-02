#!/bin/bash
set -e

echo "🔧 [启动脚本] 正在以 Root 身份初始化..."

# 1. 检查并创建目录
echo "   -> 检查并创建必要目录..."
mkdir -p /home/node/.openclaw
mkdir -p /home/node/clawd
mkdir -p /home/node/.config/chromium

# 2. 修复权限
echo "   -> 修复挂载卷权限..."
chown -R node:node /home/node/.openclaw
chown -R node:node /home/node/clawd
chown -R node:node /home/node/.config

# 3. 脚本权限
chown node:node /app/install_all.sh
chmod +x /app/install_all.sh

echo "✅ [启动脚本] 权限修复完成！"

# 4. 【关键新增】强行注入 Token 参数
# 如果环境变量存在，我们就把它拼接到启动命令后面
if [ -n "$OPENCLAW_GATEWAY_TOKEN" ]; then
    echo "🔑 [启动脚本] 检测到 Token，正在注入启动参数..."
    # "$@" 是原本的命令 (node dist/index.js ...)
    # set -- 的作用是修改当前的参数列表
    set -- "$@" --token "$OPENCLAW_GATEWAY_TOKEN"
fi

echo "🚀 [启动脚本] 正在切换为 'node' 用户启动 OpenClaw..."

# 5. 降级启动
exec gosu node "$@"