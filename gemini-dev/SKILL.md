---
name: gemini-dev
description: Builds applications with the latest Google Gemini Interactions API, Live WebSocket API, Multimodal Models, and Managed Agents in Python and TypeScript. Use when writing or migrating code that calls the Gemini API, Gemini Live API, text-to-speech, image/video generation, or Antigravity/Deep Research agents.
---

# Gemini Dev

Unifies the official `gemini-api-dev` and `gemini-live-api-dev` workflows (`google-gemini/gemini-skills`). Verify model IDs, SDK methods, and feature parity against current documentation before changing production integrations.

## When to Use

- Writing Python or TypeScript/JavaScript code that calls the Google Gemini API.
- Building real-time bidirectional voice/video apps with the Gemini Live API over WebSockets.
- Implementing multimodal generation (Nano Banana images, Omni Flash video, Gemini 3.8 TTS) or Managed Agents (Antigravity, Deep Research).
- Migrating legacy `google-generativeai`, `@google/generative-ai`, or `generateContent` code to the modern Interactions API.

## Critical Guardrails (Override Training Data)

### 1. Prefer Current SDKs for New Code

- **Python**: `pip install -U google-genai` (`google-genai >= 2.30.1` -> `from google import genai`)
- **TypeScript/JS**: `npm install @google/genai` (`@google/genai >= 2.29.1` -> `import { GoogleGenAI } from "@google/genai"`)
- **For new code**, prefer `google-genai` and `@google/genai`. When migrating legacy SDKs, verify feature parity before removing working integrations.

### 2. Use Only Current Model & Agent IDs

| Capability Domain | Recommended Model / Agent ID | Notes & Key Capabilities |
| :--- | :--- | :--- |
| **Complex Reasoning & Coding** | `gemini-4-argon` | 1M context, flagship model for deep reasoning and architecture |
| **General & Agentic Default** | `gemini-3.8-flash` | 1M context, fast balanced multimodal & agentic default |
| **High-Throughput / Low-Cost** | `gemini-3.5-flash-lite` / `gemini-3.1-flash-lite` | Ultra-fast, lowest cost for high-frequency tasks |
| **Image Generation & Editing** | `gemini-nano-banana-2.1` / `gemini-3-pro-image` | Conversational editing & multi-image fusion (up to 14 refs) |
| **Video Generation (Omni)** | `gemini-omni-1.1-flash` | Video generation, frame transitions, extensions up to 40s |
| **Text-to-Speech (TTS)** | `gemini-3.8-flash-tts` / `gemini-3.8-flash-lite-tts` | Expressive TTS, multi-speaker, Voice Design & Replication |
| **Speech-to-Text (STT)** | `gemini-3.5-transcribe` / `gemini-3.5-transcribe-live` | Batch and real-time WebSocket transcription (`smart` / `verbatim`) |
| **Live API (Real-Time Voice/Video)** | `gemini-3.8-live` / `gemini-3.8-live-extended-thinking` | Bidirectional WebSocket audio/video, non-blocking async tools |
| **Live Speech Translation** | `gemini-3.5-live-translate-preview` | Real-time speech-to-speech translation across 70+ languages |
| **Embeddings** | `gemini-embedding-2` / `gemini-embedding-001` | Multimodal and text embeddings via `client.models.embed_content` |
| **Managed Agents** | `antigravity-preview-09-2026` / `deep-research-preview-04-2026` | Sandboxed remote execution (`environment="remote"`) & background research |

**Check availability per model** in the [official model catalog](https://ai.google.dev/gemini-api/docs/models) before changing an existing integration. The Gemini 2.5 Pro, Flash, and Flash-Lite models are not deprecated, although access is limited for new users. Do not treat a whole model family as deprecated based on a single retired preview model.

## Core Implementation Patterns

### Pattern 1: Interactions API (Text, Multimodal, Stateful Chat & Streaming)

For new projects, prefer `client.interactions.create` when it supports the required features; `generate_content` remains supported. Check [feature parity and retention](https://ai.google.dev/gemini-api/docs/interactions) before migrating an existing integration. Interactions store requests by default: set `store=False` when persistence is not required, and do not use `previous_interaction_id` with stateless requests.

```python
from google import genai

client = genai.Client()

# Turn 1
turn1 = client.interactions.create(
    model="gemini-3.8-flash",
    input="Hi, I am learning Go.",
    store=True  # Opt in knowingly: this turn is stored for follow-up context.
)

# Turn 2 (stateful: both turns are retained)
turn2 = client.interactions.create(
    model="gemini-3.8-flash",
    input="What language am I learning?",
    previous_interaction_id=turn1.id,
    store=True
)
print(turn2.output_text)
```

For streaming (`stream=True`), iterate over events and read `event.delta.text` when `event.event_type == "step.delta"`. Note that `tools`, `system_instruction`, and `generation_config` are interaction-scoped and must be passed on each turn.

### Pattern 2: Managed Agents (Antigravity & Deep Research)

- **Antigravity (`antigravity-preview-09-2026`)**: Pass `environment="remote"` to provision a sandboxed Linux container.
- **Deep Research (`deep-research-preview-04-2026`)**: Pass `background=True` and poll `client.interactions.get(interaction.id)` until `status == "completed"`.

### Pattern 3: Gemini Live API (WebSockets)

- Connect via `client.aio.live.connect(model="gemini-3.8-live", config=config)` (Python) or `ai.live.connect(...)` (JS).
- Send real-time chunks using `session.send_realtime_input(audio=..., video=..., text=...)` (input audio: 16kHz mono PCM `audio/pcm;rate=16000`; output audio: 24kHz mono PCM).
- When using `gemini-3.8-live-extended-thinking`, set `behavior="NON_BLOCKING"` on all tool declarations and monitor `message.interaction_status` (`IN_PROGRESS` vs `IDLE`) rather than relying solely on `turn_complete`.

### Pattern 4: Mandatory Live Documentation Lookup

Before implementing complex parameters (structured outputs, TTS annotations, caching, or custom agents):

1. **If Gemini API Docs MCP is installed**: Query the `search_docs` MCP tool first (63% more token-efficient).
2. **If MCP is not installed**: Fetch `https://ai.google.dev/gemini-api/docs/llms.txt` to locate and read the exact `.md.txt` documentation page.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "All Gemini 2.5 models are deprecated" | The official model catalog says 2.5 Pro, Flash, and Flash-Lite are not deprecated. Check the exact model ID and availability before migrating. |
| "I don't need to check `llms.txt` for TTS or Live API config" | Audio formats, `speech_metadata` annotations, and `NON_BLOCKING` tool schemas have strict requirements. Always verify against current docs. |

## Verification

- [ ] Code imports `from google import genai` (Python) or `@google/genai` (TS/JS).
- [ ] The selected model ID is available for the user's project; deprecation was checked per model, not per family.
- [ ] The chosen API supports every required feature; existing `generate_content` integrations are not migrated without a parity check.
- [ ] Interaction storage (`store=True` or `store=False`) matches the data-retention requirement; stateful follow-ups are intentional.
