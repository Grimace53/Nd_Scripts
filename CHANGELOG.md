# Changelog

All notable changes to the Nd_Scripts farming system will be documented in this file.

## [1.0.0] - 2026-02-05

### Added
- Initial release of the Fertilizer System
- Three fertilizer item types:
  - **Growth Fertilizer**: Increases plant growth speed by 25%
  - **Yield Fertilizer**: Increases harvest yield by 50%
  - **Super Serum**: Increases both growth speed (40%) and yield (75%)
- Complete FiveM resource structure with fxmanifest.lua
- Comprehensive configuration system in config.lua
- Server-side plant management and fertilizer application logic
- Client-side fertilizer usage and plant interaction system
- Shared items definitions compatible with QBCore and ESX
- Integration guides for QBCore and ESX frameworks
- Detailed usage examples and comparison tables
- Complete documentation and README
- Test script for validation
- Export functions for external resource integration

### Features
- Plants track fertilizer application status
- Dynamic growth time calculation based on fertilizer effects
- Dynamic yield calculation with multipliers
- Support for multiple plant types (tomato, wheat, corn)
- Configurable fertilizer limits per plant
- Event-driven architecture for easy integration
- Compatible with most FiveM frameworks

### Documentation
- README.md: Main documentation with installation and usage
- QBCORE_INTEGRATION.md: Step-by-step QBCore integration guide
- ESX_INTEGRATION.md: Step-by-step ESX integration guide
- EXAMPLES.md: Practical examples with comparison tables
- CHANGELOG.md: Version history and changes

### Configuration
- Configurable fertilizer multipliers
- Configurable plant types and properties
- Configurable base grow times and yields
- Adjustable fertilizer duration and limits

### Commands
- `/plant [type]`: Plant a crop (for testing)
- `/usefertilizer [type]`: Apply fertilizer to nearby plant

### Exports
#### Client-side
- `UseGrowthFertilizer()`: Apply growth fertilizer
- `UseYieldFertilizer()`: Apply yield fertilizer
- `UseSuperSerum()`: Apply super serum

#### Server-side
- `CreatePlant(plantId, plantType, coords, owner)`: Create a new plant
- `GetPlant(plantId)`: Get plant information
- `GetAllPlants()`: Get all active plants

### Framework Support
- QBCore: Full support with useable items
- ESX: Full support with useable items
- Standalone: Core functionality works independently

### Technical Details
- Event-driven architecture
- Multiplier-based effect system
- Dynamic time recalculation
- Plant state tracking
- Fertilizer application validation
- Harvest ready notifications

---

## Future Enhancements (Planned)

### Potential Features
- Visual effects when applying fertilizers
- Plant quality system (poor/normal/excellent)
- Fertilizer durability/decay over time
- Weather effects on fertilizer effectiveness
- Combination restrictions (some plants work better with certain fertilizers)
- Advanced crafting system for fertilizers
- Market fluctuation based on fertilizer usage
- Achievement system for successful farming
- Fertilizer analysis reports
- Seasonal effects

### Integration Ideas
- ox_inventory compatibility
- ox_target integration for plant interaction
- qb-target integration
- Notification system improvements
- Progress bars for fertilizer application
- 3D text labels for plant status
- Mobile app for plant monitoring

---

## Migration Guide

### From No Fertilizer System
1. Install the resource
2. Add items to your framework
3. Configure shop prices
4. Integrate with existing farming scripts

### Breaking Changes
- None (initial release)

---

## Credits

- **Author**: Neon Dream Development Team
- **Framework**: FiveM
- **License**: Open Source for Neon Dream Community

---

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact server administrators
- Check documentation files

---

## Version Notes

**v1.0.0** is the initial release and provides a stable foundation for the fertilizer system. All core features are implemented and tested. The system is ready for production use on FiveM servers.
