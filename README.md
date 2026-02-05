# Nd_Scripts
Scripts for Neon Dream

## Farming System with Fertilizers

A FiveM farming system that includes three types of fertilizers to enhance your crops. **Fully compatible with ox_lib, ox_inventory, QBX-Core, QBCore, and ESX!**

### Features
- 🌱 **Growth Fertilizer** - Speeds up plant growth by 25%
- 🌾 **Yield Fertilizer** - Increases harvest yield by 50%
- 💉 **Super Serum** - The ultimate enhancer! Increases growth speed by 40% AND yield by 75%
- 🔧 **Multi-Framework Support** - Works with ox_lib, ox_inventory, QBX-Core, QBCore, and ESX
- 📦 **Automatic Detection** - Detects your framework and adapts automatically
- 🎨 **Modern UI** - Uses ox_lib notifications when available

### Items

#### Growth Fertilizer
- **Item Name:** `growth_fertilizer`
- **Effect:** Increases plant growth speed by 25%
- **Weight:** 100
- **Description:** A special fertilizer that speeds up plant growth

#### Yield Fertilizer
- **Item Name:** `yield_fertilizer`
- **Effect:** Increases harvest yield by 50%
- **Weight:** 100
- **Description:** A nutrient-rich fertilizer that increases harvest yield

#### Super Serum
- **Item Name:** `super_serum`
- **Effect:** Increases growth speed by 40% AND yield by 75%
- **Weight:** 150
- **Description:** The ultimate plant enhancer combining the best of both fertilizers

### Installation

1. Place the `Nd_Scripts` folder in your server's `resources` directory
2. Ensure `ox_lib` is installed and started (optional but recommended)
3. Add to your `server.cfg`:
   ```
   ensure ox_lib          # Optional but recommended
   ensure Nd_Scripts
   ```
4. Add the items to your framework's shared items:
   - For **ox_inventory**: Add items from `shared/ox_items.lua` to `ox_inventory/data/items.lua`
   - For **QBX-Core**: Add items from `QBX_INTEGRATION.md` to `qbx_core/shared/items.lua`
   - For **QBCore**: Add items from `QBCORE_INTEGRATION.md` to `qb-core/shared/items.lua`
   - For **ESX**: Add items from `ESX_INTEGRATION.md` to your items database
5. Register useable items (see integration guides)

### Usage

#### For Players
1. Obtain fertilizer items through your server's economy/shops
2. Plant a crop
3. Use a fertilizer item while near the plant
4. Wait for the crop to grow (faster with fertilizers!)
5. Harvest increased yield

#### For Developers

The script provides exports for integration with other resources:

```lua
-- Client-side exports
exports['Nd_Scripts']:UseGrowthFertilizer()
exports['Nd_Scripts']:UseYieldFertilizer()
exports['Nd_Scripts']:UseSuperSerum()

-- Server-side exports
local plantId = exports['Nd_Scripts']:CreatePlant(plantId, plantType, coords, owner)
local plant = exports['Nd_Scripts']:GetPlant(plantId)
local allPlants = exports['Nd_Scripts']:GetAllPlants()
```

### Configuration

Edit `config.lua` to customize:
- Fertilizer effects (growth speed and yield multipliers)
- Plant types and base grow times
- Base yield amounts
- Maximum fertilizers per plant
- Fertilizer duration

### Commands (For Testing)

```
/plant [plantType] - Plant a crop (e.g., /plant tomato)
/usefertilizer [fertilizerType] - Use fertilizer on nearby plant
```

### Supported Plant Types

- **Tomato** - 10 minute grow time, 3 base yield
- **Wheat** - 15 minute grow time, 5 base yield  
- **Corn** - 20 minute grow time, 4 base yield

You can add more plant types in `config.lua`

### Requirements

- FiveM Server
- **Optional but recommended**: ox_lib for modern notifications
- Compatible with:
  - ✅ ox_inventory
  - ✅ QBX-Core (QBCore fork)
  - ✅ QBCore
  - ✅ ESX
  - ✅ Standalone (no framework required)

### License

Open source for Neon Dream community

### Support

For issues or questions, please open an issue on GitHub.
