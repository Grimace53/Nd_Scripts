# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-02-05

### Added
- Initial release of ND Drug System
- Placeable drug growing pots with multi-stage growth system
- Placeable crafting tables with customizable recipes
- Full ox_target integration for all interactions
- ox_inventory integration for item management
- ox_lib integration for UI elements and utilities
- qbx_core integration for player data
- md-drugs integration for drug system events
- Configuration system for easy customization
- README with comprehensive installation and usage instructions
- Example items file for ox_inventory setup

### Features
- Place and pick up growing pots anywhere in the world
- Automatic growth stages with visual changes
- Harvest system with configurable rewards
- Place and pick up crafting tables anywhere
- Multiple crafting recipes support
- Progress bar for crafting operations
- Distance validation for prop placement
- Ownership system for props
- Debug mode for troubleshooting
- Export functions for integration with other resources

### Technical Details
- Uses Lua 5.4
- Server-side prop management
- Client-side prop rendering and interactions
- Synchronized prop state across all clients
- Efficient prop spawning and despawning
- Ground-level placement with raycasting
