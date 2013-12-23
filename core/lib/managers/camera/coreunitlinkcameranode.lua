-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\coreunitlinkcameranode.luac 

core:module("CoreUnitLinkCameraNode")
core:import("CoreTransformCameraNode")
core:import("CoreClass")
core:import("CoreCode")
if not UnitLinkCameraNode then
  UnitLinkCameraNode = CoreClass.class(CoreTransformCameraNode.TransformCameraNode)
end
UnitLinkCameraNode.init = function(l_1_0, l_1_1)
  UnitLinkCameraNode.super.init(l_1_0, l_1_1)
end

UnitLinkCameraNode.compile_settings = function(l_2_0, l_2_1)
  UnitLinkCameraNode.super.compile_settings(l_2_0, l_2_1)
  do
    local xml_node_children = l_2_0:children()
    for xml_child_node in xml_node_children do
      if xml_child_node:name() == "link" then
        if xml_child_node:has_parameter("object") then
          assert(xml_child_node:has_parameter("connection"))
        end
        local object_str = xml_child_node:parameter("object")
        local object = Idstring(object_str)
        local connection_type = xml_child_node:parameter("connection")
        if connection_type == "pos_x" then
          l_2_1.link_x = object
          for (for control) in (for generator) do
          end
          if connection_type == "pos_y" then
            l_2_1.link_y = object
            for (for control) in (for generator) do
            end
            if connection_type == "pos_z" then
              l_2_1.link_z = object
              for (for control) in (for generator) do
              end
              if connection_type == "pos" then
                l_2_1.link_x = object
                l_2_1.link_y = object
                l_2_1.link_z = object
                for (for control) in (for generator) do
                end
                if connection_type == "rot" then
                  l_2_1.link_rot = object
                  for (for control) in (for generator) do
                  end
                  if connection_type == "all" then
                    l_2_1.link_x = object
                    l_2_1.link_y = object
                    l_2_1.link_z = object
                    l_2_1.link_rot = object
                  end
                end
              end
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

UnitLinkCameraNode.set_unit = function(l_3_0, l_3_1)
  local settings = l_3_0._settings
  if settings.link_x then
    l_3_0._link_x = l_3_1:get_object(settings.link_x)
  end
  if settings.link_y then
    l_3_0._link_y = l_3_1:get_object(settings.link_y)
  end
  if settings.link_z then
    l_3_0._link_z = l_3_1:get_object(settings.link_z)
  end
  if settings.link_rot then
    l_3_0._link_rot = l_3_1:get_object(settings.link_rot)
  end
  l_3_0._unit = l_3_1
end

UnitLinkCameraNode.update = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local local_position = l_4_0._local_position
  if CoreCode.alive(l_4_0._unit) then
    local link = l_4_0._link_x
    if link then
      mvector3.set_x(local_position, link:position().x)
    end
    link = l_4_0._link_y
    if link then
      mvector3.set_y(local_position, link:position().y)
    end
    link = l_4_0._link_z
    if link then
      mvector3.set_z(local_position, link:position().z)
    end
    link = l_4_0._link_rot
    if link then
      l_4_0._local_rotation = link:rotation()
    end
  end
  UnitLinkCameraNode.super.update(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
end


