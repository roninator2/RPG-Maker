# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Item Limited Uses                      ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Modify Item function                        ║    01 Sep 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Limit the amount of times an item can be used                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Place notetag in item notebox                                    ║
# ║     <limit use: x>                                                 ║
# ║  This is intented to be used with items that you only get one of.  ║
# ║  This will allow the item to only be usable x times throughout     ║
# ║  the course of a battle. Once it has been used X times, it         ║
# ║  is disabled until the start of the next battle.                   ║
# ║                                                                    ║
# ║  <discard_zero>                                                    ║
# ║  Tells the system to discard teh item when zero uses remaining     ║
# ║                                                                    ║
# ║  Script Calls                                                      ║
# ║    alter_item_limit_use(id, X)                                     ║
# ║      x equals the number of uses you are setting                   ║
# ║      used to recharge an item or lower number of uses              ║
# ║      you can event this with a script condition to check if the    ║
# ║      items uses remaining is greater than X, then lower to Y.      ║
# ║                                                                    ║
# ║    alter_item_limited(id, bool) # item.limited                     ║
# ║      turns limited use on or off (true/false)                      ║
# ║      useful if you need to change an item from limited use to      ║
# ║      permanently available                                         ║
# ║      true = limited use; false = permanent use                     ║
# ║                                                                    ║
# ║    alter_item_discard_zero(id, bool)                               ║
# ║     turns the items discard setting true or false for limited uses ║
# ║      similar to above but will not cause an item to be useable     ║
# ║      if 0 uses left                                                ║
# ║      true = remove item when 0 uses left                           ║
# ║      false = do not remove when 0 uses left                        ║
# ║                                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 01 Sep 2023 - Script finished                               ║
# ║ 1.01 - 14 Mar 2026 - Header rewritten - Added Import Value         ║
# ║ 1.01 - 18 Aug 2026 - Added Options and support for Instance Items  ║
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

module R2_ITEM_RESTRICT
    
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # - Limited Use Settings -
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # Some skills have limited uses per battle. These limited uses are reset
  # at the start and end of each battle and do not apply when used outside of
  # battle. There are no effects that can affect limited uses.
  #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  LIMIT_COLOUR  = 8          # Colour used from "Window" skin.
  LIMIT_SIZE    = 18         # Font size used
  LIMIT_TEXT    = "%s uses"  # Text used
  LIMIT_ICON    = 0          # Icon used. Set 0 to disable.
    
  LIMIT_USE = /<(?:LIMIT_USE|limit use):[ ](\d+)>/i
  DISCARD_ZERO = /<(?:DISCARD ZERO|discard zero)>/i
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_ilu] = 1.01          # Item Limited Uses

#==============================================================================
# ■ Icon
#==============================================================================

module Icon
 
  #--------------------------------------------------------------------------
  # self.itemlimit
  #--------------------------------------------------------------------------
  def self.itemlimit; return R2_ITEM_RESTRICT::LIMIT_ICON; end
    
end # Icon

#==============================================================================
# ■ DataManager
#==============================================================================

module DataManager
 
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_liu load_database; end
  def self.load_database
    load_database_liu
    load_notetags_liu
  end
 
  #--------------------------------------------------------------------------
  # new method: load_notetags_srs
  #--------------------------------------------------------------------------
  def self.load_notetags_liu
    for obj in $data_items
      next if obj.nil?
      obj.load_notetags_liu
    end
  end
 
end # DataManager

#==============================================================================
# ■ RPG::Item
#==============================================================================

class RPG::UsableItem
 
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :limit_use
  attr_accessor :limited
  attr_accessor :discard_zero
	
  #--------------------------------------------------------------------------
  # common cache: load_notetags_liu
  #--------------------------------------------------------------------------
  def load_notetags_liu
    @limit_use = 0
    @limited = false
		@discard_zero = false
    #---
    self.note.split(/[\r\n]+/).each { |line|
      case line
      #---
      when R2_ITEM_RESTRICT::LIMIT_USE
        @limit_use = $1.to_i
        @limited = true
      when R2_ITEM_RESTRICT::DISCARD_ZERO
        @discard_zero = true
			end
    }
  end
 
end

#==============================================================================
# ** Game_Interpreter
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * alter_limit_use(id, X)
  #--------------------------------------------------------------------------
  def alter_item_limit_use(id, i)
    $game_party.items.each do |item|
      if $imported["TH_InstanceItems"]
        if item.template_id == id
          item.limit_use = i
        end
      else
        if item.id == id
          item.limit_use = i
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * alter_item_limited(id, bool)
  #--------------------------------------------------------------------------
  def alter_item_limited(id, boo)
    $game_party.items.each do |item|
      if $imported["TH_InstanceItems"]
        if item.template_id == id
          item.limited = boo
        end
      else
        if item.id == id
          item.limited = boo
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * alter_discard_zero(id, bool)
  #--------------------------------------------------------------------------
  def alter_item_discard_zero(id, boo)
    $game_party.items.each do |item|
      if $imported["TH_InstanceItems"]
        if item.template_id == id
          item.discard_zero = boo
          $game_party.gain_item($data_items[item.id], -1) if (boo == true) && (item.limit_use == 0)
        end
      else
        if item.id == id
          item.discard_zero = boo
          $game_party.gain_item($data_items[id], -1) if (boo == true) && (item.limit_use == 0)
        end
      end
    end
  end
  
end

#==============================================================================
# ■ Game_BattlerBase
#==============================================================================

class Game_Battler
 
  #--------------------------------------------------------------------------
  # * Consume Items
  #--------------------------------------------------------------------------
  def consume_item(item)
    if item.limit_use >= 1
      item.limit_use -= 1
    end
    $game_party.consume_item(item) if item.limit_use == 0
  end
    
end # Game_BattlerBase

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Consume Items
  #    If the specified object is a consumable item, the number in investory
  #    will be reduced by 1.
  #--------------------------------------------------------------------------
  alias r2_party_consume_discard_zero consume_item
  def consume_item(item)
    r2_party_consume_discard_zero(item)
    lose_item(item, 1) if !item.consumable && item.discard_zero
  end
end

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
 
  def limit_colour; text_color(R2_ITEM_RESTRICT::LIMIT_COLOUR); end;
 
end # Window_Base

#==============================================================================
# ■ Window_SkillList
#==============================================================================

class Window_ItemList < Window_Selectable
 
  #--------------------------------------------------------------------------
  # alias method: draw_item
  #--------------------------------------------------------------------------
  alias window_itemlist_draw_item_liu draw_item
  def draw_item(index)
    if item_limit_restrict?(index)
      draw_item_restriction(index)
    else
      window_itemlist_draw_item_liu(index)
    end
  end
 
  #--------------------------------------------------------------------------
  # new method: limit_restricted?
  #--------------------------------------------------------------------------
  def item_limit_restrict?(index)
    item = @data[index]
    return true if item.limit_use >= 1
  end

  #--------------------------------------------------------------------------
  # new method: limit_restricted?
  #--------------------------------------------------------------------------
  def item_limited?(index)
    item = @data[index]
    return item.limited
  end

  #--------------------------------------------------------------------------
  # new method: draw_item
  #--------------------------------------------------------------------------
  def draw_item_restriction(index)
    item = @data[index]
    rect = item_rect(index)
    rect.width -= 4
    draw_item_name(item, rect.x, rect.y, enable?(item))
    draw_item_limited(rect, item)
  end
 
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    if item.limited
      return false if item.limit_use == 0
    end
    $game_party.usable?(item)
  end

  #--------------------------------------------------------------------------
  # new method: draw_skill_limited
  #--------------------------------------------------------------------------
  def draw_item_limited(rect, item)
    change_color(limit_colour, enable?(item))
    icon = Icon.itemlimit
    if icon > 0
      draw_icon(icon, rect.x + rect.width-24, rect.y, enable?(item))
      rect.width -= 24
    end
    contents.font.size = R2_ITEM_RESTRICT::LIMIT_SIZE
    text = sprintf(R2_ITEM_RESTRICT::LIMIT_TEXT, item.limit_use)
    draw_text(rect, text, 2)
    reset_font_settings
  end
 
end # Window_SkillList

#==============================================================================
# ■ Scene_ItemBase
#==============================================================================

class Scene_ItemBase < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    if item.limited
      return if item.limit_use == 0
    end
    play_se_for_item
    user.use_item(item)
    use_item_to_actors
    check_common_event
    check_gameover
    @actor_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #--------------------------------------------------------------------------
  def item_usable?
    if item.limited
      return false if item.limit_use == 0
    end
    user.usable?(item) && item_effects_valid?
  end
end

#==============================================================================
# 
# ▼ End of File
# 
#==============================================================================
