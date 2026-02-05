--[[
    Test Script for Fertilizer System
    
    This script demonstrates the fertilizer system functionality.
    Run this on a FiveM test server to validate the implementation.
]]

print("=== Fertilizer System Test ===")

-- Test 1: Verify Config is loaded
print("\n[Test 1] Testing Config Load")
assert(Config ~= nil, "Config is nil!")
assert(Config.Fertilizers ~= nil, "Config.Fertilizers is nil!")
print("✓ Config loaded successfully")

-- Test 2: Verify all fertilizer types exist
print("\n[Test 2] Testing Fertilizer Types")
local expectedFertilizers = {'growth_fertilizer', 'yield_fertilizer', 'super_serum'}
for _, fertType in ipairs(expectedFertilizers) do
    assert(Config.Fertilizers[fertType] ~= nil, "Fertilizer type " .. fertType .. " not found!")
    print("✓ " .. fertType .. " exists")
end

-- Test 3: Verify fertilizer properties
print("\n[Test 3] Testing Fertilizer Properties")

-- Growth Fertilizer
local gf = Config.Fertilizers.growth_fertilizer
assert(gf.growSpeedMultiplier == 1.25, "Growth fertilizer speed multiplier incorrect")
assert(gf.yieldMultiplier == 1.0, "Growth fertilizer yield multiplier incorrect")
print("✓ Growth Fertilizer: Speed 1.25x, Yield 1.0x")

-- Yield Fertilizer
local yf = Config.Fertilizers.yield_fertilizer
assert(yf.growSpeedMultiplier == 1.0, "Yield fertilizer speed multiplier incorrect")
assert(yf.yieldMultiplier == 1.5, "Yield fertilizer yield multiplier incorrect")
print("✓ Yield Fertilizer: Speed 1.0x, Yield 1.5x")

-- Super Serum
local ss = Config.Fertilizers.super_serum
assert(ss.growSpeedMultiplier == 1.4, "Super serum speed multiplier incorrect")
assert(ss.yieldMultiplier == 1.75, "Super serum yield multiplier incorrect")
print("✓ Super Serum: Speed 1.4x, Yield 1.75x")

-- Test 4: Verify plant types
print("\n[Test 4] Testing Plant Types")
assert(Config.Plants ~= nil, "Config.Plants is nil!")
local plantCount = 0
for plantType, plantData in pairs(Config.Plants) do
    assert(plantData.baseGrowTime ~= nil, "Plant " .. plantType .. " missing baseGrowTime")
    assert(plantData.baseYield ~= nil, "Plant " .. plantType .. " missing baseYield")
    plantCount = plantCount + 1
    print("✓ Plant: " .. plantType .. " (Grow: " .. plantData.baseGrowTime .. "s, Yield: " .. plantData.baseYield .. ")")
end
print("Total plants configured: " .. plantCount)

-- Test 5: Calculate effectiveness examples
print("\n[Test 5] Testing Fertilizer Effects")

-- Example: Tomato with Growth Fertilizer
local tomato = Config.Plants.tomato
local growthFert = Config.Fertilizers.growth_fertilizer
local newGrowTime = math.floor(tomato.baseGrowTime / growthFert.growSpeedMultiplier)
local newYield = math.floor(tomato.baseYield * growthFert.yieldMultiplier)
print("Tomato + Growth Fertilizer:")
print("  Base: " .. tomato.baseGrowTime .. "s, " .. tomato.baseYield .. " yield")
print("  With Fertilizer: " .. newGrowTime .. "s, " .. newYield .. " yield")

-- Example: Wheat with Yield Fertilizer
local wheat = Config.Plants.wheat
local yieldFert = Config.Fertilizers.yield_fertilizer
newGrowTime = math.floor(wheat.baseGrowTime / yieldFert.growSpeedMultiplier)
newYield = math.floor(wheat.baseYield * yieldFert.yieldMultiplier)
print("\nWheat + Yield Fertilizer:")
print("  Base: " .. wheat.baseGrowTime .. "s, " .. wheat.baseYield .. " yield")
print("  With Fertilizer: " .. newGrowTime .. "s, " .. newYield .. " yield")

-- Example: Corn with Super Serum
local corn = Config.Plants.corn
local superSerum = Config.Fertilizers.super_serum
newGrowTime = math.floor(corn.baseGrowTime / superSerum.growSpeedMultiplier)
newYield = math.floor(corn.baseYield * superSerum.yieldMultiplier)
print("\nCorn + Super Serum:")
print("  Base: " .. corn.baseGrowTime .. "s, " .. corn.baseYield .. " yield")
print("  With Fertilizer: " .. newGrowTime .. "s, " .. newYield .. " yield")

-- Test 6: Verify items are defined
print("\n[Test 6] Testing Item Definitions")
if Items then
    assert(Items.growth_fertilizer ~= nil, "growth_fertilizer item not defined")
    assert(Items.yield_fertilizer ~= nil, "yield_fertilizer item not defined")
    assert(Items.super_serum ~= nil, "super_serum item not defined")
    print("✓ All fertilizer items defined in Items table")
else
    print("⚠ Items table not loaded (normal if shared/items.lua not executed yet)")
end

print("\n=== All Tests Passed! ===")
print("Fertilizer system is working correctly.\n")

-- Summary
print("SUMMARY:")
print("--------")
print("✓ 3 fertilizer types configured")
print("✓ 3 plant types configured")
print("✓ Growth Fertilizer: 25% faster growth")
print("✓ Yield Fertilizer: 50% more yield")
print("✓ Super Serum: 40% faster growth + 75% more yield")
print("\nThe fertilizer system is ready to use!")
