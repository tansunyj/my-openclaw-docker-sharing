FROM node:22-bookworm

# 1. 安装基础工具 + gosu (用于权限切换)
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl python3-full python3-pip build-essential procps dos2unix file sudo ca-certificates gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. 安装 Bun 和 pnpm
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"
RUN corepack enable && corepack prepare pnpm@latest --activate

# 3. 预装 Brew
RUN mkdir -p /home/linuxbrew/.linuxbrew && chown -R node:node /home/linuxbrew
USER node
ENV NONINTERACTIVE=1
# 使用清华源加速 Brew
ENV HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# 4. 构建应用
USER root
WORKDIR /app
COPY openclaw_custom/ /app/

# 设置镜像源并构建
RUN pnpm config set registry https://registry.npmmirror.com
RUN pnpm install --frozen-lockfile
RUN pnpm ui:build
RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build

# 5. 【关键】配置启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
# 赋予执行权限并防止 Windows 换行符问题
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && dos2unix /usr/local/bin/docker-entrypoint.sh

# 6. 环境配置
ENV NODE_ENV=production
# 注意：这里 HOME 必须指回 node，因为程序最终会以 node 运行
ENV HOME=/home/node
EXPOSE 18789

# ⚠️ 不再指定 USER node，而是让 entrypoint 脚本来处理切换
ENTRYPOINT ["docker-entrypoint.sh"]

# 默认启动命令
CMD ["node", "dist/index.js", "gateway", "--port", "18789", "--bind", "lan", "--allow-unconfigured"]