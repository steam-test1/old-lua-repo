-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dlcmanager.luac 

if not DLCManager then
  DLCManager = class()
end
DLCManager.PLATFORM_CLASS_MAP = {}
DLCManager.new = function(l_1_0, ...)
  do
    local platform = SystemInfo:platform()
    return l_1_0.PLATFORM_CLASS_MAP[platform:key()] or GenericDLCManager:new(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not GenericDLCManager then
  GenericDLCManager = class()
end
GenericDLCManager.init = function(l_2_0)
  l_2_0._debug_on = Application:production_build()
  l_2_0:_set_dlc_save_table()
end

GenericDLCManager._set_dlc_save_table = function(l_3_0)
  if not Global.dlc_save then
    Global.dlc_save = {packages = {}}
  end
end

GenericDLCManager.init_finalize = function(l_4_0)
  managers.savefile:add_load_sequence_done_callback_handler(callback(l_4_0, l_4_0, "_load_done"))
end

GenericDLCManager._load_done = function(l_5_0, ...)
  l_5_0:give_dlc_package()
  if managers.blackmarket then
    managers.blackmarket:verify_dlc_items()
  else
    Application:error("[GenericDLCManager] _load_done(): BlackMarketManager not yet initialized!")
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

GenericDLCManager.give_dlc_package = function(l_6_0)
  for package_id,data in pairs(tweak_data.dlc) do
    if data.free or l_6_0[data.dlc](l_6_0) then
      print("[DLC] Ownes dlc", data.free, data.dlc)
      if not Global.dlc_save.packages[package_id] then
        Global.dlc_save.packages[package_id] = true
        if not data.content.loot_drops then
          for _,loot_drop in ipairs({}) do
          end
          for i = 1, loot_drop.amount do
            local entry = tweak_data.blackmarket[loot_drop.type_items][loot_drop.item_entry]
            local global_value = loot_drop.global_value or data.content.loot_global_value or package_id
            print(i .. "  give", loot_drop.type_items, loot_drop.item_entry, global_value)
            managers.blackmarket:add_to_inventory(global_value, loot_drop.type_items, loot_drop.item_entry)
          end
        end
      else
        print("[DLC] Allready been given dlc package", package_id)
      end
      if not data.content.upgrades then
        for _,upgrade in ipairs({}) do
        end
        managers.upgrades:aquire_default(upgrade)
      end
      for (for control),package_id in (for generator) do
      end
      print("[DLC] Didn't own DLC package", package_id)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GenericDLCManager.save = function(l_7_0, l_7_1)
  l_7_1.dlc_save = Global.dlc_save
end

GenericDLCManager.load = function(l_8_0, l_8_1)
  if l_8_1.dlc_save and l_8_1.dlc_save.packages then
    Global.dlc_save = l_8_1.dlc_save
  end
end

GenericDLCManager.on_reset_profile = function(l_9_0)
  Global.dlc_save = nil
  l_9_0:_set_dlc_save_table()
  l_9_0:give_dlc_package()
end

GenericDLCManager.on_signin_complete = function(l_10_0)
end

GenericDLCManager.has_dlc = function(l_11_0, l_11_1)
  local dlc_data = Global.dlc_manager.all_dlc_data[l_11_1]
  if not dlc_data then
    Application:error("Didn't have dlc data for", l_11_1)
    return false
  end
  return dlc_data.verified
end

GenericDLCManager.has_full_game = function(l_12_0)
  return Global.dlc_manager.all_dlc_data.full_game.verified
end

GenericDLCManager.is_trial = function(l_13_0)
  return not l_13_0:has_full_game()
end

GenericDLCManager.dlcs_string = function(l_14_0)
  local s = ""
  s = s .. (l_14_0:has_preorder() and "preorder " or "")
  return s
end

GenericDLCManager.has_corrupt_data = function(l_15_0)
  return l_15_0._has_corrupt_data
end

GenericDLCManager.has_preorder = function(l_16_0)
  if Global.dlc_manager.all_dlc_data.preorder then
    return Global.dlc_manager.all_dlc_data.preorder.verified
  end
end

GenericDLCManager.has_cce = function(l_17_0)
  if Global.dlc_manager.all_dlc_data.career_criminal_edition then
    return Global.dlc_manager.all_dlc_data.career_criminal_edition.verified
  end
end

if not PS3DLCManager then
  PS3DLCManager = class(GenericDLCManager)
end
local l_0_0 = DLCManager.PLATFORM_CLASS_MAP
local l_0_1 = Idstring("PS3"):key()
l_0_0[l_0_1] = PS3DLCManager
l_0_0 = PS3DLCManager
l_0_0.SERVICE_ID = "EP4040-BLES01902_00"
l_0_0 = PS3DLCManager
l_0_1 = function(l_18_0)
  PS3DLCManager.super.init(l_18_0)
  if not Global.dlc_manager then
    Global.dlc_manager = {}
    Global.dlc_manager.all_dlc_data = {full_game = {filename = "full_game_key.edat", product_id = "EP4040-BLES01902_00-PAYDAY2NPEU00000"}, preorder = {filename = "preorder_dlc_key.edat", product_id = "EP4040-BLES01902_00-PPAYDAY2XX000006"}}
    l_18_0:_verify_dlcs()
  end
end

l_0_0.init = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_19_0)
  local all_dlc = {}
  for dlc_name,dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
    if not dlc_data.verified then
      table.insert(all_dlc, dlc_data.filename)
    end
  end
  do
    local verified_dlcs = PS3:check_dlc_availability(all_dlc)
    Global.dlc_manager.verified_dlcs = verified_dlcs
    for _,verified_filename in pairs(verified_dlcs) do
      for dlc_name,dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
        if dlc_data.filename == verified_filename then
          print("DLC verified:", verified_filename)
          dlc_data.verified = true
          for (for control),_ in (for generator) do
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._verify_dlcs = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_20_0)
  PS3:set_service_id(l_20_0.SERVICE_ID)
  local result = NPCommerce:init()
  print("init result", result)
  if not result then
    MenuManager:show_np_commerce_init_fail()
    NPCommerce:destroy()
    return 
  end
  local result = NPCommerce:open(callback(l_20_0, l_20_0, "cb_NPCommerce"))
  print("open result", result)
  if result < 0 then
    MenuManager:show_np_commerce_init_fail()
    NPCommerce:destroy()
    return 
  end
  return true
end

l_0_0._init_NPCommerce = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_21_0)
  print("[PS3DLCManager:buy_full_game]")
  if l_21_0._activity then
    return 
  end
  if not l_21_0:_init_NPCommerce() then
    return 
  end
  managers.menu:show_waiting_NPCommerce_open()
  l_21_0._request = {type = "buy_product", product = "full_game"}
  l_21_0._activity = {type = "open"}
end

l_0_0.buy_full_game = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_22_0, l_22_1)
  print("[PS3DLCManager:buy_product]", l_22_1)
  if l_22_0._activity then
    return 
  end
  if not l_22_0:_init_NPCommerce() then
    return 
  end
  managers.menu:show_waiting_NPCommerce_open()
  l_22_0._request = {type = "buy_product", product = l_22_1}
  l_22_0._activity = {type = "open"}
end

l_0_0.buy_product = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_23_0, l_23_1, l_23_2)
  print("[PS3DLCManager:cb_NPCommerce]", l_23_1, l_23_2)
  for i,k in pairs(l_23_2) do
    print(i, k)
  end
  if not l_23_0._NPCommerce_cb_results then
    l_23_0._NPCommerce_cb_results = {}
  end
  if l_23_0._activity then
    print("self._activity", inspect(l_23_0._activity))
  end
  table.insert(l_23_0._NPCommerce_cb_results, {l_23_1, l_23_2})
  if not l_23_0._activity then
    return 
  else
    if l_23_0._activity.type == "open" then
      if l_23_2.category_error or l_23_2.category_done == false then
        l_23_0._activity = nil
        managers.system_menu:close("waiting_for_NPCommerce_open")
        l_23_0:_close_NPCommerce()
      else
        managers.system_menu:close("waiting_for_NPCommerce_open")
        local product_id = Global.dlc_manager.all_dlc_data[l_23_0._request.product].product_id
        print("starting storebrowse", product_id)
        local ret = NPCommerce:storebrowse("product", product_id, true)
        if not ret then
          l_23_0._activity = nil
          managers.menu:show_NPCommerce_checkout_fail()
          l_23_0:_close_NPCommerce()
        end
        l_23_0._activity = {type = "browse"}
      else
        if l_23_0._activity.type == "browse" then
          if l_23_2.browse_succes then
            l_23_0._activity = nil
            managers.menu:show_NPCommerce_browse_success()
            l_23_0:_close_NPCommerce()
          elseif l_23_2.browse_back then
            l_23_0._activity = nil
            l_23_0:_close_NPCommerce()
          elseif l_23_2.category_error then
            l_23_0._activity = nil
            managers.menu:show_NPCommerce_browse_fail()
            l_23_0:_close_NPCommerce()
          else
            if l_23_0._activity.type == "checkout" then
              if l_23_2.checkout_error then
                l_23_0._activity = nil
                managers.menu:show_NPCommerce_checkout_fail()
                l_23_0:_close_NPCommerce()
              elseif l_23_2.checkout_cancel then
                l_23_0._activity = nil
                l_23_0:_close_NPCommerce()
              elseif l_23_2.checkout_success then
                l_23_0._activity = nil
                l_23_0:_close_NPCommerce()
              end
            end
          end
        end
      end
    end
  end
  print("/[PS3DLCManager:cb_NPCommerce]")
end

l_0_0.cb_NPCommerce = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_24_0)
  print("[PS3DLCManager:_close_NPCommerce]")
  NPCommerce:destroy()
end

l_0_0._close_NPCommerce = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_25_0, l_25_1)
  NPCommerce:checkout(l_25_1.skuid)
end

l_0_0.cb_confirm_purchase_yes = l_0_1
l_0_0 = PS3DLCManager
l_0_1 = function(l_26_0)
  l_26_0._activity = nil
  l_26_0:_close_NPCommerce()
end

l_0_0.cb_confirm_purchase_no = l_0_1
l_0_0 = X360DLCManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericDLCManager
  l_0_0 = l_0_0(l_0_1)
end
X360DLCManager = l_0_0
l_0_0 = DLCManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = Idstring
l_0_1 = l_0_1("X360")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = X360DLCManager
l_0_0 = X360DLCManager
l_0_1 = function(l_27_0)
  X360DLCManager.super.init(l_27_0)
  if not Global.dlc_manager then
    Global.dlc_manager = {}
    Global.dlc_manager.all_dlc_data = {full_game = {is_default = true, verified = true, index = 0}, preorder = {is_default = false, verified = nil, index = 1}}
    l_27_0:_verify_dlcs()
  end
end

l_0_0.init = l_0_1
l_0_0 = X360DLCManager
l_0_1 = function(l_28_0)
  local found_dlc = {}
  local status = XboxLive:check_dlc_availability(0, 100, found_dlc)
  if not status then
    Application:error("XboxLive:check_dlc_availability failed", inspect(found_dlc))
    return 
  end
  print("[X360DLCManager:_verify_dlcs] found dlc:", inspect(found_dlc))
  for dlc_name,dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
    if dlc_data.is_default or found_dlc[dlc_data.index] then
      dlc_data.verified = true
      for (for control),dlc_name in (for generator) do
      end
      dlc_data.verified = false
    end
    if found_dlc.has_corrupt_data then
      l_28_0._has_corrupt_data = true
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._verify_dlcs = l_0_1
l_0_0 = X360DLCManager
l_0_1 = function(l_29_0)
  l_29_0:_verify_dlcs()
end

l_0_0.on_signin_complete = l_0_1
l_0_0 = WINDLCManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericDLCManager
  l_0_0 = l_0_0(l_0_1)
end
WINDLCManager = l_0_0
l_0_0 = DLCManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = Idstring
l_0_1 = l_0_1("WIN32")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = WINDLCManager
l_0_0 = WINDLCManager
l_0_1 = function(l_30_0)
  WINDLCManager.super.init(l_30_0)
  if not Global.dlc_manager then
    Global.dlc_manager = {}
    Global.dlc_manager.all_dlc_data = {full_game = {app_id = "218620", verified = true}, preorder = {app_id = "247450", no_install = true}, career_criminal_edition = {app_id = "218630", no_install = true}}
    l_30_0:_verify_dlcs()
  end
end

l_0_0.init = l_0_1
l_0_0 = WINDLCManager
l_0_1 = function(l_31_0)
  for dlc_name,dlc_data in pairs(Global.dlc_manager.all_dlc_data) do
    if not dlc_data.verified and dlc_data.no_install and Steam:is_product_owned(dlc_data.app_id) then
      dlc_data.verified = true
      for (for control),dlc_name in (for generator) do
        if Steam:is_product_installed(dlc_data.app_id) then
          dlc_data.verified = true
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._verify_dlcs = l_0_1

