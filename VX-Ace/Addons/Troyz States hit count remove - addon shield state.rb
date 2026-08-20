# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Shield State Count Hit fix             ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║      Modify hit damage                        ║    05 Jan 2021     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: TroyZ - States Hit Count Removal                         ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allow hit to not do damage when successful                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Original script allowed a state to be removed when hit,          ║
# ║   but if the state is a shield to block all damage                 ║
# ║   then the player still took damage, this fixes it.                ║
# ║                                                                    ║
# ║   Add Shield States below:                                         ║
# ║   Each state number added will protect from type damage            ║
# ║   Can be a single number [28], or multiple [4, 18, 28]             ║
# ║                                                                    ║
# ║   Each one has it's specific hit type                              ║
# ║   Shield_State = Physical hit type                                 ║
# ║   Mind_Shield = Magical hit type                                   ║
# ║   Certain_Shield = Certain hit type                                ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Jan 2021 - Initial publish                               ║
# ║ 1.01 - 05 Jan 2021 - Seperated damage to hit type                  ║
# ║ 1.02 - 06 Jan 2021 - Created percentage damage option              ║
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

module R2_State_Shield_Remove_On_Hit
	# states that give 100% protection from damage
  Physical_Shield = [1, 28] 
  # Physical hit type protection 
  Mind_Shield = [13, 29] 
  # Magic hit type protection 
  Certain_Shield = [4, 30] 
  # Certain hit type protection
	
	# states that give percentage protection
  Half_Physical = [2, 33] 
  # Physical hit type protection 
  Half_Mind = [14, 32] 
  # Magic hit type protection 
  Half_Certain = [5, 31] 
  # Certain hit type protection
	
	# Percentage values for half states 50 = 50%
  Physical_Rate = 50 
  # Physical hit type protection percentage value
  Mind_Rate = 70 
  # Magic hit type protection percentage value
  Certain_Rate = 30 
  # Certain hit type protection percentage value
	
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Game_Battler < Game_BattlerBase
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    R2_State_Shield_Remove_On_Hit::Half_Physical.each { |st|
      if item.physical? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Physical_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Half_Certain.each { |st|
      if item.certain? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Certain_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Half_Mind.each { |st|
      if item.magical? && @states.include?(st)
        value = ((value * R2_State_Shield_Remove_On_Hit::Mind_Rate) / 100).to_i
      end
    }
    R2_State_Shield_Remove_On_Hit::Physical_Shield.each { |st|
      if item.physical? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    R2_State_Shield_Remove_On_Hit::Certain_Shield.each { |st|
      if item.certain? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    R2_State_Shield_Remove_On_Hit::Mind_Shield.each { |st|
      if item.magical? && @states.include?(st)
        value = 0
        update_states_hit_count
        remove_states_by_hit_count
      end
    }
    @result.make_damage(value.to_i, item)
  end
end
