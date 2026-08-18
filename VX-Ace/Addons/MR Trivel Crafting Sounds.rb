# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mr. Trivel Crafting Sounds             ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Play a specific sound for items               ║    04 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Mr. Trivel Crafting Simple                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      Play a sound when crafting                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   For each recipe you want to have a sound add the                 ║
# ║   recipe below with the sound information.                         ║
# ║                                                                    ║
# ║   :sound is the sound file name                                    ║
# ║                                                                    ║
# ║   :snd_type is for specifying BGM, BGS, ME or SE                   ║
# ║                                                                    ║
# ║   If the file is not found you may get an error                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 04 Sep 2022 - Initial publish                               ║
# ║ 1.01 - 14 Mar 2026 - Added Import Value                            ║
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

module MrTS
  module Crafting
    RECIPE_SOUND = {
      0 => {
          :sound => "Laser",
          :snd_type => "SE",
          },
      1 => {
          :sound => "Knock",
          :snd_type => "SE",
          },
      }
    end
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_mtcsn] = 1.01        # Mr. Trivel Crafting Sounds

class MrTS_Requirements_Window < Window_Base
  alias r2_craft_sound_for_item    craft_item
  def craft_item
    r2_craft_sound_for_item
    if !MrTS::Crafting::RECIPE_SOUND[@recipe].nil?
      snd = MrTS::Crafting::RECIPE_SOUND[@recipe][:sound]
      type ||= MrTS::Crafting::RECIPE_SOUND[@recipe][:snd_type]
    end
    return if snd.nil?
    case type
    when "BGM"
      music = RPG::BGM.new(snd, 100, 100)
    when "BGS"
      music = RPG::BGS.new(snd, 100, 100)
    when "ME"
      music = RPG::ME.new(snd, 100, 100)
    when "SE"
      music = RPG::SE.new(snd, 100, 100)
    end
    music.play
  end
end
