# Nd_Scripts
Scripts for Neon Dream

## Farming System with Fertilizers

A FiveM farming system that includes three types of fertilizers to enhance your crops:

### Features
- 🌱 **Growth Fertilizer** - Speeds up plant growth by 25%
- 🌾 **Yield Fertilizer** - Increases harvest yield by 50%
- 💉 **Super Serum** - The ultimate enhancer! Increases growth speed by 40% AND yield by 75%

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
2. Add `ensure Nd_Scripts` to your `server.cfg`
3. Add the items to your framework's shared items:
   - For **QBCore**: Add items from `shared/items.lua` to `qb-core/shared/items.lua`
   - For **ESX**: Add items from `shared/items.lua` to your items database

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
- Compatible with QBCore, ESX, or standalone frameworks
- Optional: Inventory system for item management

### License

Open source for Neon Dream community

### Support

For issues or questions, please open an issue on GitHub.
