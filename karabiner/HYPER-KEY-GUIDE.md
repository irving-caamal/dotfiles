# Hyper Key Guide

Caps Lock is remapped to a **Hyper Key** — hold it to activate an entire layer of shortcuts, tap it for Escape.

> **57 shortcuts** across navigation, text selection, window management, app launching, and system utilities.

---

## How It Works

```
TAP  Caps Lock  →  Escape
HOLD Caps Lock  →  Hyper modifier (activates the layer below)
```

Everything below is **Hyper + key**. Hold Caps Lock, press the key.

---

## Keyboard Map — Hyper Layer

### Main Layer (Hyper + key)

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬────────┐
│     │ 1   │ 2   │ 3   │ 4   │ 5   │ 6   │ 7   │     │     │     │  -  │  =  │        │
│     │iTerm│Disc │Figma│ GPT │Claud│Obsid│Brave│     │     │     │ ◀▪▪ │ ▪▪▶ │        │
├─────┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬──────┤
│ TAB   │ Q   │ W   │ E   │ R   │ T   │ Y   │ U   │ I   │ O   │ P   │  [  │  ]  │  \   │
│Mission│Table│Close│Postm│Hard │Warp │Clip │Line │Page │Line │Quick│Prev │Next │Screen│
│Control│Plus │ Tab │ an  │Relod│     │board│Start│ Up  │ End │Open │ Mon │ Mon │ shot │
├───────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴──────┤
│ ░HYPER░│ A   │ S   │ D   │ F   │ G   │ H   │ J   │ K   │ L   │  ;  │     │           │
│ ░░░░░░░│Word │Slack│Multi│Findr│Chrome│  ←  │  ↓  │  ↑  │  →  │Word │     │           │
│ ░░░░░░░│ ◀◀  │     │Cursr│     │ Dev │     │     │     │     │ ▶▶  │     │           │
├────────┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴───────────┤
│           │ Z   │ X   │ C   │ V   │ B   │ N   │ M   │  ,  │  .  │  /  │              │
│           │Redo │Lock │Centr│Cursr│Chrom│Page │Notio│ 1st │ Mid │Last │              │
│           │     │Scrn │     │     │  e  │Down │  n  │Third│Third│Third│              │
├───────┬───┴──┬──┴───┬─┴─────┴─────┴─────┴─────┴───┬─┴────┬┴─────┴─────┴──────────────┤
│       │      │      │           SPACE              │      │                            │
│       │      │      │          Raycast              │      │                            │
└───────┴──────┴──────┴──────────────────────────────┴──────┴────────────────────────────┘
```

### Arrow Keys Layer (Hyper + arrow)

```
                          ┌─────────┐
                          │    ↑    │
                          │Maximize │
                    ┌─────┼─────────┼─────┐
                    │  ←  │    ↓    │  →  │
                    │Left │ Restore │Right│
                    │Half │         │Half │
                    └─────┴─────────┴─────┘
```

### Shift Layer (Hyper + Shift + key)

All navigation keys support **Shift for selection** — hold Shift while pressing any navigation key to select text instead of just moving.

```
┌──────────────────────────────────────────────────────────┐
│  Hyper + Shift + H/J/K/L    →  Select ←/↓/↑/→           │
│  Hyper + Shift + A          →  Select word left          │
│  Hyper + Shift + ;          →  Select word right         │
│  Hyper + Shift + U          →  Select to line start      │
│  Hyper + Shift + O          →  Select to line end        │
│  Hyper + Shift + I          →  Select page up            │
│  Hyper + Shift + N          →  Select page down          │
└──────────────────────────────────────────────────────────┘
```

> Shift selection works on **all** navigation keys because they use `optional: any`. The shift modifier passes through automatically.

---

## Quick Reference Tables

### Vim Navigation

| Key | Action | With Shift |
|-----|--------|------------|
| `H` | ← | Select ← |
| `J` | ↓ | Select ↓ |
| `K` | ↑ | Select ↑ |
| `L` | → | Select → |
| `A` | Word left (Opt+←) | Select word left |
| `;` | Word right (Opt+→) | Select word right |
| `U` | Line start (Cmd+←) | Select to line start |
| `O` | Line end (Cmd+→) | Select to line end |
| `I` | Page Up | Select page up |
| `N` | Page Down | Select page down |

**Mnemonic**: `HJKL` = vim arrows. `A;` = word jump (left/right of home row). `UO` = line edges (above `JL`). `IN` = page scroll (above `JN`).

### Editing

| Key | Action |
|-----|--------|
| `Backspace` | Forward Delete (delete character ahead) |

> Combine with Shift for more: `Hyper + Shift + Backspace` = forward-delete with selection behaviors depending on app.

### Window Management (Rectangle)

#### Halves & Maximize

| Key | Action | Notes |
|-----|--------|-------|
| `←` (arrow) | Left Half | Cycles: ½ → ⅔ → ⅓ |
| `→` (arrow) | Right Half | Cycles: ½ → ⅔ → ⅓ |
| `↑` (arrow) | Maximize | Full screen (not native fullscreen) |
| `↓` (arrow) | Restore | Return to previous size |
| `C` | Center | Center window on screen |

#### Thirds (for ultrawides)

```
 ┌──────────┬──────────┬──────────┐
 │  Hyper , │  Hyper . │  Hyper / │
 │   1st    │  Center  │   Last   │
 │  Third   │  Third   │  Third   │
 └──────────┴──────────┴──────────┘
```

| Key | Action | Best For |
|-----|--------|----------|
| `,` | First Third | Editor on ultrawide |
| `.` | Center Third | Browser/reference on ultrawide |
| `/` | Last Third | Terminal/tools on ultrawide |

> Repeat the same key to cycle through sizes (⅓ → ⅔). This is Rectangle's `subsequentExecutionMode`.

#### Multi-Monitor

```
 ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
 │  Display 1  │    │  Display 2  │    │  Display 3  │
 │  (ultrawide)│◀───│  (MacBook)  │───▶│  (ultrawide)│
 │             │ [  │             │ ]  │             │
 └─────────────┘    └─────────────┘    └─────────────┘
```

| Key | Action |
|-----|--------|
| `[` | Move window to **previous** display |
| `]` | Move window to **next** display |

#### Resize

| Key | Action |
|-----|--------|
| `-` | Make window smaller |
| `=` | Make window larger |

### App Launchers

#### Letter Keys (daily drivers)

| Key | App | Category |
|-----|-----|----------|
| `V` | **WebStorm** | Editor |
| `T` | **Warp** | Terminal |
| `B` | **Chrome** | Browser (personal) |
| `G` | **Chrome Dev** | Browser (dev/testing) |
| `S` | **Slack** | Communication |
| `M` | **Notion** | Notes & docs |
| `E` | **Postman** | API testing |
| `Q` | **TablePlus** | Database |
| `F` | **Finder** | Files |

#### Number Row (extended apps)

| Key | App | Category |
|-----|-----|----------|
| `1` | **iTerm2** | Terminal (secondary) |
| `2` | **Discord** | Communication |
| `3` | **Figma** | Design |
| `4` | **ChatGPT** | AI |
| `5` | **Claude** | AI |
| `6` | **Obsidian** | Knowledge base |
| `7` | **Brave** | Browser (privacy) |

**Mnemonic**: Number row = secondary/occasional apps. Letter keys = daily drivers with intuitive letters.

### Dev Shortcuts

| Key | Action | Where |
|-----|--------|-------|
| `D` | Cmd+D (select word / multi-cursor) | WebStorm, VS Code, Chrome |
| `P` | Cmd+P (quick open file) | WebStorm, VS Code |
| `R` | Cmd+Shift+R (hard reload) | Chrome, browsers |
| `W` | Cmd+W (close tab) | Everywhere |
| `Z` | Cmd+Shift+Z (redo) | Everywhere |
| `Space` | Raycast launcher | Global |

### System Utilities

| Key | Action | Output |
|-----|--------|--------|
| `X` | Lock screen | Cmd+Ctrl+Q |
| `Y` | Clipboard history | Raycast clipboard (vim "yank") |
| `\` | Screenshot area | Cmd+Shift+4 (drag to capture) |
| `Tab` | Mission Control | View all windows & spaces |

### Right Option Key (non-hyper)

| Action | Output |
|--------|--------|
| Tap Right Option | Cmd+` (cycle same-app windows) |

---

## Workflows

### Code Editing Flow

```
Hyper+V          → Switch to WebStorm
Hyper+P          → Quick open file
Hyper+D          → Select word, repeat for multi-cursor
Hyper+H/J/K/L   → Navigate without leaving home row
Hyper+Shift+A/;  → Select word-by-word
Hyper+U/O        → Jump to line start/end
Hyper+W          → Close current tab
```

### Three-Monitor Window Setup

```
Hyper+]          → Throw window to right monitor
Hyper+[          → Throw window to left monitor
Hyper+↑          → Maximize on current display
Hyper+,          → Snap to left third (ultrawide)
Hyper+.          → Snap to center third (ultrawide)
Hyper+/          → Snap to right third (ultrawide)
```

**Example layout on ultrawides:**

```
┌───────────────────────────────────┐ ┌──────────────┐ ┌───────────────────────────────────┐
│ Hyper+,    │ Hyper+.  │ Hyper+/  │ │              │ │ Hyper+,    │ Hyper+.  │ Hyper+/  │
│ Terminal   │ Browser  │ Postman  │ │   WebStorm   │ │ Slack      │ Notion   │ Discord  │
│            │          │          │ │  (maximized) │ │            │          │          │
└───────────────────────────────────┘ └──────────────┘ └───────────────────────────────────┘
         Left Ultrawide                   MacBook                Right Ultrawide
```

### Quick Context Switching

```
Hyper+B          → Jump to Chrome
Hyper+R          → Hard reload the page
Hyper+G          → Switch to Chrome Dev (different profile)
Right Option tap → Cycle between Chrome windows
Hyper+V          → Back to WebStorm
```

### Clipboard Workflow

```
Copy something normally (Cmd+C)
... do other things ...
Hyper+Y          → Open Raycast clipboard history
                    Browse & paste any recent copy
```

---

## Available Keys (not yet mapped)

These keys are free for future customization:

| Key | Suggestion |
|-----|------------|
| `8` | Zoom, WhatsApp, or Telegram |
| `9` | Docker Desktop |
| `0` | Activity Monitor |
| `'` | Terminal in editor (Ctrl+`) |
| `` ` `` | App Expose (Ctrl+Down) |
| `Return` | Emoji picker (Ctrl+Cmd+Space) |

---

## Customization

### Adding a New App Launcher

Add a new manipulator to `karabiner.json` inside the `manipulators` array (before the Right Option rule at the end):

```json
{
    "conditions": [
        {
            "name": "hyper",
            "type": "variable_if",
            "value": 1
        }
    ],
    "description": "Hyper + 8 → Zoom",
    "from": {
        "key_code": "8",
        "modifiers": { "optional": ["any"] }
    },
    "to": [{ "shell_command": "open -a 'zoom.us'" }],
    "type": "basic"
}
```

### Adding a New Keyboard Shortcut

```json
{
    "conditions": [
        {
            "name": "hyper",
            "type": "variable_if",
            "value": 1
        }
    ],
    "description": "Hyper + ' → Ctrl+` (toggle terminal panel)",
    "from": {
        "key_code": "quote",
        "modifiers": { "optional": ["any"] }
    },
    "to": [
        {
            "key_code": "grave_accent_and_tilde",
            "modifiers": ["left_control"]
        }
    ],
    "type": "basic"
}
```

### Key Code Reference

Common key codes for Karabiner:

| Physical Key | `key_code` |
|-------------|------------|
| `` ` `` | `grave_accent_and_tilde` |
| `-` | `hyphen` |
| `=` | `equal_sign` |
| `[` | `open_bracket` |
| `]` | `close_bracket` |
| `\` | `backslash` |
| `;` | `semicolon` |
| `'` | `quote` |
| `,` | `comma` |
| `.` | `period` |
| `/` | `slash` |
| `Enter` | `return_or_enter` |
| `Tab` | `tab` |
| `Delete` | `delete_or_backspace` |
| `Fwd Delete` | `delete_forward` |
| `Space` | `spacebar` |
| `Esc` | `escape` |

### External Keyboard Note

If your external keyboard (vendor `26985`, product `17`) has swapped Cmd/Option, that's handled by a `simple_modifications` rule on the device. The hyper layer works identically on both keyboards.

---

## Troubleshooting

**Karabiner not picking up changes?**
Karabiner auto-reloads `karabiner.json` on save. If it doesn't, open Karabiner-Elements and check the log.

**A shortcut isn't working?**
Open **Karabiner-EventViewer** (already installed) and check that:
1. The hyper variable is set to `1` when you hold Caps Lock
2. The key event is being captured

**Rectangle shortcuts not firing?**
Make sure Rectangle is running and using **default shortcuts** (not Spectacle-compatible). Check Rectangle preferences > Shortcuts.

**Clipboard history not opening?**
Ensure the Raycast Clipboard History extension is installed: open Raycast > Store > search "Clipboard History" > Install.
