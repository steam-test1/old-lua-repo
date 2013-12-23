-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\copbase.luac 

local ids_lod = Idstring("lod")
local ids_lod1 = Idstring("lod1")
local ids_ik_aim = Idstring("ik_aim")
if not CopBase then
  CopBase = class(UnitBase)
end
CopBase._anim_lods = {{2, 500, 100, 5000}, {2, 0, 100, 1}, {3, 0, 100, 1}}
local material_translation_map = {}
 -- DECOMPILER ERROR: No list found. Setlist fails

local payday2_characters_map = {"civ_female_bank_1", "civ_female_bank_manager_1", "civ_female_bikini_1", "civ_female_bikini_2", "civ_female_casual_1", "civ_female_casual_2", "civ_female_casual_3", "civ_female_casual_4", "civ_female_casual_5", "civ_female_crackwhore_1", "civ_female_hostess_apron_1", "civ_female_hostess_jacket_1", "civ_female_hostess_shirt_1", "civ_female_party_1", "civ_female_party_2", "civ_female_party_3", "civ_female_party_4", "civ_female_wife_trophy_1", "civ_female_wife_trophy_2", "civ_male_bank_1", "civ_male_bank_2", "civ_male_bank_manager_1", "civ_male_business_1", "civ_male_business_2", "civ_male_casual_1", "civ_male_casual_2", "civ_male_casual_3", "civ_male_casual_4", "civ_male_casual_5", "civ_male_casual_6", "civ_male_casual_7", "civ_male_casual_8", "civ_male_casual_9", "civ_male_dj_1", "civ_male_italian_robe_1", "civ_male_janitor_1", "civ_male_meth_cook_1", "civ_male_paramedic_1", "civ_male_party_1", "civ_male_party_2", "civ_male_party_3", "civ_male_scientist_1", "civ_male_trucker_1", "civ_male_worker_docks_1", "civ_male_worker_docks_2", "civ_male_worker_docks_3", "ene_biker_1", "ene_biker_2", "ene_biker_3", "ene_biker_4"}
 -- DECOMPILER ERROR: Overwrote pending register.

local path_string = "ene_bulldozer_1"
 -- DECOMPILER ERROR: Overwrote pending register.

do
  local character_path = "ene_cop_1"
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  for _,character in "ene_cop_2"("ene_cop_3") do
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

  end
end
local ids_materials = Idstring("material")
 -- DECOMPILER ERROR: Overwrote pending register.

local ids_contour_color = Idstring(character_path)
do
  local ids_contour_opacity = Idstring("contour_opacity")
end
 -- Warning: undefined locals caused missing assignments!

