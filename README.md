# 🚀 Custom Proxy-Proof Neovim Environment

An industrial-grade, zero-bloat Neovim configuration optimized for embedded, native C and Python systems development. Designed specifically to run seamlessly within high-security corporate network topographies without external package-manager dependencies, Node.js runtimes, or external proxy configuration layers.

---

## 🛠️ System Prerequisites & Dependencies

All components are installed directly through native system managers (apt / AppImage) to respect pre-configured system mirrors and proxy parameters.

### 1. Core Executable
* Neovim (v0.9+) - Deployed via standard Linux AppImage.

### 2. Native Language Servers & Compilers
Install these system-wide using your package manager to enable real-time compiler diagnostic loops. Run these commands in your standard system terminal:

    sudo apt update
    sudo apt install clangd python3-pylsp git

* clangd: Handles C/C++ static semantic parsing, definition indexing, and symbol tracking.
* python3-pylsp: Pure python language processing server handling Python workspaces.
* git: Core system binary feeding local version tracking layout pipes.

---

## 🗺️ Unified Architecture Layout

Your configuration files should sit in these exact paths:

    ~/.config/nvim/
    ├── init.lua                      # Core configuration file
    └── .clangd                       # Project-level architecture override flag-stripper

> 💡 Cross-Compilation Safeguard: If compiling for custom architectures (e.g., Raspberry Pi ARM targets), the project-level .clangd file automatically strips unknown compiler flags like "-mcpu=cortex-a72.cortex-a53" on-the-fly to keep index diagnostics perfectly green.

---

## ⌨️ Operational Hotkeys & Workflow Control

### 🧠 Native Intelligence Engine (C & Python)
These shortcuts tap directly into Neovim's built-in core C compilation pipe. They carry zero plugin overhead.

| Keystroke | Operational Action |
| :--- | :--- |
| gd | Go to Definition (Instantly jumps to the declaration source line) |
| gr | Go to References (Lists all usages of the symbol under your cursor) |
| K | Hover Documentation (Pulls up native compiler manual layout) |
| ,e | Show Line Error (Expands line warning/error indicators in a floating panel) |
| Ctrl + Space | Trigger Completion Popup (Forcibly injects the omnifunc dropdown stream) |

### 👥 Multi-Cursor Controls (VS Code Style)

| Keystroke | Operational Action |
| :--- | :--- |
| Ctrl + n | Select Word / Next Match (Acts exactly like VS Code's Ctrl + D) |
| Ctrl + Up/Down | Vertical Cursor Stack (Spawns cursors directly above/below) |
| \\A | Select All (Places cursors on every match in the current file) |
| Esc | Exit (Clear all extra cursors back to standard mode) |

### 📁 UI, Navigation & Panel Layouts

| Keystroke | Operational Action |
| :--- | :--- |
| Ctrl + t | Toggle Core Terminal (Opens/Hides terminal panel block inline) |
| ,n | Toggle File Tree (Spawns project visual filesystem browser) |

### 🌿 Version Control Interfacing

| Keystroke | Operational Action |
| :--- | :--- |
| ,g | Launch Magit Interface (Brings up step-by-step code staging control environment) |
| ,gl | Toggle Git Branch Tree Graph (vim-flog interactive visual tree viewer) |

> ⚠️ Note on Destructive Actions: In vimagit, pressing "DDD" or "x" over an untracked file header is explicitly configured to safely bypass safety limits and permanently purge the physical file directly from your disk storage workspace.

---

## 📦 Bundled Plugins (Minimal Footprint)
Managed via an isolated instance of lazy.nvim that loads purely offline hooks when synced:
* tpope/vim-fugitive / jreybert/vimagit — Advanced workspace source indexing.
* rbong/vim-flog — Direct terminal layout tree renderer.
* preservim/nerdtree — Workspace organization tree panel.
* mg979/vim-visual-multi — Visual multi-cursor controls.
