# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Rotate Lock on State                   ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Block rotation when inflicted               ╠════════════════════╣
# ║   with a specific state on actor              ║    06 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires:                                                          ║
# ║        TsukiHime's Formation Rotation                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Lock rotate when state applied                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Specify the states to block rotation function                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Sep 2022 - Script finished                               ║
# ║ 1.01 - 06 Sep 2022 - Fixed Code                                    ║
# ║ 1.02 - 14 Mar 2026 - Added Import Value                            ║
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

module R2_Rotate_Formation_Blocked_States
  States = [3,4]
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_rlosa] = 1.02        # Rotate Lock on State

class Game_Party < Game_Unit
  
  def rotate_formation_left
    j = [@actors.size, max_battle_members].min
    loop do
      actor = $game_actors[@actors[0]]
      clean = true
      actor.states.each do |st|
        clean = false if R2_Rotate_Formation_Blocked_States::States.include?(st.id)
      end
      if clean == true
        @actors = @actors[0...j].rotate.concat((@actors[j..-1] || []))
        break
      end
      break if clean == false
    end
    $game_player.refresh
  end
  
  def rotate_formation_right
    j = [@actors.size, max_battle_members].min
    loop do
      actor = $game_actors[@actors[0]]
      clean = true
      actor.states.each do |st|
        clean = false if R2_Rotate_Formation_Blocked_States::States.include?(st.id)
      end
      if clean == true
        @actors = @actors[0...j].rotate(-1).concat((@actors[j..-1] || []))
        break
      end
      break if clean == false
    end
    $game_player.refresh
  end
end
