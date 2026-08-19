# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Update Steps - Move Route              ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust step count                           ║    07 Jan 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Correct step count not applying in move routes               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 07 Jan 2022 - Script finished                               ║
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

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_usmr] = 1.01         # Update Steps - Move Route

class Game_Character < Game_CharacterBase
  alias r2_move_route_update_step   process_move_command
  def process_move_command(command)
    r2_move_route_update_step(command)
    case command.code
    when ROUTE_MOVE_DOWN;         $game_party.increase_steps
    when ROUTE_MOVE_LEFT;         $game_party.increase_steps
    when ROUTE_MOVE_RIGHT;        $game_party.increase_steps
    when ROUTE_MOVE_UP;           $game_party.increase_steps
    when ROUTE_MOVE_LOWER_L;      $game_party.increase_steps
    when ROUTE_MOVE_LOWER_R;      $game_party.increase_steps
    when ROUTE_MOVE_UPPER_L;      $game_party.increase_steps
    when ROUTE_MOVE_UPPER_R;      $game_party.increase_steps
    when ROUTE_MOVE_RANDOM;       $game_party.increase_steps
    when ROUTE_MOVE_TOWARD;       $game_party.increase_steps
    when ROUTE_MOVE_AWAY;         $game_party.increase_steps
    when ROUTE_MOVE_FORWARD;      $game_party.increase_steps
    when ROUTE_MOVE_BACKWARD;     $game_party.increase_steps
    end
  end
end
