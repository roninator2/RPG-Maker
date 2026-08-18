# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Fix Quote Scan for Bestiary            ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Provide actor gold trade                    ║    17 Sep 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Venka Bestiary                                           ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Correct failed scan for quotes                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Restructure quotes on enemies to be like this:                   ║
# ║   <quote: 5>                                                       ║
# ║     whatever text and as many lines as you want                    ║
# ║   <\quote>                                                         ║
# ║    5 is the actor id                                               ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Sep 2022 - Script finished                               ║
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

module Venka::Notetag
  Bestiary_Quotes_on = /<quote:\s*(\d+)>/i
  Bestiary_Quotes_off = /<\\quote>/i
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_vbfqs] = 1.01        # Venka Bestiary Fix Quote Scan


#==============================================================================
# ■ RPG::Enemy
#==============================================================================
class RPG::Enemy
  #----------------------------------------------------------------------------
  # ♦ Public Instance Variables
  #----------------------------------------------------------------------------
  attr_accessor :actor_quotes
  #----------------------------------------------------------------------------
  # ○ new method: load_actor_talk
  #----------------------------------------------------------------------------
  def load_actor_talk
    @quotes = false
    @actor_quotes = []
    @act_id = nil
    self.note.split(/[\r\n]+/).each do |line|
      case line
      when Venka::Notetag::Bestiary_Quotes_on
        @quotes = true
        @act_id = $1.to_i
      when Venka::Notetag::Bestiary_Quotes_off
        @quotes = false
        @act_id = nil
      else
        if @quotes == true
          @actor_quotes[@act_id] ||= []
          @actor_quotes[@act_id] << line
        end
      end
    end
  end
end
