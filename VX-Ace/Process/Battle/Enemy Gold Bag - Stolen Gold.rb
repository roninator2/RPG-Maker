# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Enemy Gold Stolen Gold                 ║  Version: 1.07     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Allows the enemy to store gold and items    ╠════════════════════╣
# ║   when stolen from the player                 ║    14 Aug 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Enemy holds gold and items stolen until killed.              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Put note tag on enemy skill note box in order to                 ║
# ║   allow the enemy to steal gold from the player                    ║
# ║     <gold steal>                                                   ║
# ║   allow the enemy to steal items from the player                   ║
# ║     <item steal>  - Will only steal from inventory, not equips     ║
# ║                                                                    ║
# ║   Every enemy will have a gold bag and item bag.                   ║
# ║   Every enemy you want to steal needs the steal skill              ║
# ║   with the note tag                                                ║
# ║                                                                    ║
# ║   When the enemy is killed, it's gold/item is taken back           ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 14 Aug 2023 - Script finished                               ║
# ║ 1.01 - 15 Aug 2023 - Set messages to show Party word               ║
# ║ 1.02 - 15 Aug 2023 - Set messages to show actor name               ║
# ║ 1.03 - 20 Aug 2023 - Optimized Code                                ║
# ║ 1.04 - 27 Mar 2024 - Combined actor and party options              ║
# ║ 1.05 - 10 Aug 2024 - Added enemy steal items                       ║
# ║ 1.06 - 19 Aug 2024 - Fixed not stealing Key items                  ║
# ║ 1.07 - 14 Mar 2026 - Added Import Value                            ║
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

module R2_Enemy_Gold_Bag
  Gold_Steal = "<gold steal>" # tag required on skill to steal gold
  Item_Steal = "<item steal>" # tag required on skill to steal gold
  
  Use_Actor = true # must be actor or party not both
  Actor_Gold_Text  = "%s lost %s gold!" # Actor, value. e.g. Eric lost 180 gold!
  Actor_Gold_Saved = "%s recovered %s gold!" # Actor, value. e.g. Eric recovered 180 gold!
  Actor_Item_Text  = "%s lost item %s!" # Actor, value. e.g. Eric lost 180 gold!
  Actor_Item_Saved = "%s recovered item %s!" # Actor, value. e.g. Eric recovered 180 gold!
  
  # party will be used if actor is false
  Party_Gold_Text  = "Party lost %s gold!" # Actor, value. e.g. Eric lost 180 gold!
  Party_Gold_Saved = "Party recovered %s gold!" # Actor, value. e.g. Eric recovered 180 gold!
  Party_Item_Text  = "Party lost item %s!" # Actor, value. e.g. Eric lost 180 gold!
  Party_Item_Saved = "Party recovered item %s!" # Actor, value. e.g. Eric recovered 180 gold!
end
 
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_egib] = 1.07         # Enemy Gold / Item Bag

#==============================================================================
# ** Game_Enemy
#==============================================================================
class Game_Enemy < Game_Battler
  attr_accessor :gold_bag
  attr_accessor :item_bag
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias r2_enemy_gold_bag_initialize  initialize
  def initialize(index, enemy_id)
    r2_enemy_gold_bag_initialize(index, enemy_id)
    @gold_bag = 0
    @item_bag = []
  end
end

#==============================================================================
# ** Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Apply Effect of Skill/Item
  #--------------------------------------------------------------------------
  alias r2_make_gold_item_stole_apply    item_apply
  def item_apply(user, item)
    ovars = Marshal.load(Marshal.dump($game_variables))
    oswitchs = $game_switches.clone
    value = item.damage.eval(user, self, $game_variables)
    $game_variables = ovars
    $game_switches = oswitchs
    r2_make_gold_item_stole_apply(user, item)
    if user.is_a?(Game_Enemy)
      if item.note.include?(R2_Enemy_Gold_Bag::Gold_Steal)
        @result.clear_hit_flags
        if $game_party.gold < value
          value = $game_party.gold
        end
        user.gold_bag += value.to_i
        $game_party.gain_gold(-value.to_i)
        value = 0
      end
      if item.note.include?(R2_Enemy_Gold_Bag::Item_Steal)
        pitems = []
        $game_party.items.each { |pyi| pitems.push(pyi) if pyi.is_a?(RPG::Item) && !pyi.key_item? }
        pit = pitems.size
        return if pit == 0
        randitem = pitems[rand(pit)]
        user.item_bag.push(randitem)
        $game_party.lose_item(randitem, 1)
      end
      @result.make_damage(value.to_i, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Knock Out
  #--------------------------------------------------------------------------
  alias r2_enemy_gold_bag_return_die  die
  def die
    r2_enemy_gold_bag_return_die
    if self.is_a?(Game_Enemy)
      if self.gold_bag > 0
        $game_party.gain_gold(self.gold_bag)
        SceneManager.scene.recover_gold(self.gold_bag) if SceneManager.scene_is?(Scene_Battle)
        self.gold_bag = 0
      end
      if !self.item_bag.empty?
        self.item_bag.each { |it| $game_party.gain_item(it,1) }
        SceneManager.scene.recover_item(self.item_bag) if SceneManager.scene_is?(Scene_Battle)
        self.item_bag = []
      end
    end
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #--------------------------------------------------------------------------
  alias r2_use_item_gold_stolen use_item
  def use_item
    item = @subject.current_action.item
    targets = @subject.current_action.make_targets.compact
    plis = @subject.item_bag.size if @subject.is_a?(Game_Enemy)
    r2_use_item_gold_stolen
    if @subject.is_a?(Game_Enemy)
      if item.note.include?(R2_Enemy_Gold_Bag::Gold_Steal)
        @log_window.draw_gold_stolen(targets[0].name, @subject.gold_bag)
      end
      alis = @subject.item_bag.size
      if item.note.include?(R2_Enemy_Gold_Bag::Item_Steal) && plis < alis
        @log_window.draw_item_stolen(targets[0].name, @subject.item_bag[-1])
      end
    end
  end
  def recover_gold(gold)
    name = @subject.name
    @log_window.draw_recover_gold(name, gold)
  end
  def recover_item(items)
    name = @subject.name
    @log_window.draw_recover_item(name, items)
  end
end

#==============================================================================
# ** Window_BattleLog
#==============================================================================
class Window_BattleLog < Window_Selectable
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Gold Stolen                                             [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_gold_stolen(target, value)
    if value > 0
      ww = window_width
      if R2_Enemy_Gold_Bag::Use_Actor
        text = sprintf(R2_Enemy_Gold_Bag::Actor_Gold_Text, target, value)
      else
        text = sprintf(R2_Enemy_Gold_Bag::Party_Gold_Text, target, value)
      end
      draw_text(0, 0, ww - 24, line_height, text, v_align)
      wait
      clear
    end
  end
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Gold Recovered                                          [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_recover_gold(actor, value)
    if value > 0
      ww = window_width
      if R2_Enemy_Gold_Bag::Use_Actor
        text = sprintf(R2_Enemy_Gold_Bag::Actor_Gold_Saved, actor, value)
      else
        text = sprintf(R2_Enemy_Gold_Bag::Party_Gold_Saved, actor, value)
      end
      draw_text(0, 0, ww - 24, line_height, text, v_align)
      wait
      clear
    end
  end
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Item Stolen                                             [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_item_stolen(target, item)
    ww = window_width
    if R2_Enemy_Gold_Bag::Use_Actor
      text = sprintf(R2_Enemy_Gold_Bag::Actor_Item_Text, target, item.name)
    else
      text = sprintf(R2_Enemy_Gold_Bag::Party_Item_Text, target, item.name)
    end
    add_text(text)
    wait
  end
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║ Draw Item Recovered                                          [NEW METHOD] ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
  def draw_recover_item(actor, items)
    ww = window_width
    items.each { |item|
      if R2_Enemy_Gold_Bag::Use_Actor
        text = sprintf(R2_Enemy_Gold_Bag::Actor_Item_Saved, actor, item.name)
      else
        text = sprintf(R2_Enemy_Gold_Bag::Party_Item_Saved, actor, item.name)
      end
      add_text(text)
      wait
    }
  end
end
