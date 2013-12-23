-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\missionassetsmanager.luac 

if not MissionAssetsManager then
  MissionAssetsManager = class()
end
MissionAssetsManager.ALLOW_CLIENTS_UNLOCK = false
MissionAssetsManager.init = function(l_1_0)
  l_1_0:_setup()
end

MissionAssetsManager._setup = function(l_2_0)
  l_2_0._asset_textures_in_loading = {}
  l_2_0._asset_textures_loaded = {}
  local assets = {}
  Global.asset_manager = {}
  Global.asset_manager.assets = assets
  l_2_0._global = Global.asset_manager
  l_2_0._tweak_data = tweak_data.assets
  l_2_0._money_spent = 0
  l_2_0._triggers = {}
  l_2_0:_setup_mission_assets()
end

MissionAssetsManager._setup_mission_assets = function(l_3_0)
  if not Network:is_server() then
    local is_host = Global.game_settings.single_player
  end
  do
    local current_stage = managers.job:current_level_id()
    if not current_stage or not is_host then
      return 
    end
    for id,asset in pairs(l_3_0._tweak_data) do
      if asset.stages and (asset.stages == "all" or table.contains(asset.stages, current_stage)) then
        local requirements = {}
        requirements.saved_job_lock = nil
        requirements.job_lock = nil
        requirements.money_lock = nil
        requirements.upgrade_lock = nil
        requirements.achievment_lock = nil
        requirements.risk_lock = nil
        local can_unlock = false
        local require_to_unlock = asset.require_to_unlock or "all"
        if asset.money_lock then
          requirements.money_lock = false
          can_unlock = true
        end
        if not managers.mission:get_saved_job_value(asset.saved_job_lock) then
          requirements.saved_job_lock = not asset.saved_job_lock or false
        end
        if not requirements.saved_job_lock or not can_unlock then
          can_unlock = false
        end
        if not managers.mission:get_job_value(asset.job_lock) then
          requirements.job_lock = not asset.job_lock or false
        end
        if not requirements.job_lock or not can_unlock then
          can_unlock = false
        end
        if asset.upgrade_lock then
          requirements.upgrade_lock = managers.player:has_category_upgrade(asset.upgrade_lock.category, asset.upgrade_lock.upgrade)
          if not requirements.upgrade_lock or not can_unlock then
            can_unlock = false
          end
        end
        if asset.achievment_lock then
          if managers.achievment:exists(asset.achievment_lock) then
            requirements.achievment_lock = managers.achievment:get_info(asset.achievment_lock).awarded
          end
          if not requirements.achievment_lock or not can_unlock then
            can_unlock = false
          end
        end
        if current_stage == "safehouse" or managers.job:current_difficulty_stars() ~= asset.risk_lock then
          requirements.risk_lock = not asset.risk_lock
          if current_stage == "safehouse" or not requirements.risk_lock or not can_unlock then
            can_unlock = false
          end
          local needs_any = Idstring(require_to_unlock) == Idstring("any")
          local unlocked = true
          if needs_any and asset.money_lock then
            can_unlock = true
          end
          for id,exist in pairs(requirements) do
            if exist and needs_any then
              unlocked = true
              do return end
              for (for control),id in (for generator) do
                unlocked = false
            else
              if not needs_any then
                end
              end
              if not unlocked and not can_unlock then
                local show = asset.visible_if_locked
              end
              table.insert(l_3_0._global.assets, {id = id, unlocked = unlocked, show = show, can_unlock = can_unlock, no_mystery = asset.no_mystery})
            end
          end
          table.sort(l_3_0._global.assets, function(l_1_0, l_1_1)
          if l_1_0.show ~= l_1_1.show then
            return l_1_0.show
          else
            if l_1_0.unlocked ~= l_1_1.unlocked then
              return l_1_0.unlocked
            else
              if l_1_0.can_unlock ~= l_1_1.can_unlock then
                return l_1_0.can_unlock
              end
            end
          end
          if l_1_0.no_mystery ~= l_1_1.no_mystery then
            return l_1_0.no_mystery
          end
          if self._tweak_data[l_1_0.id].money_lock >= self._tweak_data[l_1_1.id].money_lock then
            return not self._tweak_data[l_1_0.id].money_lock or not self._tweak_data[l_1_1.id].money_lock
          end
          do return end
          if self._tweak_data[l_1_0.id].money_lock then
            return true
          else
            if self._tweak_data[l_1_1.id].money_lock then
              return false
            else
              return l_1_0.id < l_1_1.id
            end
          end
            end)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MissionAssetsManager.init_finalize = function(l_4_0)
  if not Network:is_server() then
    local is_server = Global.game_settings.single_player
  end
  local current_stage = managers.job:current_level_id()
  if not current_stage or not is_server then
    return 
  end
  l_4_0:create_asset_textures()
  l_4_0:_check_triggers("asset")
end

MissionAssetsManager.clear = function(l_5_0)
  Global.asset_manager = nil
  l_5_0._money_spent = 0
end

MissionAssetsManager.reset = function(l_6_0)
  Global.asset_manager = nil
  l_6_0:_setup()
  l_6_0:_check_triggers("asset")
end

MissionAssetsManager.on_simulation_ended = function(l_7_0)
  l_7_0:reset()
end

MissionAssetsManager.add_trigger = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4)
  if not l_8_0._triggers[l_8_2] then
    l_8_0._triggers[l_8_2] = {}
  end
  l_8_0._triggers[l_8_2][l_8_1] = {id = l_8_3, callback = l_8_4}
end

MissionAssetsManager._check_triggers = function(l_9_0, l_9_1)
  if not l_9_0._triggers[l_9_1] then
    return 
  end
  for id,cb_data in pairs(l_9_0._triggers[l_9_1]) do
    local asset = l_9_0:_get_asset_by_id(cb_data.id)
    if l_9_1 ~= "asset" or asset and asset.unlocked and not asset.is_triggered then
      cb_data.callback()
      if asset then
        asset.is_triggered = true
      end
    end
  end
end

MissionAssetsManager.unlock_asset = function(l_10_0, l_10_1)
  if Idstring(l_10_1) == Idstring("none") then
    return 
  end
  if Network:is_server() and not l_10_0:get_asset_triggered_by_id(l_10_1) then
    l_10_0._money_spent = l_10_0._money_spent + managers.money:on_buy_mission_asset(l_10_1)
    l_10_0:server_unlock_asset(l_10_1)
  elseif l_10_0.ALLOW_CLIENTS_UNLOCK and not l_10_0:get_asset_unlocked_by_id(l_10_1) then
    l_10_0._money_spent = l_10_0._money_spent + managers.money:on_buy_mission_asset(l_10_1)
    managers.network:session():send_to_host("server_unlock_asset", l_10_1)
  end
  if WalletGuiObject then
    WalletGuiObject.refresh()
  end
end

MissionAssetsManager.get_money_spent = function(l_11_0)
  return l_11_0._money_spent
end

MissionAssetsManager.server_unlock_asset = function(l_12_0, l_12_1)
  managers.network:session():send_to_peers_synched("sync_unlock_asset", l_12_1)
  l_12_0:sync_unlock_asset(l_12_1)
  l_12_0:_check_triggers("asset")
end

MissionAssetsManager.sync_unlock_asset = function(l_13_0, l_13_1)
  local asset = l_13_0:_get_asset_by_id(l_13_1)
  if not asset then
    Application:error("sync_set_asset_enabled: No asset with id:", l_13_1)
    return 
  end
  if asset.unlocked then
    Application:error("sync_set_asset_enabled: Asset already unlocked:", l_13_1)
    return 
  end
  asset.unlocked = true
  managers.menu_component:unlock_asset_mission_briefing_gui(l_13_1)
end

MissionAssetsManager.get_every_asset_ids = function(l_14_0)
  local asset_ids = {}
  for id,asset in pairs(tweak_data.assets) do
    table.insert(asset_ids, id)
  end
  return asset_ids
end

MissionAssetsManager.get_all_asset_ids = function(l_15_0, l_15_1)
  local asset_ids = {}
  for _,asset in ipairs(l_15_0._global.assets) do
    if not l_15_1 or asset.show then
      table.insert(asset_ids, asset.id)
    end
  end
  return asset_ids
end

MissionAssetsManager.get_default_asset_id = function(l_16_0)
  return "none"
end

MissionAssetsManager._get_asset_by_id = function(l_17_0, l_17_1)
  for _,asset in pairs(l_17_0._global.assets) do
    if asset.id == l_17_1 then
      return asset
    end
  end
end

MissionAssetsManager.get_asset_can_unlock_by_id = function(l_18_0, l_18_1)
  local asset = l_18_0:_get_asset_by_id(l_18_1)
  return asset and asset.can_unlock or false
end

MissionAssetsManager.get_asset_visible_by_id = function(l_19_0, l_19_1)
  local asset = l_19_0:_get_asset_by_id(l_19_1)
  return asset and asset.show or false
end

MissionAssetsManager.get_asset_unlocked_by_id = function(l_20_0, l_20_1)
  local asset = l_20_0:_get_asset_by_id(l_20_1)
  return asset and asset.unlocked or false
end

MissionAssetsManager.get_asset_triggered_by_id = function(l_21_0, l_21_1)
  local asset = l_21_0:_get_asset_by_id(l_21_1)
  return asset and asset.is_triggered or false
end

MissionAssetsManager.get_asset_no_mystery_by_id = function(l_22_0, l_22_1)
  local asset = l_22_0:_get_asset_by_id(l_22_1)
  return asset and asset.no_mystery or false
end

MissionAssetsManager.get_asset_tweak_data_by_id = function(l_23_0, l_23_1)
  return l_23_0._tweak_data[l_23_1]
end

MissionAssetsManager.get_asset_unlock_text_by_id = function(l_24_0, l_24_1)
  local asset_tweak_data = l_24_0._tweak_data[l_24_1]
  local prefix = "menu_asset_lock_"
  local text = "unable_to_unlock"
  if asset_tweak_data.no_mystery then
    if asset_tweak_data.upgrade_lock then
      text = asset_tweak_data.upgrade_lock.upgrade
    elseif asset_tweak_data.achievment_lock then
      text = "achv_" .. asset_tweak_data.achievment_lock
    elseif asset_tweak_data.job_lock then
      text = "jval_" .. asset_tweak_data.job_lock
    elseif asset_tweak_data.saved_job_lock then
      text = "sjval_" .. asset_tweak_data.saved_job_lock
    end
  end
  return prefix .. text
end

MissionAssetsManager.sync_save = function(l_25_0, l_25_1)
  l_25_1.MissionAssetsManager = l_25_0._global
end

MissionAssetsManager.sync_load = function(l_26_0, l_26_1)
  l_26_0._global = l_26_1.MissionAssetsManager
  l_26_0:create_asset_textures()
end

MissionAssetsManager.clear_asset_textures = function(l_27_0)
  if l_27_0._asset_textures_loaded then
    for texture_key,texture in pairs(l_27_0._asset_textures_loaded) do
      TextureCache:unretrieve(texture)
    end
  end
  if l_27_0._asset_textures_in_loading then
    for texture_key,texture_data in pairs(l_27_0._asset_textures_in_loading) do
      TextureCache:unretrieve(Idstring(texture_data[2]))
    end
  end
  l_27_0._asset_textures_in_loading = {}
  l_27_0._asset_textures_loaded = {}
end

MissionAssetsManager.create_asset_textures = function(l_28_0)
  if managers.platform:presence() == "Playing" then
    Application:debug("[MissionAssetsManager] create_asset_textures(): ", managers.platform:presence())
    return 
  end
  local all_visible_assets = l_28_0:get_all_asset_ids(true)
  local texture_loaded_clbk = (callback(l_28_0, l_28_0, "texture_loaded_clbk"))
  local texture = nil
  for _,asset_id in ipairs(all_visible_assets) do
    texture = l_28_0._tweak_data[asset_id].texture
    l_28_0._asset_textures_in_loading[Idstring(texture):key()] = {asset_id, texture}
    TextureCache:request(texture, "NORMAL", texture_loaded_clbk)
  end
end

MissionAssetsManager.get_asset_texture = function(l_29_0, l_29_1)
  local texture = l_29_0._asset_textures_loaded[l_29_1]
  if not texture then
    Application:error("[MissionAssetsManager] get_asset_texture(): Asset texture not loaded!", l_29_1)
  end
  return texture
end

MissionAssetsManager.texture_loaded_clbk = function(l_30_0, l_30_1)
  if not l_30_0._asset_textures_in_loading[l_30_1:key()] then
    TextureCache:unretrieve(l_30_1)
    return 
  end
  local asset_texture_data = l_30_0._asset_textures_in_loading[l_30_1:key()]
  local asset_id = asset_texture_data[1]
  local texture_path = asset_texture_data[2]
  if l_30_0._asset_textures_loaded[asset_id] then
    Application:debug("[MissionAssetsManager] texture_loaded_clbk() Asset already got texture loaded.")
    TextureCache:unretrieve(l_30_1)
    return 
  end
  l_30_0._asset_textures_loaded[asset_id] = l_30_1
  l_30_0._asset_textures_in_loading[l_30_1:key()] = nil
  Application:debug("[MissionAssetsManager] Texture loaded for asset", asset_id)
  l_30_0:check_all_textures_loaded()
end

MissionAssetsManager.check_all_textures_loaded = function(l_31_0)
  if l_31_0:is_all_textures_loaded() then
    Application:debug("[MissionAssetsManager] Creating mission assets")
    managers.menu_component:create_asset_mission_briefing_gui()
  end
end

MissionAssetsManager.is_all_textures_loaded = function(l_32_0)
  if not l_32_0._asset_textures_in_loading or not l_32_0._asset_textures_loaded then
    return false
  end
  return table.size(l_32_0._asset_textures_in_loading) == 0 and table.size(l_32_0._asset_textures_loaded) ~= 0
end


