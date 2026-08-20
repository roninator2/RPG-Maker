# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Not Attack Self on Confusion           ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║ Remove subject from list of targets           ║    05 Jan 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║   Will remove subject from list of potential targets               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Add note tag to state <not_attack_self>                          ║
# ║   Subject will not attack self when inflicted with state           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Jan 2024 - Script finished                               ║
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
$imported[:r2_nasoc] = 1.01        # Not Attack Self on Confusion

class RPG::State < RPG::BaseItem

  attr_accessor :not_attack_self
  
  def not_attack_self
    init_not_attack_self if @not_attack_self.nil?
    return @not_attack_self
  end
  
  def init_not_attack_self
    @not_attack_self = @note =~ /<not_attack_self>/i ? true : false
  end
  
end

class Game_Action

  def confusion_target
    case subject.confusion_level
    when 1
      opponents_unit.random_target
    when 2
      if rand(2) == 0
        opponents_unit.random_target
      else
        if friends_unit.alive_members.size == 1 && (subject.states.any? { |st| st.not_attack_self })
          opponents_unit.random_target
        else
          sbj = friends_unit.random_target
          while sbj == subject && (subject.states.any? { |st| st.not_attack_self })
            sbj = friends_unit.random_target
          end
          return sbj
        end
      end
    else
      if friends_unit.alive_members.size == 1 && (subject.states.any? { |st| st.not_attack_self })
        opponents_unit.random_target
      else
        sbj = friends_unit.random_target
        while sbj == subject && (subject.states.any? { |st| st.not_attack_self })
          sbj = friends_unit.random_target
        end
        return sbj
      end
    end
  end
end
