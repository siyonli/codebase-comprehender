#!/usr/bin/env bash
# scan.sh — 项目初始化扫描
# 用法: bash scan.sh <project_root>

set -euo pipefail
PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

echo "=== 📊 项目规模 ==="
find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.rb' -o -name '*.php' -o -name '*.vue' -o -name '*.svelte' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/__pycache__/*' -not -path '*/target/*' | wc -l

echo "=== 目录深度 ==="
find . -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' | awk -F'/' '{print NF-1}' | sort -rn | head -1

echo "=== 入口文件 ==="
find . -maxdepth 2 \( -name 'main.go' -o -name 'app.py' -o -name 'index.ts' -o -name 'app.tsx' -o -name 'server.go' -o -name 'application.rb' -o -name 'main.rs' -o -name 'startup.py' -o -name 'wsgi.py' -o -name 'manage.py' -o -name 'Main.java' -o -name 'app.js' -o -name 'index.js' \) | head -10

echo "=== 配置/构建文件 ==="
find . -maxdepth 3 \( -name '*.yaml' -o -name '*.yml' -o -name 'Dockerfile*' -o -name 'docker-compose*' -o -name 'Makefile' -o -name 'Jenkinsfile' -o -name 'package.json' -o -name 'go.mod' -o -name 'Cargo.toml' -o -name 'requirements.txt' -o -name 'pom.xml' -o -name 'Gemfile' \) | head -20

echo "=== 测试文件分布 ==="
find . -maxdepth 3 \( -name '*test*' -o -name '*spec*' -o -name '*.test.*' -o -name '*.spec.*' -o -name 'tests' -o -name '__tests__' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' | head -20

echo "=== 最后活跃 ==="
git log --format="%ai" -1 2>/dev/null || echo "N/A"

echo "=== 贡献者统计 ==="
git shortlog -sn --all 2>/dev/null | head -10 || echo "N/A"

echo "=== 最近提交 ==="
git log --oneline --since="6 months ago" --format="%h %s" 2>/dev/null | head -20 || echo "N/A"
