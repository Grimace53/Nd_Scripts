-- Database Schema for Drug System
-- This file contains SQL to create tables for each drug type

--[[
    Execute this SQL to create the necessary tables.
    Each drug type gets its own table for tracking drug instances.
]]

-- Table for Weed (Growable)
CREATE TABLE IF NOT EXISTS `drug_weed` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `planted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `position` TEXT NOT NULL, -- JSON: {x, y, z}
    `growth_stage` INT DEFAULT 0, -- 0: planted, 1: growing, 2: ready
    `last_watered` TIMESTAMP NULL,
    `harvestable` BOOLEAN DEFAULT FALSE,
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
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_harvestable` (`harvestable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Meth (Non-Growable - AI Interaction)
CREATE TABLE IF NOT EXISTS `drug_meth` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL, -- Which location was used
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

-- Cooldown tracking table (for non-growable drugs)
CREATE TABLE IF NOT EXISTS `drug_cooldowns` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `drug_type` VARCHAR(50) NOT NULL,
    `location_index` INT NOT NULL,
    `cooldown_until` TIMESTAMP NOT NULL,
    UNIQUE KEY `unique_cooldown` (`identifier`, `drug_type`, `location_index`),
    INDEX `idx_cooldown_check` (`identifier`, `drug_type`, `location_index`, `cooldown_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
