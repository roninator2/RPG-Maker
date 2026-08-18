# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Actor Swap For Conversation            ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Swap actor positions                        ║    14 Apr 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allows to change actors to make a specific actor first       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set the variable below for this script                           ║
# ║                                                                    ║
# ║   Use script call to swap actors                                   ║
# ║      swap_actor_convo(X)                                           ║
# ║        X = actor id to be at the front of the party                ║
# ║   Then use swap_actor_convo($game_variables[X])                    ║
# ║        X = the variable number used below                          ║
# ║     to change the actor back to original position                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Apr 2022 - Script finished                               ║
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

module R2_Swap_Actor_Conversation
  Variable = 11
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_asfc] = 1.01         # Actor Swap For Conversation

class Game_Interpreter
  def swap_actor_convo(aid)
    swap = 0
    for i in 0..$game_party.members.size - 1
      swap = i if $game_party.members[i].id == aid
    end
    return if swap == 0
    $game_variables[R2_Swap_Actor_Conversation::Variable] = $game_party.members[0].id
    $game_party.swap_order(0, swap)
  end
end

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# SYF [Soulpour Yanfly Fix] - Party System Swap Fix
# Author: Soulpour777
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Swap Order Fix – If you want to use the script call $game_party.swap_order(n,n)
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # Alias Listings
  #--------------------------------------------------------------------------
  alias :syf_yanfly_party_swap :swap_order
 
  #--------------------------------------------------------------------------
  # Swap Order
  #--------------------------------------------------------------------------
  def swap_order(index1, index2)
    id1, id2 = @actors[index1], @actors[index2]
    pos1 = @battle_members_array.index(id1)
    pos2 = @battle_members_array.index(id2)
    @battle_members_array[pos1] = id2 if pos1
    @battle_members_array[pos2] = id1 if pos2
    syf_yanfly_party_swap(index1, index2)
  end
 
end
