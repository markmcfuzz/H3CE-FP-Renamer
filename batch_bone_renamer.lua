-- H3 to CE First Person Bone Renamer
-- This script processes all JMM and JMO files in the 'animations' folder and renames bone names 
-- from H3 format to CE format, saving the results in the 'converted' folder.

-- Add lua_modules to package path
package.path = package.path .. ";lua_modules/?.lua;lua_modules/?/?.lua"

-- Load useful modules
local luna = require('luna')
local path = require('path')

-- Define the bone name mapping from H3 to CE format
local bone_mapping = {
    ["base"] = "frame bone24",
    ["camera_control"] = "frame camera control",
    ["l_upperarm"] = "frame l upperarm",
    ["r_upperarm"] = "frame r upperarm", 
    ["l_forearm"] = "frame l forearm",
    ["r_forearm"] = "frame r forearm",
    ["l_hand"] = "frame l wriste",
    ["r_hand"] = "frame r wriste",
    ["l_index_low"] = "frame l index low",
    ["l_middle_low"] = "frame l middlelow",
    ["l_pinky_low"] = "frame l pinky low",
    ["l_ring_low"] = "frame l ring low",
    ["l_thumb_low"] = "frame l thumb low",
    ["r_index_low"] = "frame r index low",
    ["r_middle_low"] = "frame r middle low",
    ["r_pinky_low"] = "frame r pinky low",
    ["r_ring_low"] = "frame r ring low",
    ["r_thumb_low"] = "frame r thumb low",
    ["l_index_mid"] = "frame l index mid",
    ["l_middle_mid"] = "frame l middle mid",
    ["l_pinky_mid"] = "frame l pinky mid",
    ["l_ring_mid"] = "frame l ring mid",
    ["l_thumb_mid"] = "frame l thumb mid",
    ["r_index_mid"] = "frame r index mid",
    ["r_middle_mid"] = "frame r middle mid",
    ["r_pinky_mid"] = "frame r pinky mid",
    ["r_ring_mid"] = "frame r ring mid",
    ["r_thumb_mid"] = "frame r thumb mid",
    ["l_index_tip"] = "frame l index tip",
    ["l_middle_tip"] = "frame l middle tip",
    ["l_pinky_tip"] = "frame l pinky tip",
    ["l_ring_tip"] = "frame l ring tip",
    ["l_thumb_tip"] = "frame l thumb tip",
    ["r_index_tip"] = "frame r index tip",
    ["r_middle_tip"] = "frame r middle tip",
    ["r_pinky_tip"] = "frame r pinky tip",
    ["r_ring_tip"] = "frame r ring tip",
    ["r_thumb_tip"] = "frame r thumb tip",
    ["gun"] = "frame gun",
    ["ammo"] = "frame ammo",
    ["barrel"] = "frame barrel",
    ["scope_link"] = "frame scope link"
}

-- Function to read file content using luna
local function read_file(filename)
    return luna.file.read(filename)
end

-- Function to write file content using luna
local function write_file(filename, content)
    return luna.file.write(filename, content)
end

-- Function to replace bone names in the content using luna utilities
local function replace_bone_names(content, mapping)
    local lines = {}
    local renamed_count = 0

    -- Split content into lines using luna
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Process each line
    for i, line in ipairs(lines) do
        -- Check if this line contains a bone name that needs to be replaced
        local trimmed_line = line:trim() -- Use luna's trim function
        
        if mapping[trimmed_line] then
            lines[i] = mapping[trimmed_line]
            renamed_count = renamed_count + 1
        end
    end

    return table.concat(lines, "\n"), renamed_count
end

-- Function to check if directory exists using luna
local function directory_exists(dirname)
    -- Try to create a test file in the directory to see if it exists
    local testpath = dirname .. "/luna_test.tmp"
    local file = io.open(testpath, "w")
    if file then
        file:close()
        os.remove(testpath) -- Clean up
        return true
    end
    return false
end

-- Function to create directory using hybrid approach (OS + luna validation)
local function create_directory(dirname)
    if not directory_exists(dirname) then
        print("Creating directory: " .. dirname)

        -- Use OS command to create directory
        local result = os.execute('mkdir "' .. dirname .. '" 2>NUL')

        -- Validate creation using luna by trying to write a test file
        local testpath = dirname .. "/luna_test.tmp"
        local file = io.open(testpath, "w")
        if file then
            file:close()
            os.remove(testpath) -- Clean up
            print("  -> Successfully created: " .. dirname)
            return true
        else
            print("  -> Warning: Could not create directory: " .. dirname)
            return false
        end
    else
        print("Directory already exists: " .. dirname)
    end
    return true
end

-- Function to get animation files (JMM and JMO) in a directory
local function get_animation_files(directory)
    local files = {}

    -- Check if directory exists
    if not directory_exists(directory) then
        return files
    end

    -- Get JMM files
    local command = 'dir "' .. directory .. '\\*.JMM" /b 2>nul'
    local pipe = io.popen(command)
    if pipe then
        for filename in pipe:lines() do
            if filename and filename ~= "" then
                local filepath = directory .. "\\" .. filename
                -- Verify file exists using luna
                if luna.file.exists(filepath) then
                    table.insert(files, filepath)
                end
            end
        end
        pipe:close()
    end

    -- Get JMO files
    command = 'dir "' .. directory .. '\\*.JMO" /b 2>nul'
    pipe = io.popen(command)
    if pipe then
        for filename in pipe:lines() do
            if filename and filename ~= "" then
                local filepath = directory .. "\\" .. filename
                -- Verify file exists using luna
                if luna.file.exists(filepath) then
                    table.insert(files, filepath)
                end
            end
        end
        pipe:close()
    end

    -- Sort files for consistent processing order
    table.sort(files)
    return files
end

-- Function to get filename from path using path module
local function get_filename(filepath)
    return path.file(filepath)
end

-- Function to get file extension
local function get_file_extension(filepath)
    return path.ext(filepath):upper()
end

-- Function to process a single file
local function process_file(input_path, output_path, mapping)
    print("Processing: " .. get_filename(input_path))

    -- Read the original file
    local content = read_file(input_path)
    if not content then
        print("  Error: Could not read file")
        return false, 0
    end

    -- Replace bone names
    local new_content, renamed_count = replace_bone_names(content, mapping)

    -- Add an extra blank line at the end to match original format
    if not luna.string.endswith(new_content, "\n\n") then
        if luna.string.endswith(new_content, "\n") then
            new_content = new_content .. "\n"
        else
            new_content = new_content .. "\n"
        end
    end

    -- Write the new file
    if write_file(output_path, new_content) then
        print("  -> Saved to: " .. get_filename(output_path))
        print("  -> Bones renamed: " .. renamed_count)
        return true, renamed_count
    else
        print("  Error: Could not write file")
        return false, 0
    end
end

-- Main execution
local function main()
    local animations_folder = "animations"
    local converted_folder = "converted"

    print("H3 to CE First Person Animation Bone Renamer")
    print("======================")
    print("Input folder: " .. animations_folder)
    print("Output folder: " .. converted_folder)
    print("")

    -- Check if animations folder exists
    if not directory_exists(animations_folder) then
        print("Error: '" .. animations_folder .. "' folder not found!")
        print("Please create an 'animations' folder and put your JMM files in it.")
        print("")
        print("Current directory contents:")
        os.execute('dir /b')
        return
    end

    -- Ensure converted folder exists
    if not create_directory(converted_folder) then
        print("Error: Could not create output folder '" .. converted_folder .. "'!")
        print("Please check your permissions and try again.")
        return
    end
    print("")

    -- Find all animation files (JMM and JMO) in the animations folder
    local animation_files = get_animation_files(animations_folder)

    if #animation_files == 0 then
        print("No JMM or JMO files found in '" .. animations_folder .. "' folder!")
        print("Please add some .JMM or .JMO files to process.")
        return
    end

    print("Found " .. #animation_files .. " animation file(s) to process:")
    for _, file in ipairs(animation_files) do
        local filename = get_filename(file)
        local file_ext = get_file_extension(file)
        print("  - " .. filename .. " (" .. file_ext .. ")")
    end
    print("")

    -- Process each file
    local total_files = 0
    local successful_files = 0
    local total_bones_renamed = 0

    for _, input_file in ipairs(animation_files) do
        local filename = get_filename(input_file)
        local output_file = converted_folder .. "\\" .. filename

        total_files = total_files + 1
        local success, bones_renamed = process_file(input_file, output_file, bone_mapping)

        if success then
            successful_files = successful_files + 1
            total_bones_renamed = total_bones_renamed + bones_renamed
        end

        print("") -- Empty line for readability
    end

    -- Summary
    print("==================================================")
    print("BATCH PROCESSING COMPLETE")
    print("==================================================")
    print("Total files processed: " .. total_files)
    print("Successfully converted: " .. successful_files)
    print("Failed: " .. (total_files - successful_files))
    print("Total bones renamed: " .. total_bones_renamed)
    print("")
    print("Converted files saved in: " .. converted_folder)

    if successful_files > 0 then
        print("")
        print("+ All files processed successfully!")
    elseif total_files - successful_files > 0 then
        print("")
        print("! Some files failed to process. Check the errors above.")
    end
end

main()