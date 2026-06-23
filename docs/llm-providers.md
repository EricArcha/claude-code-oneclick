# LLM 服务商配置参考

> 本文列出常见第三方 API 服务商的 Claude Code 配置参数。数据来源 [cc-switch](https://github.com/farion1231/cc-switch) 官方 presets，更新时间与 config-api 脚本保持同步。
>
> `config-api.sh` 已内置 6 个最常用服务商的一键预设。如果你用的服务商不在菜单里，按本文手动输入即可。

## 精选列表（已内置）

| 服务商 | 预设代码 | Base URL | 模型名 | 备注 |
|--------|----------|----------|--------|------|
| DeepSeek（深度求索） | `deepseek` | `https://api.deepseek.com/anthropic` | `deepseek-v4-pro[1m]` | V4 Pro+Flash 均 1M 上下文，需 `[1m]` 后缀标记 |
| Kimi（月之暗面） | `kimi` | `https://api.moonshot.cn/anthropic` | `kimi-k2.7-code` | |
| 智谱 GLM | `zhipu` | `https://open.bigmodel.cn/api/anthropic` | `glm-5.1` | |
| 阿里百炼 | `bailian` | `https://dashscope.aliyuncs.com/apps/anthropic` | 不设 | 自动路由，无需指定模型 |
| 豆包 Seed | `doubao` | `https://ark.cn-beijing.volces.com/api/compatible` | `doubao-seed-2-0-code-preview-latest` | |
| MiniMax | `minimax` | `https://api.minimaxi.com/anthropic` | `MiniMax-M2.7` | |

## 其他服务商（需手动配置）

以下服务商可手动填入 config-api 的自定义路径，或直接用 cc-switch 图形界面配置。

### 聚合商

| 服务商 | Base URL | 模型名 |
|--------|----------|--------|
| 胜算云 | `https://router.shengsuanyun.com/api` | `anthropic/claude-sonnet-4.6` |
| AiHubMix | `https://aihubmix.com` | （自动映射） |
| CCSub | `https://www.ccsub.net` | （自动映射） |
| Unity2.ai | `https://api.unity2.ai` | （自动映射） |
| PIPELLM | `https://cc-api.pipellm.ai` | `claude-opus-4-8` |
| ModelScope | `https://api-inference.modelscope.cn` | `ZhipuAI/GLM-5.1` |
| OpenRouter | `https://openrouter.ai/api/anthropic` | （自动映射） |

### 国内服务商

| 服务商 | Base URL | 模型名 |
|--------|----------|--------|
| 火山引擎 Agentplan | `https://ark.cn-beijing.volces.com/api/coding` | `ark-code-latest` |
| BytePlus | `https://ark.ap-southeast.bytepluses.com/api/coding` | `ark-code-latest` |
| 百度千帆 Coding | `https://qianfan.baidubce.com/anthropic/coding` | `qianfan-code-latest` |
| 百炼 For Coding | `https://coding.dashscope.aliyuncs.com/apps/anthropic` | （自动映射） |
| 步刻 StepFun | `https://api.stepfun.com/step_plan` | `step-3.5-flash-2603` |
| Longcat | `https://api.longcat.chat/anthropic` | `LongCat-Flash-Chat` |
| 百灵 BaiLing | `https://api.tbox.cn/api/anthropic` | `Ling-2.5-1T` |
| 小米 MiMo | `https://api.xiaomimimo.com/anthropic` | `mimo-v2.5-pro` |
| KAT-Coder | `https://vanchin.streamlake.ai/api/gateway/v1/endpoints/${ENDPOINT_ID}/claude-code-proxy` | `KAT-Coder-Pro V1` |

### 海外服务商

| 服务商 | Base URL | 模型名 | 备注 |
|--------|----------|--------|------|
| Gemini Native | `https://generativelanguage.googleapis.com` | `gemini-3.5-flash` | 需设 `ANTHROPIC_API_KEY`（非 AUTH_TOKEN） |
| AWS Bedrock | `https://bedrock-runtime.${AWS_REGION}.amazonaws.com` | `global.anthropic.claude-opus-4-8` | 需额外设置 AWS 凭据 |
| Nvidia | `https://integrate.api.nvidia.com` | `moonshotai/kimi-k2.5` | |

## 必需的环境变量

无论用哪个服务商，`~/.claude/settings.json` 的 `env` 块中至少需要：

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://你的服务商地址",
    "ANTHROPIC_AUTH_TOKEN": "你的 API Key",
    "ANTHROPIC_MODEL": "模型名（含 [1m] 后缀如果需要）",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "Haiku 级模型",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "Sonnet 级模型",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "Opus 级模型"
  }
}
```

## 模型名中的 `[1m]` 后缀

`[1m]` 是 Claude Code 的模型上下文标记语法，表示该模型支持 100 万 token 的上下文窗口。DeepSeek V4 系列（Pro 和 Flash）都需要加此后缀才能用满 1M 上下文：

```
deepseek-v4-pro[1m]
deepseek-v4-flash[1m]
```

不加 `[1m]` 的话 CC 按默认 200K 上下文处理。其他服务商的模型如果也支持 1M 上下文，同理加后缀。

## 注意事项

- **API Key 还是 API Token？** 绝大多数服务商使用 `ANTHROPIC_AUTH_TOKEN`（请求头 `Authorization: Bearer <token>`）。少数（如 Gemini Native、AiHubMix、PatewayAI）使用 `ANTHROPIC_API_KEY`（请求头 `X-Api-Key`）。config-api 默认设 `ANTHROPIC_AUTH_TOKEN`。
- **阿里百炼** 和部分聚合商不需要设模型名——它们的后端会自动把 CC 的默认模型名映射到可用模型。
- **环境变量优先级**：`--model` CLI 参数 > `/model` 命令 > `ANTHROPIC_MODEL` env var > settings.json 的 `model` 字段。
- [Claude Code 官方环境变量文档](https://code.claude.com/docs/en/env-vars)
- [DeepSeek Claude Code 集成文档](https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code)
