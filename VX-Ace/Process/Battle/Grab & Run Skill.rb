# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Grab & Run Skill                       ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Scene_BattleManager                         ╠════════════════════╣
# ║   Process run away skill                      ║    01 Nov 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Escape and take gold & exp                                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Specify a skill that will be your escape skill                   ║
# ║   Set it to run a common event                                     ║
# ║                                                                    ║
# ║   Set skill to scope none and damage formula to this               ║
# ║     $game_variables[54] = a.level; 0                               ║
# ║   Change formula however you want                                  ║
# ║                                                                    ║
# ║   Put the following code into a script command in CE               ║
# ║   escape_successfull = ($game_variables[54] >= rand(100))          ║
# ║   if escape_successfull                                            ║
# ║     BattleManager.process_grabandrun                               ║
# ║   else                                                             ║
# ║     $game_message.add("Failed to run away")                        ║
# ║   end                                                              ║
# ║                                                                    ║
# ║   The variable used will determine the chance of escape            ║
# ║                                                                    ║
# ║   Set the variable to what value you want 0 - 100                  ║
# ║                                                                    ║
# ║   If successful the party will run away                            ║
# ║   and collect exp and gold for any enemies killed.                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 01 Nov 2020 - Script finished                               ║
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

module Vocab
  Grabandrun         = "%s took what they could get!"
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_grs] = 1.01          # Grab & Run Skill

module BattleManager
  
  def self.process_grabandrun
    play_battle_end_me
    replay_bgm_and_bgs
    $game_message.add(sprintf(Vocab::Grabandrun, $game_party.name))
    display_exp
    gain_gold
    gain_drop_items
    gain_exp
    SceneManager.return
    battle_end(0)
    return true
  end
end
