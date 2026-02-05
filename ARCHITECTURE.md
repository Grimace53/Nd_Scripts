# System Architecture

## Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    Fertilizer System                         │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Growth     │         │    Yield     │         │    Super     │
│  Fertilizer  │         │  Fertilizer  │         │    Serum     │
│              │         │              │         │              │
│  Speed: 1.25x│         │  Speed: 1.0x │         │  Speed: 1.4x │
│  Yield: 1.0x │         │  Yield: 1.5x │         │  Yield: 1.75x│
└──────────────┘         └──────────────┘         └──────────────┘
        │                        │                        │
        └────────────────────────┴────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   Player Uses Item     │
                    └────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   Client Event         │
                    │   (client/main.lua)    │
                    └────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   Find Nearby Plant    │
                    └────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  Trigger Server Event  │
                    │  (applyFertilizer)     │
                    └────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   Server Validation    │
                    │   (server/main.lua)    │
                    └────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
              Valid │                         │ Invalid
                    ▼                         ▼
        ┌───────────────────┐      ┌─────────────────┐
        │  Apply Effects    │      │  Send Error     │
        │  - Speed Mult     │      │  Notification   │
        │  - Yield Mult     │      └─────────────────┘
        │  - Recalculate    │
        └───────────────────┘
                    │
                    ▼
        ┌───────────────────┐
        │  Notify Players   │
        │  Success Message  │
        └───────────────────┘
                    │
                    ▼
        ┌───────────────────┐
        │   Plant Grows     │
        │   (Faster/More)   │
        └───────────────────┘
                    │
                    ▼
        ┌───────────────────┐
        │  Ready to Harvest │
        └───────────────────┘
                    │
                    ▼
        ┌───────────────────┐
        │   Player Harvests │
        │   (Higher Yield)  │
        └───────────────────┘
```

## Component Breakdown

### Client Side (client/main.lua)
```
┌─────────────────────────────────────┐
│         Client Components           │
├─────────────────────────────────────┤
│ • UseFertilizer()                   │
│   - Find nearby plant               │
│   - Trigger server application      │
│                                     │
│ • GetNearbyPlant()                  │
│   - Check player position           │
│   - Find plants in range            │
│                                     │
│ • Event Handlers                    │
│   - useGrowthFertilizer             │
│   - useYieldFertilizer              │
│   - useSuperSerum                   │
│                                     │
│ • Exports                           │
│   - External integration            │
└─────────────────────────────────────┘
```

### Server Side (server/main.lua)
```
┌─────────────────────────────────────┐
│         Server Components           │
├─────────────────────────────────────┤
│ • Plant Tracking System             │
│   - Store all active plants         │
│   - Track fertilizer status         │
│                                     │
│ • CreatePlant()                     │
│   - Initialize new plant            │
│   - Set base properties             │
│   - Start grow timer                │
│                                     │
│ • ApplyFertilizer()                 │
│   - Validate application            │
│   - Calculate new stats             │
│   - Update plant state              │
│                                     │
│ • HarvestPlant()                    │
│   - Check if ready                  │
│   - Give items to player            │
│   - Clean up tracking               │
│                                     │
│ • Exports                           │
│   - CreatePlant                     │
│   - GetPlant                        │
│   - GetAllPlants                    │
└─────────────────────────────────────┘
```

### Configuration (config.lua)
```
┌─────────────────────────────────────┐
│       Configuration System          │
├─────────────────────────────────────┤
│ Config.Fertilizers                  │
│ ├─ growth_fertilizer                │
│ │  ├─ growSpeedMultiplier: 1.25     │
│ │  └─ yieldMultiplier: 1.0          │
│ │                                   │
│ ├─ yield_fertilizer                 │
│ │  ├─ growSpeedMultiplier: 1.0      │
│ │  └─ yieldMultiplier: 1.5          │
│ │                                   │
│ └─ super_serum                      │
│    ├─ growSpeedMultiplier: 1.4      │
│    └─ yieldMultiplier: 1.75         │
│                                     │
│ Config.Plants                       │
│ ├─ tomato                           │
│ ├─ wheat                            │
│ └─ corn                             │
└─────────────────────────────────────┘
```

### Shared Items (shared/items.lua)
```
┌─────────────────────────────────────┐
│         Item Definitions            │
├─────────────────────────────────────┤
│ Items['growth_fertilizer']          │
│ ├─ name                             │
│ ├─ label                            │
│ ├─ weight: 100                      │
│ ├─ useable: true                    │
│ └─ description                      │
│                                     │
│ Items['yield_fertilizer']           │
│ ├─ name                             │
│ ├─ label                            │
│ ├─ weight: 100                      │
│ ├─ useable: true                    │
│ └─ description                      │
│                                     │
│ Items['super_serum']                │
│ ├─ name                             │
│ ├─ label                            │
│ ├─ weight: 150                      │
│ ├─ useable: true                    │
│ └─ description                      │
└─────────────────────────────────────┘
```

## Data Flow

### Plant Creation
```
1. CreatePlant(id, type, coords, owner)
   ↓
2. Initialize base stats from Config.Plants
   ↓
3. Set multipliers to 1.0 (no fertilizer)
   ↓
4. Start growth timer
   ↓
5. Store in plants table
```

### Fertilizer Application
```
1. Player uses fertilizer item
   ↓
2. Client finds nearby plant
   ↓
3. Server validates:
   - Plant exists?
   - Not already grown?
   - No fertilizer applied?
   - Valid fertilizer type?
   ↓
4. Apply effects:
   - Set speed multiplier
   - Set yield multiplier
   ↓
5. Recalculate:
   - New grow time
   - New yield amount
   ↓
6. Update plant state
   ↓
7. Notify all clients
```

### Harvest
```
1. Player harvests plant
   ↓
2. Server checks:
   - Plant exists?
   - Plant ready?
   ↓
3. Calculate final yield:
   baseYield × yieldMultiplier
   ↓
4. Give items to player
   ↓
5. Remove plant from tracking
   ↓
6. Notify clients
```

## Integration Points

### Framework Integration
```
QBCore/ESX
    ↓
Register Useable Items
    ↓
Trigger Client Events
    ↓
Client → Server Communication
    ↓
Nd_Scripts System
```

### External Resources
```
Other Farming Scripts
    ↓
Call exports('Nd_Scripts', 'CreatePlant', ...)
    ↓
Nd_Scripts Manages Fertilizers
    ↓
Return Results
```

## Performance Considerations

### Memory Usage
- Each plant: ~1KB in memory
- Total with 1000 plants: ~1MB
- Negligible impact

### Network Traffic
- Fertilizer application: ~1KB
- Plant updates: ~500 bytes
- Per-player events only

### CPU Usage
- Grow timers: Minimal (SetTimeout)
- Calculations: O(1) per operation
- No polling or loops

## Scalability

### Current Support
- ✅ Unlimited plants
- ✅ Unlimited players
- ✅ Concurrent operations
- ✅ Framework agnostic

### Future Enhancements
- Visual effects system
- Database persistence
- Admin management panel
- Analytics dashboard

## Security

### Validations
- ✅ Server-side validation
- ✅ Plant ownership check
- ✅ Fertilizer limit enforcement
- ✅ Ready state verification
- ✅ Type checking

### No Exploits
- ✅ Cannot duplicate fertilizers
- ✅ Cannot apply multiple times
- ✅ Cannot harvest before ready
- ✅ Cannot apply to invalid plants
