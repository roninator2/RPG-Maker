# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: D&D Stat Distribution Standalone       ║  Version: 1.09     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Allocate stats like in D&D                  ║    22 Nov 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: You are making a D&D game                                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ This script is designed to raise stats from base                   ║
# ║ value to a max of 18 points.                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Calling the scene Manually if Menu is false                      ║
# ║     Use script call command and use                                ║
# ║        - call_dnd_distribute                                       ║
# ║                                                                    ║
# ║   Adding point to actor                                            ║
# ║     Use script call command and use                                ║
# ║        - add_dnd_points(actor id, amount)                          ║
# ║     Can also be used in reverse by apecifying a                    ║
# ║     negative number in the script call command                     ║
# ║                                                                    ║
# ║  Script currently does not account for gaining points              ║
# ║     when leveling up.                                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 22 Nov 2023 - Script finished                               ║
# ║ 1.01 - 23 Nov 2023 - Adjusted code                                 ║
# ║ 1.02 - 23 Nov 2023 - Added left right                              ║
# ║ 1.03 - 23 Nov 2023 - Moved windows                                 ║
# ║ 1.04 - 23 Nov 2023 - Adjusted for force point allocation           ║
# ║ 1.05 - 23 Nov 2023 - Trimmed down for alternative use              ║
# ║ 1.06 - 24 Nov 2023 - Adjusted for initial cost vs later            ║
# ║ 1.07 - 31 Aug 2024 - Added bonus point display                     ║
# ║ 1.08 - 31 Aug 2024 - Fixed Param Calculations                      ║
# ║ 1.09 - 14 Mar 2026 - Added Import Value                            ║
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

#===============================================================================
module Distribute_Config
  #--------------------------------------------------------------------------
  # * Creating Variables - Do not Change
  #--------------------------------------------------------------------------
  Param_Config = Hash.new
  Human_Settings = Array.new
  #--------------------------------------------------------------------------
  # * Configuration - Color
  #--------------------------------------------------------------------------
  # Color Green on the text
  Green_Color = Color.new(120,230,120)
  #--------------------------------------------------------------------------
  # * Configuration General
  #--------------------------------------------------------------------------
  # Put option in the menu
  Put_On_Menu = true
  # SE name if command is not able to execute
  Wrong_Select = "computer_-_error_05"
  # Points each hero starts with
  Initial_Points = 30
  # Main Actor ID
  Main_Actor = 1 # points is only given to the main actor
  #--------------------------------------------------------------------------
  # * Vocabulary
  #--------------------------------------------------------------------------
  # Vocabulary for price
  Price_Vocab = "Cost: "
  # Vocabulary of the top
  Top_Vocab = "Distribute Attribute Points"
  # Vocabulary points
  Points_Vocab = "Points Left: "
  # Vocabulary points total
  Points_Total = "Total Points: "
  # Vocabulary in the menu
  Menu_Vocab = "Increase Attributes"
  #--------------------------------------------------------------------------
  # * Settings - Stats
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # * Instructions
  # You set here the name and other settings for each stat
  #
  # The first thing we have is Human_Settings = [
  # This is set so that future work shows where the groundwork for how to 
  # change the script for adding other races into the system
  #
  # Param_Config[id] = { Your stat values
  # Here we have to put the id of the parameter that we are going to use,
  # There are 8 parameters and the count starts from 0, but as we are not using
  # HP or MP for stats that get adjusted they are left out, this leaves 6.
  # 0 = Strength
  # 1 = Dexterity
  # 2 = Wisdom
  # 3 = Intelligence
  # 4 = Charisma
  # 5 = Luck
  #
  # Within Param Config we will have the settings of the current parameter, 
  # in case your id corresponding to the table above.
  #
  # vocab:        "vocabulary for the parameter",
  # icon:         parameter icon,
  # point_price:  Points spent on each confirmation * increases
  #   at each change price value the price will increase
  # change_price_level: Array that holds the values used to determine
  #   at what value the cost increases.
  # max_value:    after reaching max value you cannot increase any more
  # des:          parameter description,
  #   Description should use \n within the quotes for line breaks
  #
  # OBS: Never forget to put the comma at the end of all settings
  #
  # Example:
  #
  # Param_Config[0] = {
  # vocab: "Strength",
  # icon: 1,
  # point_price: 1,
  # change_price_value: [14,16],
  # max_value: 18,
  # des: "They say that a warrior with great life has more\n
  # Chances of surviving"
  # },
  #--------------------------------------------------------------------------
  Arrow = 10103 # use instead of drawn text arrow, will show icon
  Use_Arrow_Icon = true
  
  Human_Settings = [
  
 Param_Config[0] = {
  vocab: "Strength",
  icon: 10072,
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Adds modifiers that increase melee hit chance, melee damage," + "\n" +
  "and Intimidation skill levels."
  },
 
  Param_Config[1] = {
  vocab: "Body",
  icon: 10066,
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Increases maximum Health Points and affects BODY saves."
  },
 
  Param_Config[2] = {
  vocab: "Intelligence",
  icon: 10065,
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Adds modifiers that increase Security, Computer Use, Demolitions, and Repair skill levels, and
Health Points healed using robot repair items."
  },
 
  Param_Config[3] = {
  vocab: "Wisdom",
  icon: 10082,
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Adds modifiers that increase First Aid skill levels, Health Points healed using medical items,
martial arts damage, affects WIS saves."
  },
 
  Param_Config[4] = {
  vocab: "Reflexes",
  icon: 10095,
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Adds modifiers to increase ranged weapon hit chance, Attack Bonus, Armor Class, and affects
REF saves."
  },
 
  Param_Config[5] = {
  icon: 10071,
  vocab: "Charisma",
  point_price: 1,
  change_price_level: [14,16],
  max_value: 30,
  desc: "Adds modifiers that increase Persuasion skill levels and can affect dialogue choices."
  },
  ]
  # This is the bonus that is applyed when stat points reach a specific level
  # this is added to actor.param_dnd_bonus for use in game
  # it is also added to the final params of the actor.
  # this is controlled by the below option
  Add_to_Base = true
  # scale of bonus modifiers below
  Bonus_Scale = { # base stat point => bonus modifier
                  1 => 0,
                  2 => 0,
                  3 => 0,
                  4 => 0,
                  5 => 0,
                  6 => 0,
                  7 => 0,
                  8 => 0,
                  9 => 0,
                  10 => 0,
                  11 => 0,
                  12 => 0,
                  13 => 0,
                  14 => 1,
                  15 => 1,
                  16 => 2,
                  17 => 2,
                  18 => 3,
                  19 => 3,
                  20 => 4,
                  21 => 4,
                  22 => 5,
                  23 => 5,
                  24 => 6,
                  25 => 6,
                  26 => 7,
                  27 => 7,
                  28 => 8,
                  29 => 8,
                  30 => 9,
  }
  #--------------------------------------------------------------------------
  # * End of configurations
  #--------------------------------------------------------------------------
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_ddsds] = 1.09        # D&D Stat Distribution Standalone

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Call distribution window
  #--------------------------------------------------------------------------
  def call_dnd_distribute
    SceneManager.call(Scene_DnD_Distribute)
  end
  #--------------------------------------------------------------------------
  # * Increase points
  #    actor   : character
  #    amount  : quantity
  #--------------------------------------------------------------------------
  def add_dnd_points(actor_id, amount)
    actor = $game_actors[actor_id]
    actor.points += amount
  end
  #--------------------------------------------------------------------------
  # * Change Parameters
  #--------------------------------------------------------------------------
  def command_317
    value = operate_value(@params[3], @params[4], @params[5])
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.add_param_dnd(@params[2], value)
    end
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public variable
  #--------------------------------------------------------------------------
  attr_accessor :points
  attr_accessor :param_dnd
  attr_accessor :initial_points
  attr_accessor :param_dnd_bonus
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias r2_actor_dist_ini initialize
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    @param_dnd = [0] * 8
    @param_dnd_bonus = [0] * 8
    r2_actor_dist_ini(actor_id)
    @points = actor_id == Distribute_Config::Main_Actor ? Distribute_Config::Initial_Points : 0
    @initial_points = true if actor_id == Distribute_Config::Main_Actor
  end
  #--------------------------------------------------------------------------
  # * Get Parameter
  #--------------------------------------------------------------------------
  def param(param_id)
    value = param_base(param_id) + param_plus(param_id) + param_dnd(param_id)
    value += param_dnd_bonus(param_id) if Distribute_Config::Add_to_Base == true
    value *= param_rate(param_id) * param_buff_rate(param_id)
    [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_dnd(param_id)
    @param_dnd[param_id]
  end
  #--------------------------------------------------------------------------
  # * Increase Parameter
  #--------------------------------------------------------------------------
  def add_param_dnd(param_id, value)
    @param_dnd[param_id] += value
    refresh
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias r2_level_up_stat_points   level_up
  def level_up
    r2_level_up_stat_points
    if @level % 4 == 0
      @points += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_dnd_bonus(param_id)
    @param_dnd_bonus[param_id]
  end
  #--------------------------------------------------------------------------
  # * Increase Parameter
  #--------------------------------------------------------------------------
  def set_param_dnd_bonus(param_id, value)
    @param_dnd_bonus[param_id] = value
    refresh
  end
end

class Window_DnDDescription < Window_Base
  #--------------------------------------------------------------------------
  # * Public variable
  #--------------------------------------------------------------------------
  attr_accessor :id
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
    @id = 0
    set_text
  end
  #--------------------------------------------------------------------------
  # * Make text
  #--------------------------------------------------------------------------
  def set_text
    self.contents.clear
    draw_text_ex(0,0,Distribute_Config::Param_Config[@id][:desc])
  end
end

class Window_DnDParams < Window_Selectable
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,height)
    super(x,y,window_width,height)
  end
  #--------------------------------------------------------------------------
  # * Actor
  #--------------------------------------------------------------------------
  def actor(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Window width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # * Item Max
  #--------------------------------------------------------------------------
  def item_max
    return 6
  end
  #--------------------------------------------------------------------------
  # * Item Height
  #--------------------------------------------------------------------------
  def item_height
    return 24
  end
  #--------------------------------------------------------------------------
  # * Drawing item
  #--------------------------------------------------------------------------
  def draw_item(index)
    case index
    when 0
      param_data = Distribute_Config::Human_Settings[0]
      param_id = 2
    when 1
      param_data = Distribute_Config::Human_Settings[1]
      param_id = 3
    when 2
      param_data = Distribute_Config::Human_Settings[2]
      param_id = 4
    when 3
      param_data = Distribute_Config::Human_Settings[3]
      param_id = 5
    when 4
      param_data = Distribute_Config::Human_Settings[4]
      param_id = 6
    when 5
      param_data = Distribute_Config::Human_Settings[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
        mul += param_data[:point_price] if (value >= pm) && (@actor.initial_points == true)
    end
    change = "Press left/right to decrease/increase. Press page up/page down to switch characters."
    draw_text(24,0,Graphics.width,24,change)
    max = param_data[:max_value]
    max = 18 if @actor.initial_points == true
    if value >= max
      change_color(crisis_color)
      draw_icon(param_data[:icon],5,index*24+48)
      draw_text(29,index*24+48,Graphics.width-200,24,param_data[:vocab])
      draw_text(200,index*24+48,140,24,value)
      draw_text(300,index*24+48,140,24,"Max reached")
      change_color(normal_color)
    else
      draw_icon(param_data[:icon],5,index*24+48)
      draw_text(29,index*24+48,Graphics.width-200,24,param_data[:vocab])
      draw_text(200,index*24+48,140,24,value)
      draw_text(390,index*24+48,140,24,"#{Distribute_Config::Price_Vocab} #{mul}")
      change_color(Distribute_Config::Green_Color)
      draw_text(300,index*24+48,140,24,value + 1)
      if Distribute_Config::Use_Arrow_Icon
        draw_icon(Distribute_Config::Arrow,250,index*24+48)
      else
        draw_right_arrow(250,index*24+48)
      end
      change_color(normal_color)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw right arrow
  #--------------------------------------------------------------------------
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 22, line_height, "→", 1)
  end
  #--------------------------------------------------------------------------
  # * Return to previous selection
  #--------------------------------------------------------------------------
  def select_last
    select(index)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height
    rect.y += 48
    rect
  end
end

class Window_DnDStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize
    super(0,fitting_height(1),Graphics.width-200,fitting_height(2))
  end
  #--------------------------------------------------------------------------
  # * Actor Position in Party
  #--------------------------------------------------------------------------
  def actor(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0,0,Graphics.width / 2,24,@actor.name)
    draw_text(150,0,Graphics.width / 2,24,@actor.class.name)
    draw_actor_hp(@actor,0,24)
    draw_actor_mp(@actor,150,24)
  end
end

class Window_DnDTitle < Window_Base
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize
    super(0,0,Graphics.width,fitting_height(1))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    draw_text(-10,0,Graphics.width,24,Distribute_Config::Top_Vocab,1)
  end
end

class Window_DnDPoints < Window_Base
  #--------------------------------------------------------------------------
  # * Public variable
  #--------------------------------------------------------------------------
  attr_accessor :actor
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
  end
  #--------------------------------------------------------------------------
  # * Actor Position in Party
  #--------------------------------------------------------------------------
  def actor(actor)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0,0,self.width,24,"#{Distribute_Config::Points_Vocab}#{@actor.points}")
  end
end

class Scene_DnD_Distribute < Scene_Base
  #--------------------------------------------------------------------------
  # * Initialization of the process
  #--------------------------------------------------------------------------
  def start
    super
    $game_party.members.each do |mem|
      if mem.id == Distribute_Config::Main_Actor
        @actor = mem
      end
    end
    create_all_windows
    get_actor_params
  end
  #--------------------------------------------------------------------------
  # * Initialization of the process
  #--------------------------------------------------------------------------
  def create_all_windows
    create_status_window
    create_points_window
    create_top_window
    create_param_list
    create_description_window
  end
  #--------------------------------------------------------------------------
  # * Screen refresh
  #--------------------------------------------------------------------------
  def update
    super
    @desc_window.id = @param_window.index
    @desc_window.set_text
  end
  #--------------------------------------------------------------------------
  # * Create hero data window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_DnDStatus.new
    @status_window.actor(@actor)
  end
  #--------------------------------------------------------------------------
  # * Create Top Window
  #--------------------------------------------------------------------------
  def create_top_window
    @top_window = Window_DnDTitle.new
  end
  #--------------------------------------------------------------------------
  # * Create Points Window
  #--------------------------------------------------------------------------
  def create_points_window
    wx = @status_window.width
    wy = @status_window.y
    wh = @status_window.height
    ww = Graphics.width - @status_window.width
    @points_window = Window_DnDPoints.new(wx,wy,ww,wh)
    @points_window.actor(@actor)
  end
  #--------------------------------------------------------------------------
  # * Create Hero Parameters List Window
  #--------------------------------------------------------------------------
  def create_param_list
    wx = 0
    wy = @points_window.y + @points_window.height
    wh = Graphics.height - @points_window.height - @top_window.height - 72
    @param_window = Window_DnDParams.new(wx,wy,wh)
    @param_window.actor(@actor)
    @param_window.set_handler(:cancel,method(:on_cancel))
    @param_window.set_handler(:pagedown, method(:next_actor))
    @param_window.set_handler(:pageup,   method(:prev_actor))
    get_actor_params
    @param_window.activate
    @param_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Create description window
  #--------------------------------------------------------------------------
  def create_description_window
    wx = 0
    wy = Graphics.height - 72
    ww = Graphics.width
    wh = Graphics.height - @param_window.height - @param_window.y
    @desc_window = Window_DnDDescription.new(wx,wy,ww,wh)
  end
  #--------------------------------------------------------------------------
  # * By confirming in the list
  #--------------------------------------------------------------------------
  def get_actor_params
    @set_params = []
    @set_params[0] = 0
    @set_params[1] = 0
    @set_params[2] = @actor.param_base(2) + @actor.param_dnd(2)
    @set_params[3] = @actor.param_base(3) + @actor.param_dnd(3)
    @set_params[4] = @actor.param_base(4) + @actor.param_dnd(4)
    @set_params[5] = @actor.param_base(5) + @actor.param_dnd(5)
    @set_params[6] = @actor.param_base(6) + @actor.param_dnd(6)
    @set_params[7] = @actor.param_base(7) + @actor.param_dnd(7)
  end
  #--------------------------------------------------------------------------
  # * By confirming in the list
  #--------------------------------------------------------------------------
  def on_increase_ok
    case @param_window.index
    when 0
      param_data = Distribute_Config::Human_Settings[0]
      param_id = 2
    when 1
      param_data = Distribute_Config::Human_Settings[1]
      param_id = 3
    when 2
      param_data = Distribute_Config::Human_Settings[2]
      param_id = 4
    when 3
      param_data = Distribute_Config::Human_Settings[3]
      param_id = 5
    when 4
      param_data = Distribute_Config::Human_Settings[4]
      param_id = 6
    when 5
      param_data = Distribute_Config::Human_Settings[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
      mul += param_data[:point_price] if (value >= pm) && (@actor.initial_points == true)
    end
    max = param_data[:max_value]
    max = 18 if @actor.initial_points == true
    if value >= max
      RPG::SE.new(Distribute_Config::Wrong_Select,80).play
      @param_window.activate
      @param_window.select_last
      @param_window.refresh
    else
      if @actor.points >= mul
        @actor.points -= mul
        @actor.add_param_dnd(param_id,1)
        bonus_check
        @param_window.activate
        @param_window.select_last
      else
        RPG::SE.new(Distribute_Config::Wrong_Select,80).play
        @param_window.activate
        @param_window.select_last
      end
    end
    @status_window.refresh
    @points_window.refresh
    @param_window.redraw_current_item
  end
  #--------------------------------------------------------------------------
  # * Set bonus for stat value
  #--------------------------------------------------------------------------
  def bonus_check
    scale = Distribute_Config::Bonus_Scale
    i = 2
    6.times do |pr|
      base = @actor.param_base(i) + @actor.param_dnd(i)
      @actor.set_param_dnd_bonus(i,scale[base])
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * By confirming in the list
  #--------------------------------------------------------------------------
  def on_decrease_ok
    case @param_window.index
    when 0
      param_data = Distribute_Config::Human_Settings[0]
      param_id = 2
    when 1
      param_data = Distribute_Config::Human_Settings[1]
      param_id = 3
    when 2
      param_data = Distribute_Config::Human_Settings[2]
      param_id = 4
    when 3
      param_data = Distribute_Config::Human_Settings[3]
      param_id = 5
    when 4
      param_data = Distribute_Config::Human_Settings[4]
      param_id = 6
    when 5
      param_data = Distribute_Config::Human_Settings[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
      mul += param_data[:point_price] if (value >= pm) && (@actor.initial_points == true)
    end
    if value <= @set_params[param_id]
      RPG::SE.new(Distribute_Config::Wrong_Select,80).play
      @param_window.activate
      @param_window.select_last
      @param_window.refresh
    else
      @actor.points += mul
      @actor.add_param_dnd(param_id,-1)
      bonus_check
      @param_window.activate
      @param_window.select_last
    end
    @status_window.refresh
    @points_window.refresh
    @param_window.redraw_current_item
  end
  #--------------------------------------------------------------------------
  # * When Updating
  #--------------------------------------------------------------------------
  alias r2_update_stats   update
  def update
    r2_update_stats
    if Input.repeat?(:RIGHT)
      on_increase_ok
    end
    if Input.repeat?(:LEFT)
      on_decrease_ok
    end
  end
  #--------------------------------------------------------------------------
  # * When connecting to the list
  #--------------------------------------------------------------------------
  def on_cancel
    continue = false
    $game_party.members.each do |act|
      if act.id == Distribute_Config::Main_Actor
        @mem = act
      end
    end
    if @mem.initial_points == true
      if @mem.points == 0
        @mem.initial_points = false if @mem.initial_points == true
      else
        continue = true
      end
    end
    if continue == false
      @actor.initial_points = false
      return_scene 
    else
      RPG::SE.new(Distribute_Config::Wrong_Select,80).play
      @param_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  def next_actor
    $game_party.members.each do |act|
      if act.id == Distribute_Config::Main_Actor
        @mem = act
      end
    end
    if @mem.initial_points == true
      if @mem.points == 0
        on_actor_change
      else
        @param_window.activate
      end
    else
      @actor = $game_party.menu_actor_next
      on_actor_change
    end
  end
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  def prev_actor
    $game_party.members.each do |act|
      if act.id == Distribute_Config::Main_Actor
        @mem = act
      end
    end
    if @mem.initial_points == true
      if @mem.points == 0
        on_actor_change
      else
        @param_window.activate
      end
    else
      @actor = $game_party.menu_actor_prev
      on_actor_change
    end
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @param_window.actor(@actor)
    @points_window.actor(@actor)
    @status_window.actor(@actor)
    @param_window.activate
    get_actor_params
    @actor.initial_points = false
  end
end

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Make Command List
  #--------------------------------------------------------------------------
  alias r2_custom_command   add_original_commands
  def add_original_commands
    r2_custom_command
    if Distribute_Config::Put_On_Menu
      add_dist_command
    end
  end
  #--------------------------------------------------------------------------
  # * Add Distribute Command
  #--------------------------------------------------------------------------
  def add_dist_command
    add_command(Distribute_Config::Menu_Vocab, :dndstat)
  end
end

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  alias r2_add_command_stat_dnd   create_command_window
  def create_command_window
    r2_add_command_stat_dnd
    if Distribute_Config::Put_On_Menu
      @command_window.set_handler(:dndstat,    method(:command_distribute))
    end
  end
  #--------------------------------------------------------------------------
  # * Individual Commands [Confirmation]
  #--------------------------------------------------------------------------
  def command_distribute
    case @command_window.current_symbol
    when :dndstat
      SceneManager.call(Scene_DnD_Distribute)
    end
  end
end

class Window_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)
    draw_text(x+40, y-12, 40, line_height, "Base")
    draw_text(x+85, y-12, 50, line_height, "Bonus")
    draw_text(x+140, y-12, 50, line_height, "Equip")
    draw_text(x+200, y-12, 50, line_height, "Total")
    6.times {|i| draw_actor_param(@actor, x, y + 12 + line_height * i, i + 2) }
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    base = actor.param_base(param_id) + actor.param_dnd(param_id)
    draw_text(x + 45, y, 36, line_height, base, 1)
    draw_text(x + 80, y, 10, line_height, "+", 1)
    bonus = actor.param_dnd_bonus(param_id)
    draw_text(x + 90, y, 36, line_height, bonus, 1)
    draw_text(x + 125, y, 10, line_height, "+", 1)
    equip = actor.param_plus(param_id)
    draw_text(x + 140, y, 36, line_height, equip, 1)
    draw_text(x + 190, y, 10, line_height, "=", 1)
    draw_text(x + 200, y, 36, line_height, actor.param(param_id), 1)
  end
end
