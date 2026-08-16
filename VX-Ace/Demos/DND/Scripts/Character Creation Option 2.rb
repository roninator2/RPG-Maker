# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Character Creation for D&D Option 2    ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Make characters for a D&D game              ║    05 Dec 2023     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: DnD distribution Points by Roninator2                    ║
# ║           Game resolution 640 x 480 or higher                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Make characters just like D&D games would do                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set value below to true if you want the scene                    ║
# ║   to automatically run when starting a new game.                   ║
# ║   If false then run command to call scene                          ║
# ║   SceneManager.call(Scene_Character_Create)                        ║
# ║                                                                    ║
# ║ Once you enter the scene you cannot leave unless                   ║
# ║   all characters are assigned a race                               ║
# ║   In case you add characters in the database.                      ║
# ║   They automatically start with :none for race.                    ║
# ║                                                                    ║
# ║ Configure the various settings to your preference                  ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Dec 2023 - Script finished                               ║
# ║ 1.01 - 19 Jan 2024 - Added Features and changed proceses           ║
# ║ 1.02 - 14 Mar 2026 - Added Import Value                            ║
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

module R2_DnD_Character_Creation
  # run this scene when starting a new game
  Run_On_Start = true
  # List of race options
  Races = {
            :human => "Human",
            :dwarf => "Dwarf",
            :elf   => "Elf",
          }
  # List of races that are locked by switch
  # all races here must also be included in the Races list above
  Locked_Races = { # :race => switch id
            :elf   => 12,
          }
  # List of professions by race. Must match classes in the database
  Jobs = {
            :human => {
                        :fighter  => "Fighter",
                        :wizard   => "Wizard",
                        :cleric   => "Cleric",
                        :paladin  => "Paladin",
                        :thief    => "Thief",
                      },
            :dwarf => {
                        :fighter  => "Fighter",
                        :cleric   => "Cleric",
                      },
            :elf => {
                      :fighter  => "Fighter",
                      :wizard   => "Wizard",
                      :ranger   => "Ranger",
                    },
          }
  # List of actors that can be selected for created a new character
  Actor_List = { 7 => "Rick",
                 2 => "Natalie",
                 4 => "Ernest",
                 5 => "Ryoma",
                 6 => "Brenda",
                 8 => "Alice",
                 9 => "Isabelle",
                 10 => "Noah",
              }
  # use these specific actors or the actor list in database
  Specific_Actors = true
  # commands text for command window
  Commands = [
                "Create",
                "Delete",
                "Assign Race",
                "Exit",
              ]
  # Confirm commands
  Confirm = [
              "Make it",
              "Not sure",
            ]
  # Confirm commands
  Change_Confirm = [
              "Set Race",
              "Cancel",
            ]
  # Confirm commands
  Delete_Confirm = [
              "Remove Actor",
              "Cancel",
            ]
  # Maximum number of actors shown in the window
  Max_Shown = 4
  # Text for title window
  Title_Text = "Character Creation Module"
  # Switch activated if the new game has anyone in the party
  Switch_Change = 10
  # Max number of members allowed in the party
  Party_Size = 8
  # Call name change scene after making a character
  Call_Name_Change = true
  # How many characters to allow for a name
  Name_Size = 8
  # Remove actors equipemnt when deleting
  Remove_Equip_on_Delete = true
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_ddcco2] = 1.02       # Character Creation for D&D Option 2

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * [New Game] Command
  #--------------------------------------------------------------------------
  alias r2_create_character_new_game  command_new_game
  def command_new_game
    r2_create_character_new_game
    $game_switches[R2_DnD_Character_Creation::Switch_Change] = true if $game_party.members.size > 0
    SceneManager.call(Scene_Character_Create) if R2_DnD_Character_Creation::Run_On_Start == true
  end
end

class Window_Character_Title < Window_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0,0,self.width,24,R2_DnD_Character_Creation::Title_Text,1)
  end
  
end

class Window_Character_Race < Window_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
    @text = ""
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def set_text(text)
    @text = R2_DnD_Character_Creation::Races[text]
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0,0,120,24, @text,1)
  end
  
end

class Window_Character_Job < Window_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
    @text = ""
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def set_text(text)
    @text = text
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_text(0,0,120,24, @text,1)
  end
  
end

class Window_Character_Face < Window_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x,y,width,height)
    super(x,y,width,height)
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def set_face(id)
    @id = id
    refresh
  end
  #--------------------------------------------------------------------------
  # * Renew content
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @actor = $data_actors[@id]
    draw_actor_face(@actor,0,0)
  end
  #--------------------------------------------------------------------------
  # * Call Help Window Update Method
  #--------------------------------------------------------------------------
  def call_update_help
    refresh if active
  end
end

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def change_param_base(param_id, value)
    self.class.params[param_id, @level] = value
  end
end

class Window_Character_List < Window_MenuStatus
  
  #--------------------------------------------------------------------------
  # * Initialization of the object
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @pending_index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 160
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    Graphics.height - 48
  end
  #--------------------------------------------------------------------------
  # * Drawing item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_face(actor, rect.x + 8, rect.y + 1, enabled)
    draw_actor_info(actor, rect.x + 130, rect.y + 1)
    draw_parameters(actor, rect.x + 240, rect.y + 1)
  end
  #--------------------------------------------------------------------------
  # * Drawing Actor Data
  #--------------------------------------------------------------------------
  def draw_actor_info(actor, x, y)
    draw_actor_name(actor, x, y + line_height * 0)
    draw_actor_class(actor, x, y + line_height * 1)
    change_color(system_color)
    draw_text(x, y + line_height * 2, 60, 24, "Race")
    race = R2_DnD_Character_Creation::Races[actor.race]
    change_color(normal_color)
    draw_text(x, y + line_height * 3, 72, 24, race)
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_parameters(actor,x, y)
    6.times {|i|
    j = i + 2
    if j.even?
      draw_actor_param(actor, x, y - 24 + line_height * (j / 2), j)
    else
      draw_actor_param(actor, x + x / 2, y -24 + line_height * (j / 2).to_i, j)
    end
    }
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 120, line_height, Vocab::param(param_id))
    change_color(normal_color)
    value = actor.param_base(param_id) + actor.param_dnd(param_id)
    draw_text(x + 36, y, 36, line_height, value, 2)
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    (height - standard_padding * 2) / R2_DnD_Character_Creation::Max_Shown
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    contents.dispose
    create_contents
    draw_all_items
  end
end

class Window_Character_Command < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DnD_Character_Creation::Commands[0], :create, $game_party.members.size < R2_DnD_Character_Creation::Party_Size)
    add_command(R2_DnD_Character_Creation::Commands[1], :delete, $game_party.members.size > 0)
    add_command(R2_DnD_Character_Creation::Commands[3], :cancel)
    add_command(R2_DnD_Character_Creation::Commands[2], :change) if $game_switches[R2_DnD_Character_Creation::Switch_Change] == true
  end
    
end

class Window_Character_Option < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    R2_DnD_Character_Creation::Races.each do |key, value|
      if R2_DnD_Character_Creation::Locked_Races.include?(key)
        add_command(value.to_s, key.to_sym) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
      else
        add_command(value.to_s, key.to_sym)
      end
    end
  end
 
end

class Window_Character_Classes < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x,y)
    @race = :none
    super(x,y)
  end
  #--------------------------------------------------------------------------
  # * Display Race for Actor
  #--------------------------------------------------------------------------
  def assign_race(value)
    @race = value
    refresh
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    return if @race == :none
    R2_DnD_Character_Creation::Jobs[@race].each do |key, value|
      add_command(value.to_s, key.to_sym)
    end
  end
 
end

class Window_Character_Actors < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x,y)
    self.height = fitting_height(3)
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    if R2_DnD_Character_Creation::Specific_Actors == true
      R2_DnD_Character_Creation::Actor_List.each do |key, value|
        inc = true
        $game_party.members.each do |mem|
          next if mem.nil?
          inc = false if mem.name.downcase == value.downcase
        end
        add_command(value.to_s, key, inc)
      end
    else
      $data_actors.each { |a| 
        next if a.nil?
        inc = true
        $game_party.members.each do |mem|
          next if mem.nil?
          inc = false if mem.name.downcase == a.name.downcase
        end
        add_command(a.name.to_s, a.id, inc)
      }
    end
  end
  #--------------------------------------------------------------------------
  # * Update Face Image
  #--------------------------------------------------------------------------
  def face_window=(face_window)
    @face_window = face_window
  end
  #--------------------------------------------------------------------------
  # * Call Help Window Update Method
  #--------------------------------------------------------------------------
  def call_update_help
    update_help if active && @face_window
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @face_window.set_face(R2_DnD_Character_Creation::Actor_List.keys[self.index])
  end
end

class Window_Character_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DnD_Character_Creation::Confirm[0], :confirm)
    add_command(R2_DnD_Character_Creation::Confirm[1], :cancel)
  end
  
end

class Window_Character_Create_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DnD_Character_Creation::Change_Confirm[0], :confirm)
    add_command(R2_DnD_Character_Creation::Change_Confirm[1], :cancel)
  end
  
end

class Window_Character_Delete_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DnD_Character_Creation::Delete_Confirm[0], :confirm)
    add_command(R2_DnD_Character_Creation::Delete_Confirm[1], :cancel)
  end
  
end

class Scene_Character_Create < Scene_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the process
  #--------------------------------------------------------------------------
  def start
    super
    create_title_window
    create_command_window
    create_list_window
    create_option_window
    create_confirm_window
    create_confirm_change_window
    create_delete_confirm_window
    create_race_window
    create_actor_job_window
    create_picked_job_window
    create_actor_face_window
    create_actor_window
  end
  #--------------------------------------------------------------------------
  # * Create Title Window
  #--------------------------------------------------------------------------
  def create_title_window
    @title_window = Window_Character_Title.new(0,0,Graphics.width,48)
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    y = @title_window.height
    @command_window = Window_Character_Command.new(0,y)
    @command_window.set_handler(:create, method(:command_create))
    @command_window.set_handler(:delete, method(:command_delete)) if $game_party.members.size > 0
    @command_window.set_handler(:cancel, method(:command_cancel))
    @command_window.set_handler(:change, method(:command_change)) if $game_switches[R2_DnD_Character_Creation::Switch_Change] == true
    @command_window.set_handler(:pagedown, method(:list_down))
    @command_window.set_handler(:pageup,   method(:list_up))
    @command_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Create Race Selected Window
  #--------------------------------------------------------------------------
  def create_race_window
    y = @command_window.y + @command_window.height
    @race_window = Window_Character_Race.new(0,y,160,48)
    @race_window.set_text(nil)
    @race_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Actor Face Window
  #--------------------------------------------------------------------------
  def create_actor_face_window
    y = Graphics.height - 120
    @face_window = Window_Character_Face.new(20,y,120,120)
    @face_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Actor List Window
  #--------------------------------------------------------------------------
  def create_list_window
    x = @command_window.width
    y = @title_window.y + @title_window.height
    @list_window = Window_Character_List.new(x,y)
    @list_window.set_handler(:ok,       method(:list_confirm))
    @list_window.set_handler(:cancel,   method(:list_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Race Option Window
  #--------------------------------------------------------------------------
  def create_option_window
    y = @command_window.y + @command_window.height
    @option_window = Window_Character_Option.new(0,y)
    @option_window.hide
    @option_window.deactivate
    race_list = []
    R2_DnD_Character_Creation::Races.each do |key, value|
      if R2_DnD_Character_Creation::Locked_Races.include?(key)
        race_list.push(key) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
      else
        race_list.push(key)
      end
    end
    race_list.each { |k| 
      @option_window.set_handler(k.to_sym, method(:option_confirm)) 
    }
    # R2_DnD_Character_Creation::Races.each { |k, i| 
      # @option_window.set_handler(k.to_sym, method(:option_confirm)) 
    # }
    @option_window.set_handler(:cancel,   method(:option_cancel))
    @option_window.height = R2_DnD_Character_Creation::Races.size * 24 + 24
  end
  #--------------------------------------------------------------------------
  # * Create Confirm Create Window
  #--------------------------------------------------------------------------
  def create_confirm_window
    y = @option_window.y + @option_window.height
    @confirm_window = Window_Character_Confirm.new(0,y)
    @confirm_window.hide
    @confirm_window.deactivate
    @confirm_window.set_handler(:confirm,  method(:create_confirm))
    @confirm_window.set_handler(:cancel,   method(:create_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Confirm Change Race Window
  #--------------------------------------------------------------------------
  def create_confirm_change_window
    y = @option_window.y + @option_window.height
    @change_window = Window_Character_Create_Confirm.new(0,y)
    @change_window.hide
    @change_window.deactivate
    @change_window.set_handler(:confirm,  method(:change_confirm))
    @change_window.set_handler(:cancel,   method(:change_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Delete Character Window
  #--------------------------------------------------------------------------
  def create_delete_confirm_window
    y = @command_window.y + @command_window.height
    @delete_confirm_window = Window_Character_Delete_Confirm.new(0,y)
    @delete_confirm_window.hide
    @delete_confirm_window.deactivate
    @delete_confirm_window.set_handler(:confirm,  method(:delete_confirm))
    @delete_confirm_window.set_handler(:cancel,   method(:delete_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create New Actor Class Window
  #--------------------------------------------------------------------------
  def create_actor_job_window
    y = @race_window.y + @race_window.height
    @actor_job_window = Window_Character_Classes.new(0,y)
    @actor_job_window.hide
    @actor_job_window.deactivate
    @actor_job_window.set_handler(:cancel,   method(:job_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Job Selected Window
  #--------------------------------------------------------------------------
  def create_picked_job_window
    y = @race_window.y + @race_window.height
    @job_window = Window_Character_Job.new(0,y,160,48)
    @job_window.set_text(nil)
    @job_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Actor Window
  #--------------------------------------------------------------------------
  def create_actor_window
    y = @actor_job_window.y + @actor_job_window.height + 24
    @actor_window = Window_Character_Actors.new(0,y)
    @actor_window.face_window = @face_window
    @actor_window.hide
    @actor_window.deactivate
    if R2_DnD_Character_Creation::Specific_Actors == true
      R2_DnD_Character_Creation::Actor_List.each do |key, value| 
        @actor_window.set_handler(key, method(:actor_confirm)) 
      end
    else
      $data_actors.each { |a| 
        next if a.nil?
        @actor_window.set_handler(a.id, method(:actor_confirm)) 
      }
    end
    @actor_window.set_handler(:cancel,   method(:actor_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create character command
  #--------------------------------------------------------------------------
  def command_create
    if $game_party.members.size >= R2_DnD_Character_Creation::Party_Size
      Sound.play_buzzer
      @command_window.activate
      return
    end
    @command_window.deactivate
    @option_window.show
    @option_window.activate
    @option_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Delete character command
  #--------------------------------------------------------------------------
  def command_delete
    @command_window.deactivate
    @list_window.activate
    @list_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Change race command
  #--------------------------------------------------------------------------
  def command_change
    if $game_switches[R2_DnD_Character_Creation::Switch_Change] == false
      Sound.play_buzzer
      @command_window.activate
      return
    end
    @command_window.deactivate
    @list_window.activate
    @list_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Cancel command - return
  #--------------------------------------------------------------------------
  def command_cancel
    $game_party.members.each do |mem|  
      if mem.race == :none
        Sound.play_buzzer
        @command_window.activate
        return
      end
    end
    if $game_party.members.size < 1
      Sound.play_buzzer
      @command_window.activate
      return
    end
    return_scene
  end
  #--------------------------------------------------------------------------
  # * Move character list down one
  #--------------------------------------------------------------------------
  def list_down
    @list_window.cursor_pagedown
    @list_window.refresh
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Move character list up one
  #--------------------------------------------------------------------------
  def list_up
    @list_window.cursor_pageup
    @list_window.refresh
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * confirm selection command
  #--------------------------------------------------------------------------
  def list_confirm
    case @command_window.index
    when 1 # delete
      @list_window.deactivate
      @delete_confirm_window.show
      @delete_confirm_window.activate
      @delete_confirm_window.select(0)
    when 3 # change race
      if $game_party.members[@list_window.index].race != :none
        Sound.play_buzzer
        @list_window.activate
        return
      end
      @list_window.deactivate
      @option_window.show
      @option_window.activate
      @option_window.select(0)
    else
      Sound.play_buzzer
      @list_window.deactivate
      @command_window.activate
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Cancel actor selection
  #--------------------------------------------------------------------------
  def list_cancel
    @list_window.unselect
    @list_window.deactivate
    @command_window.activate
    @selected_race = nil
    @job = nil
  end
  #--------------------------------------------------------------------------
  # * Confirm Race choice
  #--------------------------------------------------------------------------
  def option_confirm
    case @command_window.index
    when 0 # create
      race_list = []
      R2_DnD_Character_Creation::Races.each do |key, value|
        if R2_DnD_Character_Creation::Locked_Races.include?(key)
          race_list.push(key) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
        else
          race_list.push(key)
        end
      end
      race = race_list[@option_window.index]
      @race_window.set_text(race)
      R2_DnD_Character_Creation::Jobs[race].each do |k, i| 
        @actor_job_window.set_handler(k.to_sym, method(:job_confirm)) 
      end
      @actor_job_window.assign_race(race)
      @actor_job_window.height = Graphics.height - @actor_job_window.y - 24
      @option_window.hide
      @actor_job_window.show
      @actor_job_window.activate
      @actor_job_window.select(0)
      @race_window.show
      @list_window.deactivate
    when 3 # change race
      @change_window.show
      @change_window.activate
      @change_window.select(0)
    else
      Sound.play_buzzer
      @list_window.deactivate
      @command_window.activate
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Cancel Race choice
  #--------------------------------------------------------------------------
  def option_cancel 
    @option_window.unselect
    @option_window.hide
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Confirm Create Character choice
  #--------------------------------------------------------------------------
  def create_confirm
    race_list = []
    R2_DnD_Character_Creation::Races.each do |key, value|
      if R2_DnD_Character_Creation::Locked_Races.include?(key)
        race_list.push(key) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
      else
        race_list.push(key)
      end
    end
    race = race_list[@option_window.index]
    pick = R2_DnD_Character_Creation::Jobs[race].keys
    job = pick[@actor_job_window.index]
    prof = R2_DnD_Character_Creation::Jobs[race][job]
    act_cls = nil
    $data_classes.each do |cls|
      next if cls.nil?
      if cls.name.downcase == prof.downcase
        act_cls = RPG::Class.new
        act_cls = cls.deep_clone
        act_cls.id = $data_classes.size
        update_class(act_cls)
      end
    end
    $data_classes[$data_classes.size] = act_cls
    actor = nil
    if R2_DnD_Character_Creation::Specific_Actors == true
      id = R2_DnD_Character_Creation::Actor_List.keys[@actor_window.index]
      actor = $data_actors[id]
    else
      actor = $data_actors[@actor_window.index+1]
    end
    new_actor = nil
    $game_party.add_actor(actor.id)
    $game_party.members.each do |mem|
      new_actor = mem if mem.id == actor.id
    end
    new_actor.change_class(act_cls.id)
    new_actor.race = race
    update_stats(new_actor)
    new_actor.points = Distribute_Config::Initial_Points[new_actor.race]
    bonus_points(new_actor)
    new_actor.recover_all
    @list_window.bottom_row=($game_party.members.size-1) if $game_party.members.size > 4
    @list_window.refresh
    @actor_window.refresh
    @command_window.refresh
    @confirm_window.deactivate
    @confirm_window.hide
    if R2_DnD_Character_Creation::Call_Name_Change
      SceneManager.call(Scene_Name)
      SceneManager.scene.prepare(actor.id, R2_DnD_Character_Creation::Name_Size)
    end
    actor_cancel
  end
  #--------------------------------------------------------------------------
  # * Cancel Create Character choice
  #--------------------------------------------------------------------------
  def create_cancel
    @confirm_window.deactivate
    @confirm_window.hide
    actor_cancel
  end
  #--------------------------------------------------------------------------
  # * Confirm Change Race choice
  #--------------------------------------------------------------------------
  def change_confirm
    actor = $game_party.members[@list_window.index]
    race_list = []
    R2_DnD_Character_Creation::Races.each do |key, value|
      if R2_DnD_Character_Creation::Locked_Races.include?(key)
        race_list.push(key) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
      else
        race_list.push(key)
      end
    end
    actor.race = race_list[@option_window.index]
    update_stats(actor)
    actor.points = Distribute_Config::Initial_Points[actor.race]
    bonus_points(actor)
    $game_switches[R2_DnD_Character_Creation::Switch_Change] = false
    $game_party.members.each do |mem|  
      if mem.race == :none
        $game_switches[R2_DnD_Character_Creation::Switch_Change] = true
      end
    end
    @command_window.select(2) if $game_switches[R2_DnD_Character_Creation::Switch_Change] == false
    @list_window.refresh
    @list_window.unselect
    @command_window.refresh
    @option_window.hide
    @command_window.activate
    @change_window.deactivate
    @change_window.hide
  end
  #--------------------------------------------------------------------------
  # * Cancel Change Race choice
  #--------------------------------------------------------------------------
  def change_cancel
    @change_window.deactivate
    @change_window.hide
    @option_window.activate
  end
  #--------------------------------------------------------------------------
  # * Confirm Delete choice
  #--------------------------------------------------------------------------
  def delete_confirm
    if R2_DnD_Character_Creation::Remove_Equip_on_Delete
      actor = $game_party.members[@list_window.index]
      actor.clear_equipments
    end
    $game_party.remove_actor($game_party.members[@list_window.index].id)
    @list_window.unselect
    @list_window.refresh
    @actor_window.refresh
    @delete_confirm_window.deactivate
    @delete_confirm_window.hide
    @command_window.activate
    @command_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Delete Actor Cancel
  #--------------------------------------------------------------------------
  def delete_cancel
    @delete_confirm_window.deactivate
    @delete_confirm_window.hide
    @list_window.activate
  end
  #--------------------------------------------------------------------------
  # * Confirm Profession choice
  #--------------------------------------------------------------------------
  def job_confirm
    race_list = []
    R2_DnD_Character_Creation::Races.each do |key, value|
      if R2_DnD_Character_Creation::Locked_Races.include?(key)
        race_list.push(key) if $game_switches[R2_DnD_Character_Creation::Locked_Races[key]] == true
      else
        race_list.push(key)
      end
    end
    race = race_list[@option_window.index]
    prof = R2_DnD_Character_Creation::Jobs[race].keys
    slt = prof[@actor_job_window.index]
    pick = R2_DnD_Character_Creation::Jobs[race][slt]
    @job_window.set_text(pick)
    @actor_job_window.deactivate
    @actor_job_window.hide
    @job_window.show
    @actor_window.show
    @actor_window.activate
    @face_window.show
  end
  #--------------------------------------------------------------------------
  # * Cancel Job Selection
  #--------------------------------------------------------------------------
  def job_cancel
    @actor_job_window.deactivate
    @actor_job_window.hide
    @job_window.hide
    @race_window.hide
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Confirm Profession choice
  #--------------------------------------------------------------------------
  def actor_confirm
    @actor_window.deactivate
    @actor_window.hide
    @confirm_window.show
    @confirm_window.activate
    @confirm_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Cancel Job Selection
  #--------------------------------------------------------------------------
  def actor_cancel
    @actor_window.deactivate
    @actor_window.hide
    @actor_job_window.deactivate
    @actor_job_window.hide
    @race_window.hide
    @job_window.hide
    @face_window.hide
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Apply Bonus points to actor
  #--------------------------------------------------------------------------
  def bonus_points(actor)
    bonus = Distribute_Config::Race_Bonus[actor.race]
    actor.points += bonus
  end
  #--------------------------------------------------------------------------
  # * Change Actor Stats
  #--------------------------------------------------------------------------
  def update_stats(actor)
    data = Distribute_Config::Race_Settings[actor.race]
    data.each_with_index do |prm, i|
      actor.change_param_base(i+2, prm[1][:base])
    end
  end
  #--------------------------------------------------------------------------
  # * Update Classes file
  #--------------------------------------------------------------------------
  def update_class(act_cls)
    dataclass = load_data('Classes/Classes.rvdata2')
    dataclass[dataclass.size] = act_cls
    File.open('Classes/Classes.rvdata2', 'w') do |file|
      Marshal.dump(dataclass, file)
    end
  end
end

class Object
  def deep_clone
    return @deep_cloning_obj if @deep_cloning
    @deep_cloning_obj = clone
    @deep_cloning_obj.instance_variables.each do |var|
      val = @deep_cloning_obj.instance_variable_get(var)
      begin
        @deep_cloning = true
        val = val.deep_clone
      rescue TypeError
        next
      ensure
        @deep_cloning = false
      end
      @deep_cloning_obj.instance_variable_set(var, val)
    end
    deep_cloning_obj = @deep_cloning_obj
    @deep_cloning_obj = nil
    deep_cloning_obj
  end
end
