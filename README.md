# OpenCode Devcontainer

A devcontainer for [opencode](https://opencode.ai) that lets you talk to **Claude, Gemini, or Grok** by exporting a single API key. It mirrors the layout of [`hello-codex`](https://github.com/forjor/hello-codex): launch the container, export a provider key, and run `make hello` to have the agent introduce itself — read-only.

## What's inside

| Tool | Version |
|------|---------|
| Ubuntu | 24.04 |
| Node.js | LTS |
| Git | latest |
| Zsh | latest |
| make | latest |
| opencode CLI (`opencode-ai`) | latest |

Your host `~/.config/opencode` and `~/.local/share/opencode` are bind-mounted into the container, so any opencode config or `opencode auth login` credentials on your host carry in. The three provider keys are also passed through from your host environment if they're already exported there.

## Quick start

Inside the container, export **one** provider key and run `make hello`:

```bash
export ANTHROPIC_API_KEY=sk-ant-...   # Claude
# or
export GEMINI_API_KEY=...             # Gemini
# or
export XAI_API_KEY=...                # Grok

make hello
```

`make hello` runs:

```bash
opencode run --agent plan --model <provider/model> "identify yourself and say hello"
```

- `--agent plan` is opencode's **read-only** agent — it can read and reason but cannot edit files or run mutating commands.
- The model is auto-selected from whichever key you exported (first match wins: Claude → Gemini → Grok).

### Provider keys and default models

| Provider | Environment variable | Default model (override with `MODEL=`) |
|----------|----------------------|----------------------------------------|
| Anthropic (Claude) | `ANTHROPIC_API_KEY` | `anthropic/claude-sonnet-4-5` |
| Google (Gemini) | `GEMINI_API_KEY` | `google/gemini-2.5-pro` |
| xAI (Grok) | `XAI_API_KEY` | `xai/grok-4` |

### Overrides

```bash
# Pick an explicit model (any opencode provider/model id)
make hello MODEL=anthropic/claude-sonnet-4-5

# Change the prompt
make hello PROMPT="who are you and what can you do?"
```

---

## Option A — VSCode

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
2. Open this folder in VSCode.
3. When prompted, click **Reopen in Container** (or run `Dev Containers: Reopen in Container` from the Command Palette).

VSCode builds the image, mounts your opencode dirs, and reopens inside the container. Then export a key and run `make hello`.

---

## Option B — One-shot CLI script (macOS)

Make the script executable once:

```bash
chmod +x start.sh
```

Then run it from the project root any time:

```bash
./start.sh
```

The script will:
1. Verify Docker is installed and running.
2. Install the `devcontainer` CLI via npm if missing.
3. Create `~/.config/opencode` and `~/.local/share/opencode` on your host if needed.
4. Run `devcontainer up` to build and start the container.
5. Drop you into a `zsh` shell inside the container.

### Prerequisites

- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
- [Node.js](https://nodejs.org) (only needed if the devcontainer CLI isn't already installed)

---

## Option C — devcontainer CLI directly

```bash
# Start the container
devcontainer up --workspace-folder .

# Open a shell
devcontainer exec --workspace-folder . zsh
```

---

## Cleaning up

```bash
./clean.sh            # remove this project's devcontainer containers + image
./clean.sh --rebuild  # remove, then rebuild and reconnect
```
