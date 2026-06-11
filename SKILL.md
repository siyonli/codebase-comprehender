---
name: "codebase-comprehender"
description: "11-workflow engine for understanding large codebases — impact analysis, bug tracing, data flow, debt scan, API map"
---

# Codebase Comprehender — 大型代码库智能理解引擎

> 让 AI Agent 在 3 分钟内理解任意大型项目，精准定位改动影响，像 Senior Dev 一样思考。

---

## 🎯 核心能力

| 工作流 | 命令 | 用途 |
|--------|------|------|
| 架构速览 | `what-is-this` | 3 分钟理解陌生项目全貌 |
| 精准定位 | `find-impact` | "改 X 需要动哪些文件？" |
| 数据流追踪 | `trace-data` | 从入口到落库的完整链路 |
| Bug 溯源 | `find-bug` | 报错 → 根因定位 |
| 改代码指导 | `how-to-change` | "我想实现 X，怎么改？" |
| 全面影响分析 | `full-impact` | 改了这个会怎么样？ |
| 测试影响面 | `test-impact` | 哪些测试要更新？ |
| Git Diff 分析 | `analyze-diff` | 这个 commit 改了啥？ |
| 技术债扫描 | `debt-scan` | 代码质量、耦合、重复 |
| 贡献指南生成 | `contrib-guide` | 新人生成一键指南 |
| API 接口图谱 | `api-map` | 接口关系、入参出参 |

---

## 🔄 触发判断

| 用户意图 | 触发词 | 工作流 |
|----------|--------|--------|
| 想了解项目 | "这是什么项目"、"项目结构"、"架构" | `what-is-this` |
| 找文件/位置 | "这个在哪"、"谁调用了"、"影响范围" | `find-impact` |
| 看数据流 | "数据怎么流"、"从哪到哪"、"链路" | `trace-data` |
| 查 bug | "报错"、"异常"、"为什么"、"crash" | `find-bug` |
| 实现功能 | "怎么加"、"我想做"、"实现 X" | `how-to-change` |
| 全面影响 | "改了这个会怎么样"、"完整影响" | `full-impact` |
| 测试影响面 | "哪些测试要更新"、"测试覆盖" | `test-impact` |
| git diff 分析 | "这个 commit 改了啥"、"看 diff" | `analyze-diff` |
| 技术债/质量 | "代码质量"、"技术债"、"耦合"、"重复" | `debt-scan` |
| 新手指南 | "怎么贡献"、"贡献指南"、"新人生成" | `contrib-guide` |
| API 接口 | "接口关系"、"API 调用"、"入参出参" | `api-map` |

如果用户没说清楚，先问项目路径和项目类型，再决定工作流。

---

## ⚠️ 设计原则

1. **只读操作** — 搜索/分析只读，绝不执行写入/删除/部署命令
2. **尊重项目约定** — 不假设编码风格、不假设目录结构，先扫描再行动
3. **不跳过测试** — 涉及修改的工作流，必须指出需要更新的测试文件
4. **不瞎猜** — 不确定时就明确说"无法确定，需要人工确认"
5. **输出结构化** — 每个工作流输出都要有清晰的标题、表格、代码块
6. **保持简洁** — 先给摘要，用户追问再展开细节

---

## 📦 依赖

- **仅标准 Unix 工具**：find, grep, git, wc, awk, sort, head
- **可选加速**：ripgrep (rg), fd（快 5-10 倍）
- **无需 API key**，离线可用
- **支持语言**：TypeScript/JavaScript, Python, Go, Rust, Java, Ruby, PHP, Vue 等

---

## 📐 初始化（首次使用某个项目）

每次面对新代码库，**先做项目扫描，建立本地索引**：

```bash
cd <project_root>

# 1. 技术栈识别
cat package.json || composer.json || requirements.txt || go.mod || Cargo.toml || Gemfile || pom.xml || build.gradle || mix.exs

# 2. 项目结构扫描
find <dir> -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' | head -80

# 3. 入口文件定位
find . -maxdepth 2 -name 'main.go' -o -name 'app.py' -o -name 'index.ts' -o -name 'app.tsx' -o -name 'server.go' -o -name 'application.rb' -o -name 'main.rs' | head -10

# 4. 配置文件扫描
find . -maxdepth 3 \( -name '*.yaml' -o -name '*.yml' -o -name '*.json' -o -name '*.toml' -o -name 'Dockerfile*' -o -name 'docker-compose*' \) | head -30

# 5. 测试文件分布
find . -maxdepth 3 \( -name '*test*' -o -name '*spec*' -o -name 'tests' -o -name '__tests__' \) | head -20

# 6. 历史 commit 统计（最近 50）
git log --oneline --since="6 months ago" --format="%h %s" | head -50 2>/dev/null
```

---

## 🔄 工作流

### 1. `what-is-this` — 架构速览

**触发条件：** 用户提到陌生项目、想了解项目结构

```bash
cd <project_root>
find . -type f \( -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.vue' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' | wc -l
git log --oneline --all | wc -l 2>/dev/null || echo "N/A"
git log --format="%ai" -1 2>/dev/null || echo "N/A"
```

**输出格式：**
- 项目速览（语言/框架/数据库/部署）
- 规模（代码文件数/目录深度/提交数）
- 架构概览（3 句话总结）
- 目录结构（精简版）
- 入口点和核心建议

### 2. `find-impact` — 精准定位

**触发条件：** "改 X 要动哪些文件？"、"这个函数被谁调用？"

```bash
cd <project_root>
KEYWORD="用户输入"
find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.py' -o -name '*.vue' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | xargs grep -l "$KEYWORD" 2>/dev/null
grep -rn "import.*$KEYWORD\|require.*$KEYWORD" . --include="*.ts" --include="*.py" 2>/dev/null | head -20
grep -rn "export.*$KEYWORD\|def $KEYWORD\|func $KEYWORD" . --include="*.ts" --include="*.py" 2>/dev/null | head -20
```

**输出格式：** 直接文件列表（带匹配位置和行号）、调用链图、测试覆盖提示

### 3. `trace-data` — 数据流追踪

**触发条件：** "数据从 API 到数据库经过哪些步骤？"、"用户注册的数据流是怎样的？"

```bash
cd <project_root>
# 1. 找到入口（路由/Handler/API endpoint）
grep -rn "register\|login\|signup" . --include="*.ts" --include="*.py" 2>/dev/null | grep -i "route\|endpoint\|handler" | head -15

# 2. 追踪调用链
grep -rn "UserController\|user_service\|createUser" . --include="*.ts" --include="*.py" 2>/dev/null | head -40

# 3. 数据库操作
grep -rn "INSERT\|UPDATE\|CREATE TABLE\|model.create\|User.create\|db.execute" . --include="*.ts" --include="*.py" --include="*.sql" 2>/dev/null | head -20
```

**输出格式：** 完整数据链路图（HTTP → Controller → Service → Repository → DB）、数据模型定义、关键依赖

### 4. `find-bug` — Bug 溯源

**触发条件：** 用户提供错误信息、异常行为描述

```bash
cd <project_root>
# 1. 错误关键词定位
find . -type f \( -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.log' \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' | xargs grep -in "错误关键词" 2>/dev/null | head -30

# 2. 错误处理模式分析
grep -rn "try.*catch\|except\|if err.*nil\|throw new\|Error(" . --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | head -20

# 3. 日志上下文
grep -rn "logger\.\|console\.\|log\.\|print(" . --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | grep -i "error\|warn\|fail\|panic" | head -20
```

**输出格式：** 根因分析、推理链、修复方案代码示例、影响范围

### 5. `how-to-change` — 改代码指导

**触发条件：** "我想实现 X 功能"、"怎么添加 Y？"

```bash
cd <project_root>
# 1. 找类似功能作为参考
grep -rn "类似关键词" . --include="*.ts" --include="*.py" --include="*.go" 2>/dev/null | head -15

# 2. 找扩展点 / 插件点
find . -name "*.ts" -o -name "*.py" | xargs grep -l "hook\|plugin\|middleware\|observer\|interface\|trait" 2>/dev/null | head -20

# 3. 找类型定义 / 接口
grep -rn "interface.*关键词\|type.*关键词\|protocol.*关键词" . --include="*.ts" --include="*.py" 2>/dev/null | head -15

# 4. 找测试模式
find . -path '*/tests/*' -name "*.ts" -o -path '*/tests/*' -name "*.py" | head -10
```

**输出格式：** 方案概述、修改清单表格、参考代码、执行步骤、注意事项

### 6. `full-impact` — 全面影响分析

**触发条件：** "改了这个会怎么样"、"完整影响"

```bash
cd <project_root>
KEYWORD="用户输入"
# 全维度扫描
FILES=$(find . -type f \( -name '*.ts' -o -name '*.py' -o -name '*.go' \) -not -path '*/node_modules/*' | xargs grep -l "$KEYWORD" 2>/dev/null)
IMPORTS=$(grep -rn "import.*$KEYWORD\|from.*$KEYWORD" . --include='*.ts' --include='*.py' 2>/dev/null)
TESTS=$(find . -type f \( -name '*test*' -o -name '*spec*' \) -not -path '*/node_modules/*' | xargs grep -l "$KEYWORD" 2>/dev/null)
CONFIGS=$(grep -rn "$KEYWORD" . --include='*.env' --include='*.yaml' 2>/dev/null)
```

**输出格式：** 影响全景表（直接代码/引用方/测试/文档/配置/SQL）、受影响模块分析、风险评估

### 7. `test-impact` — 测试影响面

**触发条件：** "哪些测试要更新"、"测试覆盖"

```bash
cd <project_root>
TARGET="用户输入"
# 直接测试文件
find . -type f \( -name '*test*' -o -name '*spec*' \) -not -path '*/node_modules/*' | xargs grep -l "$TARGET" 2>/dev/null | head -20

# 间接测试（mock/依赖了目标文件）
find . -type f \( -name '*test*.ts' -o -name '*test*.py' \) -not -path '*/node_modules/*' | xargs grep -l "mock\|spy\|stub" 2>/dev/null | head -15
```

**输出格式：** 直接影响测试列表、间接影响测试列表、测试类型分布、建议执行命令

### 8. `analyze-diff` — Git Diff 语义分析

**触发条件：** "这个 commit 改了啥"、"看 diff"

```bash
cd <project_root>
GIT_HASH="用户输入或 HEAD"
git log -1 --format='%h %s%n%n%b' $GIT_HASH 2>/dev/null
git diff --stat $GIT_HASH^ $GIT_HASH 2>/dev/null
git diff --name-only $GIT_HASH^ $GIT_HASH 2>/dev/null
git diff --name-status $GIT_HASH^ $GIT_HASH 2>/dev/null
git diff --numstat $GIT_HASH^ $GIT_HASH 2>/dev/null
```

**输出格式：** 变更摘要、改动分类（新增/修改/删除）、意图推断、风险评估

### 9. `debt-scan` — 技术债扫描

**触发条件：** "代码质量"、"技术债"、"耦合"、"重复"

```bash
cd <project_root>
# 1. TODO/FIXME/HACK 扫描
grep -rn "TODO\|FIXME\|HACK\|XXX\|BUG\|TEMP\|WORKAROUND" . --include='*.ts' --include='*.py' --include='*.go' 2>/dev/null | head -40

# 2. 超长文件检测（>300 行）
find . -name '*.ts' -o -name '*.py' -o -name '*.go' | xargs -I {} sh -c 'lines=$(wc -l < "{}"); [ "$lines" -gt 300 ] && echo "{}: $lines lines"'

# 3. 硬编码值扫描
grep -rn "password\|secret\|api_key\|token" . --include='*.ts' --include='*.py' 2>/dev/null | head -20

# 4. 无异常处理文件
find . -name '*.py' -not -path '*/node_modules/*' | while read f; do
  total=$(wc -l < "$f"); exceptions=$(grep -c 'except' "$f" 2>/dev/null || echo 0)
  [ "$total" -gt 50 ] && [ "$exceptions" -eq 0 ] && echo "No exception handling: $f ($total lines)"
done
```

**输出格式：** 概览表（TODO/超长/硬编码/无异常处理）、高优先级清单、中优先级清单、修复建议

### 10. `contrib-guide` — 贡献指南生成

**触发条件：** "怎么贡献"、"贡献指南"、"新人生成"

```bash
cd <project_root>
# 1. 已有贡献文档
cat CONTRIBUTING.md 2>/dev/null || echo "No CONTRIBUTING.md"

# 2. 开发依赖
cat package.json | grep -A 50 '"devDependencies"' | head -30
cat Makefile 2>/dev/null | head -50

# 3. 代码风格配置
cat .eslintrc.* 2>/dev/null; cat .prettierrc* 2>/dev/null; cat .editorconfig 2>/dev/null

# 4. 提交规范
git log --oneline -10 --format='%s' 2>/dev/null

# 5. CI 配置
cat .github/workflows/*.yml 2>/dev/null | grep -E "on:|jobs:" | head -10

# 6. 测试命令
cat Makefile 2>/dev/null | grep -E "^test:" -A 5
```

**输出格式：** 快速开始、代码风格、提交规范、测试要求、目录约定、分支策略、PR 流程、新手入口

### 11. `api-map` — API 接口图谱

**触发条件：** "接口关系"、"API 调用"、"入参出参"

```bash
cd <project_root>
# 1. 提取所有路由/端点定义
KEYWORDS="route\|endpoint\|handle\|controller\|handler\|router"
grep -rn "$KEYWORDS" . --include='*.ts' --include='*.py' --include='*.go' 2>/dev/null | grep -v node_modules | head -60

# 2. 提取认证/中间件
grep -rn "auth\|middleware\|requireAuth\|authenticate" . --include='*.ts' --include='*.py' --include='*.go' 2>/dev/null | grep -i 'middleware\|guard\|auth' | head -30

# 3. 提取请求/响应类型定义
grep -rn "interface.*Request\|interface.*Response\|type.*Request\|type.*Response" . --include='*.ts' --include='*.py' 2>/dev/null | head -20
```

**输出格式：** API 全景、REST API 完整列表（方法/路径/文件/功能/认证/入参/出参）、认证链路、内部服务调用、外部 API 集成、中间件流程

---

## 🛠️ 常用辅助命令

```bash
# 用 ripgrep (rg) 代替 grep（快 5-10 倍，自动忽略 .gitignore）
rg "关键词" . --type ts -C 3    # 显示匹配行前后 3 行上下文

# 用 fd 代替 find（更快，更简洁）
fd -t f -e ts -e tsx -e js "关键词" | rg "具体关键词"

# 项目太大时，先做范围限定
rg -g "*.ts" -g "!*.test.ts" "关键词" .  # 搜索生产代码，跳过测试文件
```

---

## ⚠️ 注意事项

1. **尊重项目约定** — 不假设编码风格、不假设目录结构，先扫描再行动
2. **不跳过测试** — 涉及修改的工作流，必须指出需要更新的测试文件
3. **不瞎猜** — 不确定时就明确说"无法确定，需要人工确认"
4. **输出结构化** — 每个工作流输出都要有清晰的标题、表格、代码块
5. **保持简洁** — 先给摘要，用户追问再展开细节
6. **不碰生产数据** — 搜索/分析只读操作，绝不执行写入/删除/部署命令

---

*Built for large codebases. Works offline. No API keys required.*
