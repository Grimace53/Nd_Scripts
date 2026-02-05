# Nd_Scripts
Scripts for Neon Dream

## 🌱 Plant Health System

A beautiful and interactive NUI (Native UI) system for managing plant health in FiveM. This system tracks plant health based on light and water levels, with optional fertilizer for bonus growth.

### Features

- **🌿 Interactive Plant Management**: Beautiful gradient UI with real-time visual feedback
- **❤️ Dynamic Health System**: Plant health calculated from light (40%), water (40%), and optional fertilizer (20%)
- **☀️ Light Level Tracking**: Monitor and adjust sunlight exposure
- **💧 Water Level Management**: Keep your plants hydrated
- **🌾 Optional Fertilizer**: Boost plant growth (not required for survival)
- **🎨 Visual Plant States**: Plant appearance changes based on health (healthy 🌿, growing 🌱, wilting 🥀, pot 🪴)
- **⏱️ Natural Degradation**: Light, water, and fertilizer levels naturally decrease over time

### Installation

1. Copy the resource folder to your FiveM server's `resources` directory
2. Add `ensure Nd_Scripts` to your `server.cfg`
3. Restart your server

### Usage

**In-game Command:**
```
/plantnui
```

This command opens the Plant Health NUI where you can:
- View current plant health status
- Adjust light levels using the slider
- Adjust water levels using the slider
- Add optional fertilizer for bonus health

**Controls:**
- Use sliders to adjust light, water, and fertilizer levels
- Press `ESC` or click the ✕ button to close the UI

### How It Works

**Health Calculation:**
- Light contributes 40% to plant health
- Water contributes 40% to plant health
- Fertilizer (optional) contributes 20% bonus to plant health

**Plant Growth:**
- Plants **need** light and water to survive
- With 100% light and 100% water (no fertilizer): Plant reaches 80% health 🌿
- With fertilizer added: Plant can reach 100% health 🌿

**Natural Degradation (every 10 seconds):**
- Light decreases by 1%
- Water decreases by 2%
- Fertilizer decreases by 0.5%

### Preview

To preview the UI without running a FiveM server, open `preview.html` in a web browser.

### Screenshots

![Healthy Plant with Full Resources](https://github.com/user-attachments/assets/93a2241c-8585-4bfe-b316-af5b73e6ab7a)
*Plant at 100% health with full light, water, and fertilizer*

![Healthy Plant without Fertilizer](https://github.com/user-attachments/assets/1a1bae19-5457-441c-9d35-ada218ae96a2)
*Plant at 80% health with full light and water (no fertilizer needed!)*

![Wilting Plant](https://github.com/user-attachments/assets/ef29c5a6-ddbc-43f9-a131-f80d32a4180d)
*Plant wilting due to low water levels*

### File Structure

```
Nd_Scripts/
├── fxmanifest.lua      # FiveM resource manifest
├── client.lua          # Client-side Lua script
├── html/
│   ├── index.html      # NUI HTML structure
│   ├── style.css       # NUI styling
│   └── script.js       # NUI JavaScript logic
├── preview.html        # Standalone preview
└── README.md           # This file
```

### Technical Details

- Built for FiveM using Lua and NUI (HTML/CSS/JS)
- Uses CSS animations for smooth visual feedback
- Gradient-filled progress bars with glow effects
- Responsive design optimized for in-game display
- Real-time health calculation and visual updates

### License

Free to use and modify for your FiveM server.
