# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Vehicle Battles                        ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Do battles in Land Vehicle                  ║    21 Jul 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Roninator2 - Land Vehicle                                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Gives Exp to the party not the vehicle                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 21 Jul 2023 - Script finished                               ║
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
$imported[:r2_vhbt] = 1.01         # Vehicle Battles

#==============================================================================
# ** BattleManager
#==============================================================================

module BattleManager
  #--------------------------------------------------------------------------
  # * EXP Acquisition and Level Up Display
  #--------------------------------------------------------------------------
  def self.gain_exp
    if $game_player.in_land?
      $game_party.vehicle_party.each do |actor|
        actor.gain_vehicle_exp($game_troop.exp_total)
      end
    else
      $game_party.all_members.each do |actor|
        actor.gain_exp($game_troop.exp_total)
      end
    end
    wait_for_message
  end
end # BattleManager

#==============================================================================
# ** Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  def gain_vehicle_exp(exp)
    change_exp(self.exp + (exp * vehicle_exp_rate).to_i, false)
  end
  #--------------------------------------------------------------------------
  # * Calculate Final EXP Rate
  #--------------------------------------------------------------------------
  def vehicle_exp_rate
    exr * (vehicle_battle_member? ? 1 : reserve_members_exp_rate)
  end
  #--------------------------------------------------------------------------
  # * Determine Battle Members
  #--------------------------------------------------------------------------
  def vehicle_battle_member?
    $game_party.vehicle_members.include?(self)
  end
end # Game_Actor

#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Get All Members
  #--------------------------------------------------------------------------
  def driving_members
    @vehicle_party.collect {|act| $game_actors[act.id] }
  end
  #--------------------------------------------------------------------------
  # * Get Battle Members
  #--------------------------------------------------------------------------
  def vehicle_members
    driving_members[0, max_battle_members].select {|actor| actor.exist? }
  end
end # Game_Party
