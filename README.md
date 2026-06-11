# Codebase Comprehender 🧠

> 让 AI Agent 在 3 分钟内理解任意大型项目，精准定位改动影响，像 Senior Dev 一样思考。

## 🎯 11 个工作流

| 工作流 | 命令 | 用途 |
|--------|------|------|
| 架构速览 | `what-is-this` | 3 分钟理解陌生项目全貌 |
| 精准定位 | `find-impact` | "改 X 要动哪些文件？" |
| 数据流追踪 | `trace-data` | 从 API 到数据库的完整链路 |
| Bug 溯源 | `find-bug` | 报错 → 根因定位 |
| 改代码指导 | `how-to-change` | "我想实现 X，怎么改？" |
| 全面影响分析 | `full-impact` | 改了这个会怎么样？ |
| 测试影响面 | `test-impact` | 哪些测试要更新？ |
| Git Diff 分析 | `analyze-diff` | 这个 commit 改了啥？ |
| 技术债扫描 | `debt-scan` | 代码质量、耦合、重复 |
| 贡献指南生成 | `contrib-guide` | 新人生成一键指南 |
| API 接口图谱 | `api-map` | 接口关系、入参出参 |

## 🚀 快速使用

```bash
cd <project_root>

# 首次使用：项目扫描
bash scripts/scan.sh .

# 然后选择工作流
# 例如：找影响范围
bash scripts/find-impact.sh . "关键词"

# 查看 bug
bash scripts/find-bug.sh . "错误关键词"
```

## 🔧 技术栈

- **仅依赖标准 Unix 工具**：find, grep, git, wc, awk, sort, head
- **可选加速**：ripgrep (rg), fd
- **无需 API key**，离线可用
- **支持多语言**：TypeScript, JavaScript, Python, Go, Rust, Java, Ruby, PHP, Vue

## 📁 项目结构

```
codebase-comprehender/
├── SKILL.md              # 完整工作流文档
├── README.md             # 本文件
├── scripts/
│   ├── scan.sh           # 项目初始化扫描
│   ├── find-impact.sh    # 影响分析
│   ├── find-bug.sh       # Bug 溯源
│   └── ...               # 其他工作流脚本
└── references/
    └── ...               # 参考文档
```

## ⚠️ 安全原则

1. **只读操作** — 搜索/分析只读，绝不执行写入/删除/部署
2. **尊重项目约定** — 不假设编码风格，先扫描再行动
3. **不跳过测试** — 涉及修改必须指出需要更新的测试文件
4. **不瞎猜** — 不确定时明确说"需要人工确认"

## 📄 许可证

MIT
