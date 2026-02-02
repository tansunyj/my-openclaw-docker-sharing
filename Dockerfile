FROM node:22-bookworm

# ⬇️ 镜像元数据
LABEL org.opencontainers.image.source="https://github.com/tansunyj/my-openclaw-docker-sharing"
LABEL org.opencontainers.image.description="OpenClaw Custom Image with Brew, Python, and Root/Node fix."
LABEL maintainer="591124281yj228"

# 1. 安装基础工具 + gosu
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
ENV HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# 4. 构建应用
USER root
WORKDIR /app
COPY openclaw_custom/ /app/

RUN pnpm config set registry https://registry.npmmirror.com
RUN pnpm install --frozen-lockfile
RUN pnpm ui:build
RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build

# 5. 配置启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && dos2unix /usr/local/bin/docker-entrypoint.sh

# ⬇️ 【修复】正确拷贝文件位置
# 脚本放 /app/ 以匹配启动逻辑
COPY install_all.sh /app/
RUN chmod +x /app/install_all.sh

# 文档放 project_files
# 注意：确保本地确实有 README.md 和 README_CN.md，否则构建会报错
COPY README.md README_cn.md /app/project_files/

# 6. 环境配置
ENV NODE_ENV=production
ENV HOME=/home/node
EXPOSE 18789

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["node", "dist/index.js", "gateway", "--port", "18789", "--bind", "lan", "--allow-unconfigured"]