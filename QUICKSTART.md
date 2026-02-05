# Quick Start Guide

Get the fertilizer system running on your server in 5 minutes!

## Step 1: Install the Resource (1 minute)

```bash
# Copy the Nd_Scripts folder to your resources directory
cp -r Nd_Scripts /path/to/your/server/resources/

# Add to server.cfg
echo "ensure Nd_Scripts" >> server.cfg
```

## Step 2: Add Items to Your Framework (2 minutes)

### For QBCore:

1. Open `qb-core/shared/items.lua`
2. Copy the three item definitions from `QBCORE_INTEGRATION.md` 
3. Paste them into your items.lua file
4. Register the useable items (see full guide in QBCORE_INTEGRATION.md)

### For ESX:

1. Run the SQL query from `ESX_INTEGRATION.md` in your database
2. Register the useable items (see full guide in ESX_INTEGRATION.md)

## Step 3: Add to Shops (1 minute) [OPTIONAL]

Add the items to your shop with these recommended prices:
- **Growth Fertilizer**: $50-100
- **Yield Fertilizer**: $75-150
- **Super Serum**: $150-300

See integration guides for specific shop configuration examples.

## Step 4: Restart Server (30 seconds)

```bash
restart Nd_Scripts
# or restart your entire server
```

## Step 5: Test It! (30 seconds)

In-game commands:
```
/plant tomato          - Plant a test crop
/usefertilizer super_serum - Apply super serum to the plant
```

## That's It! 🎉

Your fertilizer system is now live!

## What Players Can Do

1. **Buy fertilizers** from shops you configured
2. **Plant crops** using your existing farming system
3. **Apply fertilizers** to growing plants
4. **Harvest increased yields** faster than before!

## Need Help?

- **Full Documentation**: See README.md
- **Integration Guides**: QBCORE_INTEGRATION.md or ESX_INTEGRATION.md
- **Examples**: EXAMPLES.md
- **Configuration**: Edit config.lua to customize effects

## Quick Configuration Tips

Want to change fertilizer effects? Edit `config.lua`:

```lua
Config.Fertilizers = {
    super_serum = {
        growSpeedMultiplier = 1.4,  -- Change to 2.0 for 100% faster!
        yieldMultiplier = 1.75,     -- Change to 3.0 for 200% more yield!
        -- ... other settings
    }
}
```

## Common Issues

**Items not showing in inventory?**
- Make sure you added items to your framework's items file
- Restart the inventory resource

**Can't use items?**
- Register useable items per your framework (see integration guides)
- Check server console for errors

**Fertilizer not working?**
- Make sure you're near a planted crop
- Check that the plant isn't already fertilized
- Verify the plant hasn't finished growing yet

## Support

For more detailed information, see:
- README.md - Complete documentation
- EXAMPLES.md - Usage examples
- SUMMARY.md - Technical overview

Happy farming! 🌱🌾💉
