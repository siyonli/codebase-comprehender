#!/usr/bin/env bash
# find-bug.sh — Bug 溯源：根据错误关键词定位问题
# 用法: bash find-bug.sh <project_root> "错误关键词"

set -euo pipefail
PROJECT_ROOT="${1:-.}"
KEYWORD="${2:?Usage: bash find-bug.sh <project_root> <keyword>}"
cd "$PROJECT_ROOT"

echo "=== 🐛 Bug 溯源：$KEYWORD ==="
echo ""

echo "=== 错误文本匹配 ==="
find . -type f \( -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.log' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | \
  xargs grep -in "$KEYWORD" 2>/dev/null | head -30

echo ""
echo "=== 错误处理模式 ==="
grep -rn "try.*catch\|except\|if err.*nil\|throw new\|Error(" . --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | head -20

echo ""
echo "=== 日志上下文 ==="
grep -rn "logger\.\|console\.\|log\.\|print(" . --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | \
  grep -i "error\|warn\|fail\|exception\|panic" | head -20
