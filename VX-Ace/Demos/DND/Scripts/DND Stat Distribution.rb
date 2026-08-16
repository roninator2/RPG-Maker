# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: D&D Stat Distribution Character Create ║  Version: 1.08     ║
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
# ║ value to a max of 18 points, then up to a max of 30                ║
# ║ for each point assigned later. i.e. every 4 levels.                ║
# ║ Of course you can change it to whatever you want it to be          ║
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
# ║ Note: this script is intended to work with                         ║
# ║       R2 DnD Character Creation                                    ║
# ║       Stats cannot be applied until a race value                   ║
# ║       is given to the actor                                        ║
# ║                                                                    ║
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
# ║ 1.07 - 05 Dec 2023 - Adjusted for Additional Races                 ║
# ║ 1.08 - 14 Mar 2026 - Added Import Value                            ║
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

# Chart is based off stats starting at 5
# ╔══════════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╦════╗
# ║Attribute ║  6 ║  7 ║  8 ║  9 ║ 10 ║ 11 ║ 12 ║ 13 ║ 14 ║ 15 ║ 16 ║ 17 ║ 18 ║
# ╠══════════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╣
# ║Point Cost║ +1 ║ +1 ║ +1 ║ +1 ║ +1 ║ +1 ║ +1 ║ +1 ║ +1 ║ +2 ║ +2 ║ +3 ║ +3 ║
# ╠══════════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╬════╣
# ║  Total   ║  1 ║  2 ║  3 ║  4 ║  5 ║  6 ║  7 ║  8 ║  9 ║ 11 ║ 13 ║ 16 ║ 19 ║
# ╚══════════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╩════╝

module Distribute_Config
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
  Wrong_Select = "buzzer1"
  # Points each hero starts with when the race is applied
  Initial_Points = {
                    :human => 30,
                    :dwarf => 32,
                    :elf => 34,
                    }
  # Initial Max value for assigning stats
  # when first assigning points, stats can't higher than this
  Max_Initial_Value = {
                    :human => 18,
                    :dwarf => 19,
                    :elf => 20,
                    }
  # extra point awarded for racial abilities when race is sapplied
  # intended to work with R2 DnD Character creation script
  Race_Bonus = {
                :human => 0, 
                :dwarf => 2,
                :elf => 2,
                }
  # one point is gained when reaching a level that is evenly 
  # divided by the number below by race.
  Gain_Points = {
                  :human => 4,
                  :dwarf => 5,
                  :elf => 5,
                }
  # X position adjust for stat lines
  X_Offset = 50
  # Y position adjust for stat lines
  Y_Offset = 96
  #--------------------------------------------------------------------------
  # * Vocabulary
  #--------------------------------------------------------------------------
  # Vocabulary for price
  Price_Vocab = "Cost: "
  # Vocabulary of the top
  Top_Vocab = "Distribute Points"
  # Vocabulary points
  Points_Vocab = "Points Left: "
  # Vocabulary points total
  Points_Total = "Total Points: "
  # Vocabulary in the menu
  Menu_Vocab = "Assign Stats"
  # Command text for returning to stat screen
  Back_Command = "Back"
  # Command text for cancelling button press
  Cancel_Command = "Cancel"
  # Command for Next Actor
  Next_Command = "Save & Next Actor"
  # Command for Previous Actor
  Prev_Command = "Save & Prev Actor"
  # Confirm Command
  Confirm_Command = "Confirm"
  # Undo Command
  Undo_Command = "Revert Changes"
  # Text shown on stat screen to change points
  Change_Text = "Press left to decrease, Press right to increase."
  Change_Text2 = "Pageup & Down to change members"
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
  Arrow = 1 # use instead of drawn text arrow, will show icon
  Use_Arrow_Icon = true
  
  Race_Settings = {
    :human => {
  
	  0 => { # 2 = attack
	  vocab: "Strength",
	  icon: 3,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Stronger is better!"
	  },
	  
	  1 => { # 3 = Defense
	  vocab: "Dexterity",
	  icon: 4,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Avoid the attack is important, \nleast you fall in battle."
	  },
	  
	  2 => { # 4 = Magic Attack
	  vocab: "Constitution",
	  icon: 5,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Good health is long life!"
	  },
	  
	  3 => { # 5 = Magic Defense
	  vocab: "Wisdom",
	  icon: 6,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "The Power under your command is great!"
	  },
	  
	  4 => { # 6 = Agility
	  vocab: "Intelligence",
	  icon: 7,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Use magic to protect yourself, \nif you have the spells."
	  },
	  
	  5 => { # 7 = Luck
	  vocab: "Charisma",
	  icon: 8,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "How Charming can you be?\nWill they fall under your spell?"
	  },
	  },

    :dwarf => {
  
	  0 => { # 2 = attack
	  vocab: "Strength",
	  icon: 3,
	  base: 10,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Stronger is better!"
	  },
	  
	  1 => { # 3 = Defense
	  vocab: "Dexterity",
	  icon: 4,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Avoid the attack is important, \nleast you fall in battle."
	  },
	  
	  2 => { # 4 = Magic Attack
	  vocab: "Constitution",
	  icon: 5,
	  base: 10,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Good health is long life!"
	  },
	  
	  3 => { # 5 = Magic Defense
	  vocab: "Wisdom",
	  icon: 6,
	  base: 7,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "The Power under your command is great!"
	  },
	  
	  4 => { # 6 = Agility
	  vocab: "Intelligence",
	  icon: 7,
	  base: 7,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Use magic to protect yourself, \nif you have the spells."
	  },
	  
	  5 => { # 7 = Luck
	  vocab: "Charisma",
	  icon: 8,
	  base: 6,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "How Charming can you be?\nWill they fall under your spell?"
	  },
	  },

    :elf => {
  
	  0 => { # 2 = attack
	  vocab: "Strength",
	  icon: 3,
	  base: 6,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Stronger is better!"
	  },
	  
	  1 => { # 3 = Defense
	  vocab: "Dexterity",
	  icon: 4,
	  base: 10,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Avoid the attack is important, \nleast you fall in battle."
	  },
	  
	  2 => { # 4 = Magic Attack
	  vocab: "Constitution",
	  icon: 5,
	  base: 6,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Good health is long life!"
	  },
	  
	  3 => { # 5 = Magic Defense
	  vocab: "Wisdom",
	  icon: 6,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "The Power under your command is great!"
	  },
	  
	  4 => { # 6 = Agility
	  vocab: "Intelligence",
	  icon: 7,
	  base: 10,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Use magic to protect yourself, \nif you have the spells."
	  },
	  
	  5 => { # 7 = Luck
	  vocab: "Charisma",
	  icon: 8,
	  base: 8,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "How Charming can you be?\nWill they fall under your spell?"
	  },
	  },
  }
  
  #--------------------------------------------------------------------------
  # * End of configurations
  #--------------------------------------------------------------------------
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_ddsdcc] = 1.08       # D&D Stat Distribution Character Create

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
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public variable
  #--------------------------------------------------------------------------
  attr_accessor :race
  attr_accessor :points
  attr_accessor :param_dnd
  attr_accessor :initial_points
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias r2_actor_dist_ini initialize
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    r2_actor_dist_ini(actor_id)
    @race = :none
    @points = 0
    @param_dnd = [0] * 8
    @initial_points = true
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
    pnts = Distribute_Config::Gain_Points[@race.to_sym]
    return if pnts == nil
    if @level % pnts == 0
      @points += 1
    end
  end
end

class Window_DnDDescription < Window_Base
  #--------------------------------------------------------------------------
  # * Public variable
  #--------------------------------------------------------------------------
  attr_accessor :id
  attr_accessor :actor
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
  end
  #--------------------------------------------------------------------------
  # * Make text
  #--------------------------------------------------------------------------
  def set_actor=(actor)
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # * Make text
  #--------------------------------------------------------------------------
  def id=(id)
    @id = id
    refresh
  end
  #--------------------------------------------------------------------------
  # * Make text
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text_ex(0,0,Distribute_Config::Race_Settings[@actor.race][@id][:desc])
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
    race_data = Distribute_Config::Race_Settings[@actor.race.to_sym]
    case index
    when 0
      param_data = race_data[0]
      param_id = 2
    when 1
      param_data = race_data[1]
      param_id = 3
    when 2
      param_data = race_data[2]
      param_id = 4
    when 3
      param_data = race_data[3]
      param_id = 5
    when 4
      param_data = race_data[4]
      param_id = 6
    when 5
      param_data = race_data[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
        mul += param_data[:point_price] if (value >= pm) && (@actor.initial_points == true)
    end
    change = Distribute_Config::Change_Text
    draw_text(0,0,Graphics.width,24,change,1)
    change2 = Distribute_Config::Change_Text2
    draw_text(0,24,Graphics.width,24,change2,1)
    max = param_data[:max_value]
    max = Distribute_Config::Max_Initial_Value[@actor.race] if @actor.initial_points == true
    x_push = Distribute_Config::X_Offset
    y_push = Distribute_Config::Y_Offset
    if value >= max
      change_color(crisis_color)
      draw_icon(param_data[:icon],5+x_push,index*24+y_push)
      draw_text(30+x_push,index*24+y_push,Graphics.width-200,24,param_data[:vocab])
      draw_text(200+x_push,index*24+y_push,140,24,value)
      draw_text(300+x_push,index*24+y_push,140,24,"Max reached")
      change_color(normal_color)
    else
      draw_icon(param_data[:icon],5+x_push,index*24+y_push)
      draw_text(30+x_push,index*24+y_push,Graphics.width-200,24,param_data[:vocab])
      draw_text(200+x_push,index*24+y_push,140,24,value)
      draw_text(380+x_push,index*24+y_push,140,24,"#{Distribute_Config::Price_Vocab} #{mul}")
      change_color(Distribute_Config::Green_Color)
      draw_text(300+x_push,index*24+y_push,140,24,value + 1)
      if Distribute_Config::Use_Arrow_Icon
        draw_icon(Distribute_Config::Arrow,250+x_push,index*24+y_push)
      else
        draw_right_arrow(250+x_push,index*24+y_push)
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
    rect.y += Distribute_Config::Y_Offset
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
    draw_text(300,0,Graphics.width / 2,24,@actor.race.to_s.capitalize)
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
  # * Prepare Scene
  #--------------------------------------------------------------------------
  def prepare(actor)
    @actor = $game_party.members[actor]
    get_actor_params
  end
  #--------------------------------------------------------------------------
  # * Initialization of the process
  #--------------------------------------------------------------------------
  def start
    super
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
    if @desc_window.actor != @actor
      @desc_window.set_actor = @actor 
      @points_window.actor(@actor)
      @points_window.refresh
      @status_window.actor(@actor)
      @status_window.refresh
      @param_window.actor(@actor)
      @param_window.refresh
    end
    @desc_window.id = @param_window.index
  end
  #--------------------------------------------------------------------------
  # * Create hero data window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_DnDStatus.new
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
  end
  #--------------------------------------------------------------------------
  # * Create Hero Parameters List Window
  #--------------------------------------------------------------------------
  def create_param_list
    wx = 0
    wy = @points_window.y + @points_window.height
    wh = Graphics.height - @points_window.height - @top_window.height - 72
    @param_window = Window_DnDParams.new(wx,wy,wh)
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
    race_data = Distribute_Config::Race_Settings[@actor.race.to_sym]
    case @param_window.index
    when 0
      param_data = race_data[0]
      param_id = 2
    when 1
      param_data = race_data[1]
      param_id = 3
    when 2
      param_data = race_data[2]
      param_id = 4
    when 3
      param_data = race_data[3]
      param_id = 5
    when 4
      param_data = race_data[4]
      param_id = 6
    when 5
      param_data = race_data[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
      mul += param_data[:point_price] if (value >= pm) && (@actor.initial_points == true)
    end
    max = param_data[:max_value]
    max = Distribute_Config::Max_Initial_Value[@actor.race] if @actor.initial_points == true
    if value >= max
      RPG::SE.new(Distribute_Config::Wrong_Select,80).play
      @param_window.activate
      @param_window.select_last
      @param_window.refresh
    else
      if @actor.points >= mul
        @actor.points -= mul
        @actor.add_param(param_id,1)
        @actor.add_param_dnd(param_id,1)
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
  # * By confirming in the list
  #--------------------------------------------------------------------------
  def on_decrease_ok
    race_data = Distribute_Config::Race_Settings[@actor.race.to_sym]
    case @param_window.index
    when 0
      param_data = race_data[0]
      param_id = 2
    when 1
      param_data = race_data[1]
      param_id = 3
    when 2
      param_data = race_data[2]
      param_id = 4
    when 3
      param_data = race_data[3]
      param_id = 5
    when 4
      param_data = race_data[4]
      param_id = 6
    when 5
      param_data = race_data[5]
      param_id = 7
    end
    mul = 1
    value = @actor.param_base(param_id) + @actor.param_dnd(param_id)
    param_data[:change_price_level].each do |pm|
      mul += param_data[:point_price] if value > pm
    end
    if value <= @set_params[param_id]
      RPG::SE.new(Distribute_Config::Wrong_Select,80).play
      @param_window.activate
      @param_window.select_last
      @param_window.refresh
    else
      @actor.points += mul
      @actor.add_param(param_id,-1)
      @actor.add_param_dnd(param_id,-1)
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
    @continue = false
    if @actor.initial_points == true
      if @actor.points == 0
        @actor.initial_points = false if @actor.initial_points == true
      else
        @continue = true
      end
    end
    $game_party.members.each do |act|
      if act.initial_points == true
        @continue = true
      end
    end
    if @continue == false
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
    if @actor.initial_points == true
      if @actor.points == 0
        @actor.initial_points = false if @actor.initial_points == true
        @actor = $game_party.menu_actor_next
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
    if @actor.initial_points == true
      if @actor.points == 0
        @actor.initial_points = false if @actor.initial_points == true
        @actor = $game_party.menu_actor_prev
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
      @command_window.set_handler(:dndstat,    method(:command_personal))
    end
  end
  #--------------------------------------------------------------------------
  # * Individual Commands [Confirmation]
  #--------------------------------------------------------------------------
  alias r2_personal_command   on_personal_ok
  def on_personal_ok
    r2_personal_command
    case @command_window.current_symbol
    when :dndstat
      SceneManager.call(Scene_DnD_Distribute)
      SceneManager.scene.prepare(@status_window.index)
    end
  end
end
