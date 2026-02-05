# Nd_Scripts
Scripts for Neon Dream

## 🌱 Plant Health System

A beautiful and interactive NUI (Native UI) system for managing plant health in FiveM. This system tracks plant health based on light and water levels, with optional fertilizer for bonus growth. Integrated with ox_target for seamless interaction.

### Features

- **🎯 ox_target Integration**: Interact with plants using ox_target context menu
- **🌿 Interactive Plant Management**: Beautiful gradient UI with real-time visual feedback
- **❤️ Dynamic Health System**: Plant health calculated from light (40%), water (40%), and optional fertilizer (20%)
- **☀️ Light Level Tracking**: Monitor sunlight exposure
- **💧 Water Management**: Water plants through ox_target menu
- **🌾 Fertilizer System**: Fertilize plants for bonus growth (optional)
- **🎨 Visual Plant States**: Plant appearance changes based on health (healthy 🌿, growing 🌱, wilting 🥀, pot 🪴)
- **⏱️ Natural Degradation**: Light, water, and fertilizer levels naturally decrease over time
- **📦 Plant Actions**: Water, Move, Fertilize, and Pickup plants via ox_target

### Requirements

- **ox_lib** - Required for ox_target integration and notifications
- **ox_target** - Required for plant interaction system

### Installation

1. Ensure you have `ox_lib` and `ox_target` installed on your server
2. Copy the resource folder to your FiveM server's `resources` directory
3. Add `ensure Nd_Scripts` to your `server.cfg` (after ox_lib)
4. Restart your server

### Usage

**Interacting with Plants:**

Use ox_target (default: Third Eye) to interact with plants. Available options:

1. **🌿 View Plant Health** - Opens the NUI to view detailed plant statistics
2. **💧 Water Plant** - Increases water level by 30%
3. **🌾 Fertilize Plant** - Increases fertilizer level by 50%
4. **🔄 Move Plant** - Move the plant to a new location (coming soon)
5. **📦 Pickup Plant** - Remove and destroy the plant (with confirmation)

**NUI Controls:**
- View real-time health, light, water, and fertilizer levels
- Sliders show current levels (read-only in target mode)
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

**ox_target Actions:**
- **Water**: Adds 30% water instantly
- **Fertilize**: Adds 50% fertilizer instantly
- **Move**: Relocate the plant (feature coming soon)
- **Pickup**: Remove and destroy the plant (requires confirmation)

### Preview

To preview the UI without running a FiveM server, open `preview.html` in a web browser.

### Screenshots

![Healthy Plant with Full Resources](https://github.com/user-attachments/assets/93a2241c-8585-4bfe-b316-af5b73e6ab7a)
*Plant at 100% health with full light, water, and fertilizer*

![Healthy Plant without Fertilizer](https://github.com/user-attachments/assets/1a1bae19-5457-441c-9d35-ada218ae96a2)
*Plant at 80% health with full light and water (no fertilizer needed!)*

![NUI positioned on right side](https://github.com/user-attachments/assets/8ac35286-176e-479e-bb53-afcc772aa7f4)
*NUI appears on the right side when viewing plant via ox_target*

### File Structure

```
Nd_Scripts/
├── fxmanifest.lua      # FiveM resource manifest with ox_lib integration
├── client.lua          # Client-side Lua script with ox_target
├── html/
│   ├── index.html      # NUI HTML structure
│   ├── style.css       # NUI styling
│   └── script.js       # NUI JavaScript logic
├── preview.html        # Standalone preview
└── README.md           # This file
```

### Technical Details

- Built for FiveM using Lua and NUI (HTML/CSS/JS)
- Integrated with ox_lib and ox_target for modern FiveM interactions
- Uses CSS animations for smooth visual feedback
- Gradient-filled progress bars with glow effects
- Responsive design optimized for in-game display
- Right-side positioning for better in-game visibility
- Real-time health calculation and visual updates

### License

Free to use and modify for your FiveM server.
