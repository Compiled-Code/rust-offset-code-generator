local options = 
{
    assembly = "Assembly-CSharp.dll",

    classes =
    {
        { nil, "BasePlayer" }, { nil, "BaseNetworkable" }
    }
};

local function fix_string(string)
    return string:gsub(">", "_"):gsub("<", "_"):gsub('(%S)(%u)', '%1_%2'):lower();
end

local function image_callback(image)
    local image_name = mono_image_get_name(image);

    if (image_name == options.assembly) then
        for _,current_class_data in pairs(options.classes) do
            local current_class = mono_findClass(current_class_data[1] or "", current_class_data[2]);

            local current_class_fields = mono_class_enumFields(current_class);

            if (current_class_data[1] ~= nil) then
                print("namespace engine::" .. fix_string(current_class_data[1]) .. "::" .. fix_string(current_class_data[2]) .. "::offsets" .. "\n{");
            else
                print("namespace engine::" .. fix_string(current_class_data[2]) .. "::offsets" .. "\n{");
            end

            for _,current_class_field in pairs(current_class_fields) do
                local current_class_field_offset = string.format("%X", current_class_field.offset);

                print("	constexpr auto", fix_string(current_class_field.name), "= 0x" .. current_class_field_offset .. ";");
            end

            print("}\n");
        end
    end
end

mono_enumImages(image_callback);
