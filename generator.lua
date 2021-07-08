local function to_snake_case(s)
  s = s:gsub('(%S)(%u)', '%1_%2'):lower()

  return s
end

local assemblies = mono_enumAssemblies();

for i,v in pairs(assemblies) do
    local image = mono_getImageFromAssembly(v);

    local image_name = mono_image_get_name(image);

    if (image_name == "Assembly-CSharp.dll") then
       local classes = mono_image_enumClasses(image);

       for i,v in pairs(classes) do
           if (v.classname == "BasePlayer") then
              local current_class = mono_findClass(v.namespace, v.classname);

              local current_class_fields = mono_class_enumFields(current_class);

              printf("namespace engine::offsets::" .. to_snake_case(v.namespace) .. to_snake_case(v.classname) .. "\n{");

              for i2,v2 in pairs(current_class_fields) do
                  print("	constexpr auto", to_snake_case(v2.name) .. " = 0x" .. string.format("%X", v2.offset) .. ";");
              end

              print("}");
           end
       end
    end
end
