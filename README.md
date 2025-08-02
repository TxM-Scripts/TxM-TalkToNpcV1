# 🧠 TxM - NPC Dialogue System (Multiframework)

A clean, immersive, and customizable **NPC Dialogue Interaction** system designed for **GTA V FiveM**, supporting **QBCore**, **QBox**, and **ESX** frameworks.

---

## 📌 Features

- 🗣️ Interact with NPCs using a responsive UI dialogue system.
- 🎯 Built-in camera focus on NPCs when interacting.
- ⚙️ Easily configurable options for each NPC.
- 📦 Framework auto-detection (`QBCore`, `Qbox`, `ESX`).
- 🔁 Server-client event communication.
- 🧩 Add custom job logic, missions, or rentals easily.
- 🛡️ Lightweight and optimized for performance.

---

## 🚀 Supported Frameworks

- ✅ QBCore
- ✅ Qbox
- ✅ ESX

> No need to change your core! Just configure one line.

---

## 🛠️ Installation

1. **Clone or download** this repository into your `resources/[local]` folder:
   ```bash
   git clone https://github.com/yourname/txm-npc-dialogue.git
   ```
2. Ensure the resource in your server.cfg:
   ```bash
   ensure txm-npc-dialogue
   ```
3. Configure framework in config.lua:
   ```bash
   Config.Framework = "qbcore" -- or "qbox", "esx"
   ```
