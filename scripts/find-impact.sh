#!/usr/bin/env bash
# find-impact.sh — 精准定位：关键词影响分析
# 用法: bash find-impact.sh <project_root> "关键词"

set -euo pipefail
PROJECT_ROOT="${1:-.}"
KEYWORD="${2:?Usage: bash find-impact.sh <project_root> <keyword>}"
cd "$PROJECT_ROOT"

echo "=== 🔍 影响分析：$KEYWORD ==="
echo ""

echo "=== 直接文件命中 ==="
find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.py' -o -name '*.vue' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | \
  xargs grep -l "$KEYWORD" 2>/dev/null | head -30

echo ""
echo "=== 内容命中 (前 20 行) ==="
find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.py' -o -name '*.vue' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | \
  xargs grep -n "$KEYWORD" 2>/dev/null | head -20

echo ""
echo "=== import/引用分析 ==="
grep -rn "import.*$KEYWORD\|from.*$KEYWORD\|require.*$KEYWORD" . --include="*.ts" --include="*.py" 2>/dev/null | head -20

echo ""
echo "=== 导出分析 ==="
grep -rn "export.*$KEYWORD\|def $KEYWORD\|func $KEYWORD" . --include="*.ts" --include="*.py" 2>/dev/null | head -20
