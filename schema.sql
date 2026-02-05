-- Database Schema for Drug System
-- Execute this SQL to create the necessary tables

-- Table for Weed (Growable)
CREATE TABLE IF NOT EXISTS `drug_weed` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `planted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `position` TEXT NOT NULL, -- JSON: {x, y, z}
    `growth_stage` INT DEFAULT 0, -- 0: planted, 1: growing, 2: ready
    `last_watered` TIMESTAMP NULL,
    `harvestable` BOOLEAN DEFAULT FALSE,
    `fertilizer_type` VARCHAR(50) NULL,
    `fertilizer_applied_at` TIMESTAMP NULL,
    `growth_multiplier` DECIMAL(3,2) DEFAULT 1.00,
    `yield_multiplier` DECIMAL(3,2) DEFAULT 1.00,
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_harvestable` (`harvestable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Cocaine (Growable)
CREATE TABLE IF NOT EXISTS `drug_cocaine` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `planted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `position` TEXT NOT NULL,
    `growth_stage` INT DEFAULT 0,
    `last_watered` TIMESTAMP NULL,
    `harvestable` BOOLEAN DEFAULT FALSE,
    `fertilizer_type` VARCHAR(50) NULL,
    `fertilizer_applied_at` TIMESTAMP NULL,
    `growth_multiplier` DECIMAL(3,2) DEFAULT 1.00,
    `yield_multiplier` DECIMAL(3,2) DEFAULT 1.00,
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_harvestable` (`harvestable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Meth (Non-Growable - AI Interaction)
CREATE TABLE IF NOT EXISTS `drug_meth` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL,
    `last_interaction` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `items_received` TEXT NOT NULL, -- JSON: [{item, amount}]
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_location` (`location_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Heroin (Non-Growable - AI Interaction)
CREATE TABLE IF NOT EXISTS `drug_heroin` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL,
    `last_interaction` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `items_received` TEXT NOT NULL,
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_location` (`location_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for LSD (Non-Growable - AI Interaction)
CREATE TABLE IF NOT EXISTS `drug_lsd` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL,
    `last_interaction` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `items_received` TEXT NOT NULL,
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_location` (`location_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cooldown tracking table
CREATE TABLE IF NOT EXISTS `drug_cooldowns` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `drug_type` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL,
    `cooldown_until` TIMESTAMP NOT NULL,
    UNIQUE KEY `unique_cooldown` (`identifier`, `drug_type`, `location_index`),
    INDEX `idx_cooldown_check` (`identifier`, `drug_type`, `location_index`, `cooldown_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Placed props tracking table (for PR #4 integration)
CREATE TABLE IF NOT EXISTS `drug_placed_props` (
    `id` VARCHAR(100) PRIMARY KEY,
    `owner` VARCHAR(50) NOT NULL,
    `coords` TEXT NOT NULL, -- JSON: {x, y, z, w}
    `prop_type` VARCHAR(50) NOT NULL,
    `type` VARCHAR(20) NOT NULL, -- 'growing' or 'crafting'
    `model` VARCHAR(100) NOT NULL,
    `placed` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `current_stage` INT DEFAULT 1,
    `ready` BOOLEAN DEFAULT FALSE,
    `plant_health` INT DEFAULT 100,
    `water_level` INT DEFAULT 50,
    `light_level` INT DEFAULT 75,
    `fertilizer_level` INT DEFAULT 0,
    `fertilizer_type` VARCHAR(50) NULL,
    INDEX `idx_owner` (`owner`),
    INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
