# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Falco MMORPG Alchemy sounds            ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script Function                             ║    05 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Falco MMORPG Alchemy                                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Play different sounds when crafting different items          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place notetag on the crafted item, not the recipe item           ║
# ║         <mix_potion>                                               ║
# ║   Add more as you need                                             ║
# ║         <mix_other>                                                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Feb 2022 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Falco_MMORPG_Alchemy_Sound
	DEFAULT = ""
	POTION = "Blind"
	POT_REGEX = /<mix_potion>/i
	MATERIAL = "Bite"
	MAT_REGEX = /<mix_other>/i
  # add more if differnt items
end

class Scene_Alchemy < Scene_MenuBase
  def update_start
    default_snd = R2_Falco_MMORPG_Alchemy_Sound::DEFAULT
		craftquery = @recipes.item[1]
		craftid = @recipes.item[2]
		case craftquery
		when "Item"
		item = $data_items[craftid]
		when "Armor"
		item = $data_armours[craftid]
		when "Weapon"
		item = $data_weapons[craftid]
    end
		
# ╔════════════════════════════════════════════════════════════════════╗
# ║           Add more entries if you add more note tag types          ║
# ╚════════════════════════════════════════════════════════════════════╝
    # find which sound file to use. Does the tag exist?
    potion = item.note =~ R2_Falco_MMORPG_Alchemy_Sound::POT_REGEX ? true : false
    material = item.note =~ R2_Falco_MMORPG_Alchemy_Sound::MAT_REGEX ? true : false
		# add more for more sounds

# ╔════════════════════════════════════════════════════════════════════╗
# ║          Follow the pattern to add more entries                    ║
# ╚════════════════════════════════════════════════════════════════════╝
		# Set sound file name
		snd = default_snd
		snd = R2_Falco_MMORPG_Alchemy_Sound::POTION if potion == true
		snd = R2_Falco_MMORPG_Alchemy_Sound::MATERIAL if material == true
		# add more for if tag is true
		
    RPG::SE.new(snd, 80, 100).play
    @ngrewindow.meter = 1
  end
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
