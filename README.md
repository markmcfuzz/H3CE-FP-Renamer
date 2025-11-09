# H3 to CE First Person Animation Bone Renamer

A Lua script that converts Halo animation files `.JMM` and `.JMO` from **Halo 3** bone naming format to **Halo: Combat Evolved** format by adding proper prefixes to bone names based on the original HCE cyborg arms bone names.

## Features

- **Batch Processing**: Processes all animation files in a folder automatically
- **Dual Format Support**: Handles both .JMM and .JMO animation files
- **LuaJIT Powered**: Fast execution with modern Lua modules (luna, path)
- **Console Optimized**: Designed for cmder, ConEmu, and Windows Terminal
- **42 Bone Mappings**: Complete conversion of all common first-person weapon animation bones

## Requirements

- **LuaJIT 2.1+** (tested with LuaJIT)
- **Console Environment**: cmder, ConEmu, Windows Terminal, or similar
- **Lua Modules**: luna and path modules (included in lua_modules/)

## Installation

1. Ensure LuaJIT is installed and available in your PATH
2. Clone or download this repository
3. The `lua_modules/` directory contains required dependencies (luna, path)

## Usage

### Quick Start
1. Create an `animations` folder and place your .JMM/.JMO files in it
2. Open your console (cmder recommended) in the project directory
3. Run: `luajit batch_bone_renamer.lua`
4. Converted files will appear in the `converted` folder

### Command
```bash
luajit batch_bone_renamer.lua
```

## How It Works

The script processes animation files from the `animations` folder and creates converted files in the `converted` folder with the following bone name conversions:

### Supported File Formats
- **.JMM files** - No Movement Animation
- **.JMO files** - Overlay Animation

Both formats are automatically detected and processed with the same bone mapping rules.

### Bone Name Conversions

The script converts 42 bone names from H3 format to CE format:
| Original (H3) | Renamed (CE Format) |
|---------------|-------------------|
| base | frame bone24 |
| l_upperarm | frame l upperarm |
| r_upperarm | frame r upperarm |
| l_forearm | frame l forearm |
| r_forearm | frame r forearm |
| l_hand | frame l wriste |
| r_hand | frame r wriste |
| (and 30+ finger bones) | (with frame prefix) |

## Example Output

When you run the script, you'll see output like:
```
H3 to CE First Person Animation Bone Renamer
======================
Input folder: animations
Output folder: converted

Found 2 animation file(s) to process:
  - test.JMM (JMM)
  - test.JMO (JMO)

Processing: test.JMM
  -> Saved to: test.JMM
  -> Bones renamed: 42

Processing: test.JMO
  -> Saved to: test.JMO
  -> Bones renamed: 42

==================================================
BATCH PROCESSING COMPLETE
==================================================
Total files processed: 2
Successfully converted: 2
Failed: 0
Total bones renamed: 84

Converted files saved in: converted

+ All files processed successfully!
```

## Project Structure

```
JMA_renamer/
├── animations/                    # Input folder - place your .JMM/.JMO files here
│   ├── animation1.JMM
│   ├── animation2.JMO
│   └── animation3.JMM
├── converted/                     # Output folder - converted files appear here
│   ├── animation1.JMM            # (with renamed bones)
│   ├── animation2.JMO
│   └── animation3.JMM
├── lua_modules/                   # Required Lua modules
│   ├── luna.lua                  # File I/O and utilities
│   ├── path.lua                  # Path manipulation
│   └── ...
├── batch_bone_renamer.lua         # Main script
└── README.md
```

## Technical Details

- **Luna Module**: Provides clean file I/O operations and string utilities
- **Path Module**: Handles cross-platform path operations
- **Performance**: Processes files quickly with efficient string operations
- **Memory**: Low memory footprint, suitable for large batches

## Important Notes

- **Data Preservation**: The script preserves all animation data and only changes bone names
- **File Safety**: Output files maintain the same structure as originals and are safe to use
- **Backup Recommended**: Always keep backups of your original files
- **Complete Coverage**: Handles 42 different bone mappings covering all common bones in first-person weapon animations
- **Mixed Formats**: Can process .JMM and .JMO files in the same batch operation

## Troubleshooting

### Common Issues

**"animations folder not found"**
- Create an `animations` folder in the same directory as the script
- Place your .JMM/.JMO files inside this folder

**"LuaJIT not found"** 
- Install LuaJIT from https://luajit.org/
- Ensure LuaJIT is added to your system PATH
- Test with: `luajit -v`

**"Module not found"**
- Ensure the `lua_modules/` directory exists
- Verify `luna.lua` and `path.lua` are present in the modules folder

**"No files found"**
- Check that your files have .JMM or .JMO extensions (case-sensitive)
- Verify files are in the `animations` folder, not subfolders

### Console Compatibility
- **Recommended**: cmder, ConEmu, Windows Terminal
- **Basic Support**: Command Prompt, PowerShell
- **Features**: Full Unicode support, colored output, better file handling
