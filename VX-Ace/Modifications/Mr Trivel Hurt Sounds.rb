# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mr Trivel Hurt Sounds Mod              ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║  Play Hurt Sounds                             ╠════════════════════╣
# ║  Rewrite of Mr Trivel script                  ║    18 Jul 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allows to specify sounds                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Added on multiple sounds for actors and enemies.                 ║
# ║   Randomized sound played                                          ║
# ║                                                                    ║
# ║  Add <Hurt: SE_name, volume, pitch> to your                        ║
# ║   Actor or Enemy note box.                                         ║
# ║  Example: <Hurt: Bite, 100, 100>                                   ║
# ║                                                                    ║
# ║  Multiple note tags can be used                                    ║
# ║                                                                    ║
# ║    Death Sound                                                     ║
# ║  Add <Dead: SE_name, volume, pitch> to your                        ║
# ║   Actor or Enemy note box.                                         ║
# ║  Example: <Dead: Bite, 100, 100>                                   ║
# ║                                                                    ║
# ║  Multiple note tags can be used                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Jul 2022 - Initial publish                               ║
# ║ 1.01 - 14 Mar 2026 - Added Import Value                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Mr. Trivel                                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Hurt_Sound_Mod
 Hurt_Regex = /<Hurt:[ ]*(\w*),[ ]*(\d*),[ ]*(\d*)>/i
 Dead_Regex = /<Dead:[ ]*(\w*),[ ]*(\d*),[ ]*(\d*)>/i
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_mthsm] = 1.01        # Mr Trivel Hurt Sounds Mod

class Game_Battler < Game_BattlerBase
  alias :mrts_hurt_execute_damage :execute_damage
  def execute_damage(user)
    mrts_hurt_execute_damage(user)
    return unless (@hurt_sound.size > 0) && (@result.hp_damage > 0)
    i = rand(@hurt_sound.size)
    Audio.se_play(@hurt_sound[i][0], @hurt_sound[i][1].to_i, @hurt_sound[i][2].to_i)
  end
end
class Game_Actor < Game_Battler
  alias :mrts_hurt_setup :setup
  def setup(actor_id)
    mrts_hurt_setup(actor_id)
    @hurt_sound = []
    @dead_sound = []
    results = actor.note.scan(R2_Hurt_Sound_Mod::Hurt_Regex)
    results.each do |res|
      @hurt_sound.push(res)
    end
    dresults = actor.note.scan(R2_Hurt_Sound_Mod::Dead_Regex)
    dresults.each do |res|
      @dead_sound.push(res)
    end
  end
end
class Game_Enemy < Game_Battler
  alias :mrts_hurt_initialize :initialize
  def initialize(index, enemy_id)
    mrts_hurt_initialize(index, enemy_id)
    @hurt_sound = []
    @dead_sound = []
    results = enemy.note.scan(R2_Hurt_Sound_Mod::Hurt_Regex)
    results.each do |res|
      @hurt_sound.push(res)
    end
    dresults = enemy.note.scan(R2_Hurt_Sound_Mod::Dead_Regex)
    dresults.each do |res|
      @dead_sound.push(res)
    end
  end
end
