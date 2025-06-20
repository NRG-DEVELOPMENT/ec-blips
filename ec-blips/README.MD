# EC-Blips

A comprehensive blip management system for FiveM servers with QBCore integration.

## Features

- In-game blip management with a clean, modern UI
- Database storage for persistent blips across server restarts
- Permission system with QBCore integration
- Whitelist system for FiveM and Discord IDs
- Full customization of blip properties (sprite, color, scale, name)
- Search functionality to find specific blips
- Edit and delete existing blips
- Find nearest blip to player's position

## Installation

1. Place the `ec-blips` folder in your server's resources directory
2. Add `ensure ec-blips` to your server.cfg
3. Import the SQL file or let the script create the table automatically
4. Configure the permissions and whitelist in the config.lua file

## Dependencies

- QBCore framework
- oxmysql

## Usage

### Player Commands

- `/blips` - Open the blip management menu (requires permission)

### Admin Commands

- `/addblipwhitelist [identifier]` - Add a player identifier to the whitelist
- `/removeblipwhitelist [identifier]` - Remove a player identifier from the whitelist
- `/listidentifiers [playerID]` - List all identifiers for a player

## Whitelist Identifiers

The whitelist supports all FiveM identifiers, including:

- `license:` - FiveM license (always available)
- `steam:` - Steam identifier
- `discord:` - Discord ID
- `ip:` - IP address
- `live:` - Xbox Live identifier
- `xbl:` - Xbox identifier
- `fivem:` - FiveM identifier

## Configuration

You can configure the following options in `config.lua`:

- Permission system (enable/disable)
- Required permission level
- Whitelist system (enable/disable)
- Command name
- Default blip settings
- Common blip colors and sprites
- Database table name

## Whitelist Management

The whitelist is stored in `whitelist.json` and can be managed through in-game commands or by directly editing the file.

To add a player to the whitelist, use:
