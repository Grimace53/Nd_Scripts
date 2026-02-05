# Fertilizer System - Usage Examples

This document provides practical examples of how the fertilizer system works.

## Example 1: Basic Plant Growth (No Fertilizer)

```lua
-- Plant a tomato
local plantId = 'plant_123'
CreatePlant(plantId, 'tomato', coords, playerId)

-- Wait for base grow time
-- Tomato base grow time: 600 seconds (10 minutes)
-- Base yield: 3 tomatoes

-- After 10 minutes:
-- Player harvests: 3 tomatoes
```

**Result:**
- Grow Time: 600 seconds (10 minutes)
- Harvest: 3 tomatoes

---

## Example 2: Using Growth Fertilizer

```lua
-- Plant a tomato
local plantId = 'plant_123'
CreatePlant(plantId, 'tomato', coords, playerId)

-- Apply Growth Fertilizer
TriggerEvent('nd_farming:applyFertilizer', plantId, 'growth_fertilizer')

-- Growth Fertilizer effect: 1.25x speed (25% faster)
-- New grow time: 600 / 1.25 = 480 seconds (8 minutes)
-- Yield multiplier: 1.0x (no change)
-- Final yield: 3 tomatoes

-- After 8 minutes:
-- Player harvests: 3 tomatoes
```

**Result:**
- Grow Time: 480 seconds (8 minutes) - 2 minutes faster!
- Harvest: 3 tomatoes

---

## Example 3: Using Yield Fertilizer

```lua
-- Plant wheat
local plantId = 'plant_456'
CreatePlant(plantId, 'wheat', coords, playerId)

-- Apply Yield Fertilizer
TriggerEvent('nd_farming:applyFertilizer', plantId, 'yield_fertilizer')

-- Yield Fertilizer effect: 1.5x yield (50% more)
-- Speed multiplier: 1.0x (no change)
-- Grow time: 900 seconds (15 minutes)
-- Final yield: 5 * 1.5 = 7.5 → 7 wheat (rounded down)

-- After 15 minutes:
-- Player harvests: 7 wheat
```

**Result:**
- Grow Time: 900 seconds (15 minutes) - same as base
- Harvest: 7 wheat (base was 5) - 2 extra wheat!

---

## Example 4: Using Super Serum (Best Option!)

```lua
-- Plant corn
local plantId = 'plant_789'
CreatePlant(plantId, 'corn', coords, playerId)

-- Apply Super Serum
TriggerEvent('nd_farming:applyFertilizer', plantId, 'super_serum')

-- Super Serum effects:
-- - Speed multiplier: 1.4x (40% faster)
-- - Yield multiplier: 1.75x (75% more)

-- New grow time: 1200 / 1.4 ≈ 857 seconds (14.3 minutes)
-- Base yield: 4 corn
-- Final yield: 4 * 1.75 = 7 corn

-- After 14.3 minutes:
-- Player harvests: 7 corn
```

**Result:**
- Grow Time: 857 seconds (14.3 minutes) - 5.7 minutes faster!
- Harvest: 7 corn (base was 4) - 3 extra corn!

---

## Comparison Table

### Tomato Plant (Base: 10 min, 3 yield)

| Fertilizer Type | Grow Time | Time Saved | Yield | Extra Yield |
|-----------------|-----------|------------|-------|-------------|
| None            | 10 min    | -          | 3     | -           |
| Growth          | 8 min     | 2 min      | 3     | 0           |
| Yield           | 10 min    | 0 min      | 4     | 1           |
| Super Serum     | 7.1 min   | 2.9 min    | 5     | 2           |

### Wheat Plant (Base: 15 min, 5 yield)

| Fertilizer Type | Grow Time | Time Saved | Yield | Extra Yield |
|-----------------|-----------|------------|-------|-------------|
| None            | 15 min    | -          | 5     | -           |
| Growth          | 12 min    | 3 min      | 5     | 0           |
| Yield           | 15 min    | 0 min      | 7     | 2           |
| Super Serum     | 10.7 min  | 4.3 min    | 8     | 3           |

### Corn Plant (Base: 20 min, 4 yield)

| Fertilizer Type | Grow Time | Time Saved | Yield | Extra Yield |
|-----------------|-----------|------------|-------|-------------|
| None            | 20 min    | -          | 4     | -           |
| Growth          | 16 min    | 4 min      | 4     | 0           |
| Yield           | 20 min    | 0 min      | 6     | 2           |
| Super Serum     | 14.3 min  | 5.7 min    | 7     | 3           |

---

## Player Commands for Testing

```bash
# Plant a crop
/plant tomato
/plant wheat
/plant corn

# Use fertilizer on nearest plant
/usefertilizer growth_fertilizer
/usefertilizer yield_fertilizer
/usefertilizer super_serum
```

---

## Which Fertilizer Should I Use?

### Use Growth Fertilizer when:
- You want faster harvests
- You're focused on time efficiency
- You have limited inventory space
- Market prices are stable

### Use Yield Fertilizer when:
- You want maximum profit per plant
- Market prices are high
- You have time but need more product
- You're trying to meet supply quotas

### Use Super Serum when:
- You want the best of both worlds
- You need speed AND quantity
- Cost is not an issue
- You're a serious farmer maximizing profits

**Recommendation:** Super Serum provides the best overall value, giving you both faster growth AND higher yields!

---

## Price Suggestions for Server Owners

Consider these relative prices based on effectiveness:

- **Growth Fertilizer:** $50-100 (basic enhancement)
- **Yield Fertilizer:** $75-150 (better value)
- **Super Serum:** $150-300 (premium product, worth the cost)

Adjust based on your server's economy!
