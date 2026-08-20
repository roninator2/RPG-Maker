# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: ATB/CTB System From Circle Cross - mod ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Provide CTB system for battle               ║    17 Feb 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Customize CTB system                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure Settings Below                                         ║
# ║                                                                    ║
# ║   Guard skill cannot be used with this script because the state    ║
# ║     is removed right after selecting guard due to the default      ║
# ║     battle system processes.                                       ║
# ║   This script removes the guard skill from the actor command       ║
# ║                                                                    ║
# ║   There is no Party Command, so if you need escape, you need to    ║
# ║     add it in another way.                                         ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 17 Feb 2024 - Script finished                               ║
# ║ 1.01 - 10 May 2024 - Adjusted to remove party command              ║
# ║ 1.02 - 14 Mar 2026 - Added Import Value                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Circle Cross                                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

#==============================================================================
# □ CTB（2013/03/08）
#------------------------------------------------------------------------------
# 　CTB introduction
#==============================================================================

module R2_CTB_SETTINGS

  # Set the AP required to act.
  CC_CTB_AP_ACTION_LIMIT = 100
 
  # Select whether to set AP to 0 after action.
  # Specify true to set to 0, false otherwise.
  CC_CTB_AP_RESET = true
 
  # Set combat speed. Smaller is faster.
  # Set a value greater than 0.
  CC_CTB_BATTLE_SPEED = 20.0
 
  # Adjust or set combat speed to be constant regardless of agility.
  # When true, make battle speed constant.
  CC_CTB_BATTLE_SPEED_ADJUST = true
 
  # Sets the battle speed when CC_CTB_BATTLE_SPEED_ADJUST is true.
  # Higher values are faster.
  CC_CTB_ADJUSTED_SPEED = 20.0
 
  # Set the timing of automatic recovery.
  # At the end of action = 0, at the time of TP natural increase = 1
  CC_CTB_REGENERATE_TIMING = 1
 
  # Adjust the auto-recovery speed. Smaller is faster.
  # Set a value greater than 0.
  CC_CTB_REGENERATE_SPEED = 20.0
 
  # Set the AP consumed when using the item.
  CC_CTB_ITEM_AP_COST = CC_CTB_AP_ACTION_LIMIT
 
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

$imported = {} if $imported.nil?
$imported[:r2_bctbectb] = 1.02     # ATB/CTB System From Circle Cross

#==============================================================================
# □ BattleManager
#------------------------------------------------------------------------------
# 　A module that manages the progress of battles.
#==============================================================================

module BattleManager
  class << self
    #--------------------------------------------------------------------------
    # ○ Combat start
    #--------------------------------------------------------------------------
    alias cc_ctb_battle_start battle_start
    def battle_start
      cc_ctb_battle_start
      if @preemptive
        $game_party.members.each {|member| member.ap += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT / 2 }
      elsif @surprise
        $game_troop.members.each {|member| member.ap += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT / 2 }
      end
      speed_adjust_set if R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST
    end
    #--------------------------------------------------------------------------
    # ○ Creating action sequences
    #--------------------------------------------------------------------------
    def make_action_orders
      @action_battlers = [next_action_battler]
      @action_battlers[0].increase_turn if @action_battlers[0].is_a?(Game_Enemy)
    end
    #--------------------------------------------------------------------------
    # ○ Acquiring the next battler to act
    #--------------------------------------------------------------------------
    def next_action_battler
      battlers = []
      battlers += $game_party.alive_members unless @surprise
      battlers += $game_troop.alive_members unless @preemptive
      battlers.sort! {|a,b| b.agi - a.agi }
      battlers.min_by {|battler|
        (R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT - battler.ap) / battler.agi
      }
    end
    #--------------------------------------------------------------------------
    # ○ Get Combat Speed Modifier
    #--------------------------------------------------------------------------
    def speed_adjust_set
      battlers = $game_party.members + $game_troop.members
      $cc_ctb_speed_adjust = battlers.max_by {|battler| battler.agi }.agi / R2_CTB_SETTINGS::CC_CTB_ADJUSTED_SPEED
    end
  end
end

#==============================================================================
# □ Game_BattlerBase
#------------------------------------------------------------------------------
# 　This is the basic class that handles battlers.
#  Mainly contains methods for ability score calculation. child
#  class is used as the superclass of the Game_Battler class.
#==============================================================================

class Game_BattlerBase
  alias cc_ctb_hrg hrg
  alias cc_ctb_mrg mrg
  alias cc_ctb_trg trg
  def hrg;  cc_ctb_hrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ?
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # HP再生率   Hp ReGeneration rate
  def mrg;  cc_ctb_mrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ?
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # MP再生率   Mp ReGeneration rate
  def trg;  cc_ctb_trg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 ?
    R2_CTB_SETTINGS::CC_CTB_REGENERATE_SPEED : 1);  end    # TP再生率   Tp ReGeneration rate
  #--------------------------------------------------------------------------
  # ○ public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :ap                       # AP
  #--------------------------------------------------------------------------
  # ○ object initialization
  #--------------------------------------------------------------------------
  alias cc_atb_initialize initialize
  def initialize
    @ap = 0
    cc_atb_initialize
  end
  #--------------------------------------------------------------------------
  # ○ AP change of
  #--------------------------------------------------------------------------
  def ap=(ap)
    @ap = [[ap, max_ap].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ AP get the percentage of
  #--------------------------------------------------------------------------
  def ap_rate
    @ap.to_f / max_ap
  end
  #--------------------------------------------------------------------------
  # ○ AP get the maximum value of
  #--------------------------------------------------------------------------
  def max_ap
    return R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ Skill AP consumption calculation
  #--------------------------------------------------------------------------
  def skill_ap_cost(skill)
    skill.speed
  end
  #--------------------------------------------------------------------------
  # ○ Ability to pay for skill use cost
  #--------------------------------------------------------------------------
  alias cc_ctb_skill_cost_payable? skill_cost_payable?
  def skill_cost_payable?(skill)
    (!$game_party.in_battle || ap >= skill_ap_cost(skill)) && cc_ctb_skill_cost_payable?(skill)
  end
  #--------------------------------------------------------------------------
  # ○ Pay skill use cost
  #--------------------------------------------------------------------------
  alias cc_ctb_pay_skill_cost pay_skill_cost
  def pay_skill_cost(skill)
    cc_ctb_pay_skill_cost(skill)
    self.ap -= skill_ap_cost(skill) if $game_party.in_battle
  end
  #--------------------------------------------------------------------------
  # ○ action judgment
  #--------------------------------------------------------------------------
  def action?
    ap >= R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT && self == BattleManager.next_action_battler
  end
end

#==============================================================================
# □ Game_Battler
#------------------------------------------------------------------------------
# 　A Butler class with sprite and action related methods added. this class
#  is used as the superclass for the Game_Actor and Game_Enemy classes.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ○ AP initialization of
  #--------------------------------------------------------------------------
  def init_ap
    self.ap = rand * 25
  end
  #--------------------------------------------------------------------------
  # ○ Battle start process
  #--------------------------------------------------------------------------
  alias cc_ctb_on_battle_start on_battle_start
  def on_battle_start
    cc_ctb_on_battle_start
    init_ap
  end
  #--------------------------------------------------------------------------
  # ○ Combat action creation
  #--------------------------------------------------------------------------
  alias cc_ctb_make_actions make_actions
  def make_actions
    cc_ctb_make_actions
    @actions = [] if self != BattleManager.next_action_battler
  end
  #--------------------------------------------------------------------------
  # ○ Judgment that command input is possible
  #--------------------------------------------------------------------------
  alias cc_ctb_inputable? inputable?
  def inputable?
    cc_ctb_inputable? && action?
  end
  #--------------------------------------------------------------------------
  # ○ HP the playback of
  #--------------------------------------------------------------------------
  def regenerate_hp
    damage = -(mhp * hrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 &&
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)).to_i
    perform_map_damage_effect if $game_party.in_battle && damage > 0
    @result.hp_damage = [damage, max_slip_damage].min
    self.hp -= @result.hp_damage
  end
  #--------------------------------------------------------------------------
  # ○ MP the playback of
  #--------------------------------------------------------------------------
  def regenerate_mp
    @result.mp_damage = -(mmp * mrg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 &&
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1))
    self.mp -= @result.mp_damage
  end
  #--------------------------------------------------------------------------
  # ○ TP the playback of
  #--------------------------------------------------------------------------
  def regenerate_tp
    self.tp += R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT * trg / (R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1 &&
    R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)
  end
  #--------------------------------------------------------------------------
  # ○ Processing at the end of combat action
  #--------------------------------------------------------------------------
  alias cc_ctb_on_action_end on_action_end
  def on_action_end
    cc_ctb_on_action_end
    regenerate_all if R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 0
  end
  #--------------------------------------------------------------------------
  # ○ TP consumption when acting
  #--------------------------------------------------------------------------
  def cc_ctb_ap_action_cost
    if (R2_CTB_SETTINGS::CC_CTB_AP_RESET || !current_action) && action?
      self.ap -= R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
    elsif current_action && current_action.item.is_a?(RPG::Item)
      self.ap -= R2_CTB_SETTINGS::CC_CTB_ITEM_AP_COST
    end
  end
  #--------------------------------------------------------------------------
  # ○ End of turn process
  #--------------------------------------------------------------------------
  def on_turn_end
    @result.clear
    remove_states_auto(2)
  end
end

#==============================================================================
# □ Game_Enemy
#------------------------------------------------------------------------------
# 　A class that handles enemy characters. This class is the Game_Troop class
#  ($game_troop) Used internally.
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ public instance variables
  #--------------------------------------------------------------------------
  attr_reader   :turn_count               # Enemy group index
  #--------------------------------------------------------------------------
  # ○ object initialization
  #--------------------------------------------------------------------------
  alias cc_ctb_initialize initialize
  def initialize(index, enemy_id)
    cc_ctb_initialize(index, enemy_id)
    @turn_count = 1
  end
  #--------------------------------------------------------------------------
  # ○ Action condition match judgment [number of turns]
  #--------------------------------------------------------------------------
  def conditions_met_turns?(param1, param2)
    n = @turn_count
    if param2 == 0
      n == param1
    else
      n > 0 && n >= param1 && n % param2 == param1 % param2
    end
  end
  #--------------------------------------------------------------------------
  # ○ increase in turns
  #--------------------------------------------------------------------------
  def increase_turn
    @turn_count += 1
  end
end

#==============================================================================
# □ Window_Base
#------------------------------------------------------------------------------
# 　The superclass of all windows in the game.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ Acquisition of various character colors
  #--------------------------------------------------------------------------
  def ap_gauge_color1;   text_color(30);  end;    # AP gauge 1
  def ap_gauge_color2;   text_color(31);  end;    # AP gauge 2
  #--------------------------------------------------------------------------
  # ○ AP get the text color of
  #--------------------------------------------------------------------------
  def ap_color(actor)
    return normal_color
  end
  #--------------------------------------------------------------------------
  # ○ AP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_ap(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.ap_rate, ap_gauge_color1, ap_gauge_color2)
    #change_color(system_color)
    #draw_text(x, y, 30, line_height, Vocab::ap_a)
    #change_color(ap_color(actor))
    #draw_text(x + width - 42, y, 42, line_height, actor.ap.to_i, 2)
  end
  #--------------------------------------------------------------------------
  # ○ HP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp.to_i, actor.mhp,
      hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # ○ MP Drawing of
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp.to_i, actor.mmp,
      mp_color(actor), normal_color)
  end
end

#==============================================================================
# □ Window_BattleStatus
#------------------------------------------------------------------------------
# 　A window that displays the status of party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ○ Draw a basic area
  #--------------------------------------------------------------------------
  alias cc_atb_draw_basic_area draw_basic_area
  def draw_basic_area(rect, actor)
    draw_actor_ap(actor, rect.x + 0, rect.y, 100)
    cc_atb_draw_basic_area(rect, actor)
  end
end

#==============================================================================
# □ Window_Selectable
#------------------------------------------------------------------------------
# 　Window class with cursor movement and scrolling functions.
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # ○ Redraw all items
  #--------------------------------------------------------------------------
  def redraw_all_items
    item_max.times {|i| clear_item(i) }
    item_max.times {|i| draw_item(i) }
  end
end

#==============================================================================
# □ Scene_Battle
#------------------------------------------------------------------------------
# 　A class that processes the battle screen.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ○ Redraw the information in the status window
  #--------------------------------------------------------------------------
  def redraw_status
    @status_window.redraw_all_items
    @enemy_window.redraw_all_items
  end
  #--------------------------------------------------------------------------
  # ○ Update information in status window
  #--------------------------------------------------------------------------
  def refresh_status
    @status_window.refresh
    @enemy_window.refresh
  end
  #--------------------------------------------------------------------------
  # ○ Frame update (AP increase)
  #--------------------------------------------------------------------------
  def update_ap
    all_alive_members.each do |member|
      member.ap += member.agi / R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED / (R2_CTB_SETTINGS::CC_CTB_BATTLE_SPEED_ADJUST ? $cc_ctb_speed_adjust : 1)
      member.regenerate_all if R2_CTB_SETTINGS::CC_CTB_REGENERATE_TIMING == 1
    end
    redraw_status
    update_basic
  end
  #--------------------------------------------------------------------------
  # ○ Start party command selection
  #--------------------------------------------------------------------------
  def start_party_command_selection
    unless scene_changing?
      refresh_status
      @status_window.unselect
      @status_window.open
      while BattleManager.next_action_battler.ap < R2_CTB_SETTINGS::CC_CTB_AP_ACTION_LIMIT
        update_ap
      end
      if BattleManager.input_start
        next_command
      else
        @party_command_window.deactivate
        turn_start
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ Acquisition of all battle members including enemies and allies
  #--------------------------------------------------------------------------
  def all_movable_members
    $game_party.movable_members + $game_troop.movable_members
  end
  #--------------------------------------------------------------------------
  # ○ Acquisition of all surviving members including enemies and allies
  #--------------------------------------------------------------------------
  def all_alive_members
    $game_party.alive_members + $game_troop.alive_members
  end
  #--------------------------------------------------------------------------
  # ○ Command [Escape]
  #--------------------------------------------------------------------------
  alias cc_ctb_command_escape command_escape
  def command_escape
    cc_ctb_command_escape
    $game_party.movable_members.each do |member|
      member.ap = 0
    end
  end
  #--------------------------------------------------------------------------
  # ○ start of turn
  #--------------------------------------------------------------------------
  def turn_start
    @party_command_window.close
    @actor_command_window.close
    @status_window.unselect
    @subject = nil
    BattleManager.turn_start
    @log_window.clear
  end
  #--------------------------------------------------------------------------
  # ○ Handling Combat Actions
  #--------------------------------------------------------------------------
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    if @subject.action?
      @subject.update_state_turns
      @subject.update_buff_turns
    end
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
    end
    if @subject.action?
      @subject.cc_ctb_ap_action_cost
    end
    if @subject.current_action
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end
end

# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Show ATB Bar for Enemies               ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Show Enemy ATB Bar                          ║    06 Jun 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Above script                                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║          Show the ATB Bar for ATB system above                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Adjust the settings below                                        ║
# ║                                                                    ║
# ║   Due to the positioning of the enemy,                             ║
# ║   you will likely need to adjust the bar position                  ║
# ║   so that the adjustment numbers are negative.                     ║
# ║   This is because I used the enemies screen position               ║
# ║   which causes the bar to be at the bottom of the                  ║
# ║   enemy position. The window is also set to not                    ║
# ║   overlap the status window.                                       ║
# ║                                                                    ║
# ║   Requires Circle Cross AP script                                  ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Jun 2023 - Script finished                               ║
# ║ 1.01 - 14 Mar 2026 - Added Import Value                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_AP_Gauge_Pos
  X_Adjust  = -70         # x position of the bar from the enemy position
  Y_Adjust  = -20         # y position of the bar from the enemy position
  EAP_Width  = 100        # Enemy Bar width
  EAP_Height = 12         # Enemy Bar height
  Enemy_Colour_1 = 17     # Starting colour of bar
  Enemy_Colour_2 = 29     # Ending colour of bar
  Draw_Enemy_Name = false # Draw enemy name
  EAP_Name_Below = true   # Draw Enemy Name below gauge
  AAP_Width  = 100        # Actor Bar width
  AAP_Height = 10         # Actor Bar height
  Actor_Colour_1 = 30     # Starting colour of bar
  Actor_Colour_2 = 31     # Ending colour of bar
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

$imported = {} if $imported.nil?
$imported[:r2_satbfe] = 1.01       # Show ATB Bar for Enemies

#==============================================================================
# Enemy AP
#==============================================================================
class Window_Enemy_AP < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(status)
    super(0, 0, Graphics.width, Graphics.height - status)
    self.opacity = 0
    self.contents_opacity = 255
    self.back_opacity = 0
    self.z = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_troop.alive_members.size
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 32
  end
  #--------------------------------------------------------------------------
  # ○ Assigning gauge colors
  #--------------------------------------------------------------------------
  def eap_gauge_color1;   text_color(R2_AP_Gauge_Pos::Enemy_Colour_1);  end
  def eap_gauge_color2;   text_color(R2_AP_Gauge_Pos::Enemy_Colour_2);  end
  #--------------------------------------------------------------------------
  # ○ AP Drawing
  #--------------------------------------------------------------------------
  def draw_enemy_ap(enemy, x, y, width = 124)
    draw_e_gauge(x, y, width, enemy.ap_rate, eap_gauge_color1, eap_gauge_color2)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    enmy = $game_troop.alive_members[index]
    rect = Rect.new
    rect.width = R2_AP_Gauge_Pos::EAP_Width
    rect.height = R2_AP_Gauge_Pos::EAP_Height
    rect.height += 30 if R2_AP_Gauge_Pos::EAP_Name_Below
    rect.x = enmy.screen_x + R2_AP_Gauge_Pos::X_Adjust
    rect.y = enmy.screen_y + R2_AP_Gauge_Pos::Y_Adjust
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items (for Text)
  #--------------------------------------------------------------------------
  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += 4
    rect.y -= 8
    rect.width -= 8
    rect.height += 8
    rect
  end
  #--------------------------------------------------------------------------
  # ○ Draw a basic area
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, enemy)
    width = R2_AP_Gauge_Pos::EAP_Width
    draw_enemy_ap(enemy, rect.x + 0, rect.y, width)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color)
    enemy = $game_troop.alive_members[index]
    draw_basic_area(basic_area_rect(index), enemy)
    name = $game_troop.alive_members[index].name
    draw_text(item_rect_for_text(index), name) if R2_AP_Gauge_Pos::Draw_Enemy_Name
  end
  #--------------------------------------------------------------------------
  # * Get Basic Area Retangle
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= 210
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_e_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8 - R2_AP_Gauge_Pos::EAP_Height
    gauge_h = R2_AP_Gauge_Pos::EAP_Height
    contents.fill_rect(x, gauge_y, width, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, gauge_h, color1, color2)
  end
end

#==============================================================================
# ** Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Basic Area
  #--------------------------------------------------------------------------
  alias r2_atb_draw_basic_area draw_basic_area
  def draw_basic_area(rect, actor)
    width = R2_AP_Gauge_Pos::AAP_Width
    draw_actor_ap(actor, rect.x + 0, rect.y, width)
    r2_atb_draw_basic_area(rect, actor)
  end
  #--------------------------------------------------------------------------
  # ○ Assigning gauge colors
  #--------------------------------------------------------------------------
  def ap_gauge_color1;   text_color(R2_AP_Gauge_Pos::Actor_Colour_1);  end
  def ap_gauge_color2;   text_color(R2_AP_Gauge_Pos::Actor_Colour_2);  end
  #--------------------------------------------------------------------------
  # ○ AP Gauge
  #--------------------------------------------------------------------------
  def draw_actor_ap(actor, x, y, width = 124)
    draw_ap_gauge(x, y, width, actor.ap_rate, ap_gauge_color1, ap_gauge_color2)
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_ap_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 4 - R2_AP_Gauge_Pos::AAP_Height
    gauge_h = R2_AP_Gauge_Pos::AAP_Height
    contents.fill_rect(x, gauge_y, width, gauge_h, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, gauge_h, color1, color2)
  end
end

#==============================================================================
# Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Create Enemy Window
  #--------------------------------------------------------------------------
  alias r2_enemy_ap_window_create create_enemy_window
  def create_enemy_window
    r2_enemy_ap_window_create
    @enemy_ap = Window_Enemy_AP.new(@status_window.height)
  end
  #--------------------------------------------------------------------------
  # ○ Redraw the information in the status window
  #--------------------------------------------------------------------------
  alias r2_redraw_ap_status redraw_status
  def redraw_status
    r2_redraw_ap_status
    @enemy_ap.refresh
  end
  #--------------------------------------------------------------------------
  # * Processing at End of Action
  #--------------------------------------------------------------------------
  alias r2_action_end_refresh_ap_gauge  process_action_end
  def process_action_end
    @enemy_ap.refresh
    r2_action_end_refresh_ap_gauge
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  alias r2_show_ap_enemy_skill_command  command_skill
  def command_skill
    r2_show_ap_enemy_skill_command
    @enemy_ap.hide
  end
  #--------------------------------------------------------------------------
  # * Skill [OK]
  #--------------------------------------------------------------------------
  alias r2_skill_ok_ap_hide   on_skill_ok
  def on_skill_ok
    @enemy_ap.show
    r2_skill_ok_ap_hide
  end
  #--------------------------------------------------------------------------
  # * Skill [Cancel]
  #--------------------------------------------------------------------------
  alias r2_on_skill_ap_cancel_window   on_skill_cancel
  def on_skill_cancel
    @enemy_ap.show
    r2_on_skill_ap_cancel_window
  end
end
