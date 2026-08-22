# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Character Creation for D&D Option 1    ║  Version: 1.07     ║
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
# ║ Classes database must have all classes for each race               ║
# ║   already setup. See the classes tab in this demo.                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Dec 2023 - Script finished                               ║
# ║ 1.01 - -- Dec 2023 - Made Changes                                  ║
# ║ 1.02 - -- Dec 2023 - Made Changes                                  ║
# ║ 1.03 - -- Dec 2023 - Made Changes                                  ║
# ║ 1.04 - 18 Jan 2024 - Added Features and changed proceses           ║
# ║ 1.05 - 19 Jan 2024 - Added Help Window for race and class          ║
# ║ 1.06 - 20 Jan 2024 - Made Help Window adjustable                   ║
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

module R2_DND_CHARACTER_CREATION
  # run this scene when starting a new game
  RUN_ON_START = false
  # How many lines to use for the help window
  HELP_LINES = 6
  # X position of the Help window
  HELP_X = 160
  # Y position of the Help Window
  HELP_Y = 150
  # Use note tags for description. false = Description below
  # Only applies to Classes not Races
  USE_NOTE = false
  # Seperator Colour
  SEP_COLOUR = Color.new(200,100,100,200)
  # Use seperator line
  USE_SEP = true
  # List of race options
  RACES = {
            :human => "Human",
            :dwarf => "Dwarf",
            :elf   => "Elf",
          }
  # Race Descriptions for help Window
  RACE_DESCRIPTION = {
            :human => "Your average life form that is very adapatable",
            :dwarf => "Smaller in size to a human, but is quite hardy",
            :elf   => "Tall and elegant, fitting for an intellectual life",
          }
  # Class Descriptions for help Window if USE_NOTE is false
  CLASS_DESCRIPTION = {
            :barbarian  => "Tough two handed fighter",
            :bard       => "Musician",
            :cleric     => "Fighter and healer",
            :druid      => "Tree hugger",
            :fighter    => "Average fighter",
            :monk       => "Spiritual Kick-Ass",
            :paladin    => "Holy Quest",
            :ranger     => "Have Bow, will travel",
            :rogue      => "Thanks for the gold!",
            :sorcerer   => "Explelliamous",
            :warlock    => "Where to build my tower?",
            :wizard     => "The fate of the world rests on me!",
          }
  # Class note tag search marker
  CLASS_REGEX = /<class[-_ ]text>(.*?)<\/class[-_ ]text>/imx
  # List of races that are locked by switch
  # all races here must also be included in the Races list above
  LOCKED_RACES = { # :race => switch id
            :elf   => 12,
          }
  # List of professions by race. Must match classes in the database
  JOBS = {
            :human  => {
                        :barbarian  => 2, # class id
                        :bard       => 3,
                        :cleric     => 4,
                        :druid      => 5,
                        :fighter    => 6, 
                        :monk       => 7,
                        :paladin    => 8,
                        :ranger     => 9,
                        :rogue      => 10,
                        :sorcerer   => 11,
                        :warlock    => 12,
                        :wizard     => 13,
                        },
            :dwarf  => {
                        :fighter  => 19,
                        :cleric   => 17,
                        },
            :elf    => {
                        :fighter  => 32,
                        :wizard   => 39,
                        :ranger   => 35,
                      },
          }
  # List of actors that can be selected for created a new character
  ACTOR_LIST = { 7 => "Rick",
                 2 => "Natalie",
                 4 => "Ernest",
                 5 => "Ryoma",
                 6 => "Brenda",
                 8 => "Alice",
                 9 => "Isabelle",
                 10 => "Noah",
              }
  # use these specific actors or the actor list in database
  SPECIFIC_ACTORS = true
  # commands text for command window
  COMMANDS = [
                "Create",
                "Delete",
                "Exit",
              ]
  # Confirm commands
  CONFIRM = [
              "Make it",
              "Not sure",
            ]
  # Confirm commands
  DELETE_CONFIRM = [
              "Remove Actor",
              "Cancel",
            ]
  # Maximum number of actors shown in the window
  MAX_SHOWN = 4
  # Text for title window
  TITLE_TEXT = "Character Creation Module"
  # Max number of members allowed in the party
  PARTY_SIZE = 8
  # Call name change scene after making a character
  CALL_NAME_CHANGE = true
  # How many characters to allow for a name
  NAME_SIZE = 8
  # Remove actors equipemnt when deleting
  REMOVE_EQUIP_ON_DELETE = true
end
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_ddcco1] = 1.07       # Character Creation for D&D Option 1

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * [New Game] Command
  #--------------------------------------------------------------------------
  alias r2_create_character_new_game  command_new_game
  def command_new_game
    r2_create_character_new_game
    SceneManager.call(Scene_Character_Create) if R2_DND_CHARACTER_CREATION::RUN_ON_START == true
    set_race
  end
  #--------------------------------------------------------------------------
  # * Set Race for Actors Already in the Party
  #--------------------------------------------------------------------------
  def set_race
    $game_party.members.each do |mem|
      next if mem.nil?
      cls = mem.class.id
      R2_DND_CHARACTER_CREATION::JOBS.each do |race, job|
        job.each do |prof, id|
          mem.race = race if id == cls
        end
      end
      update_stats(mem)
      mem.points = DISTRIBUTE_CONFIG::INITIAL_POINTS[mem.race]
      mem.points += DISTRIBUTE_CONFIG::RACE_BONUS[mem.race]
    end
  end
  #--------------------------------------------------------------------------
  # * Change Actor Stats
  #--------------------------------------------------------------------------
  def update_stats(actor)
    data = DISTRIBUTE_CONFIG::RACE_SETTINGS[actor.race]
    data.each_with_index do |prm, i|
      actor.change_param_base(i+2, prm[1][:base])
    end
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
    draw_text(0,0,self.width,24,R2_DND_CHARACTER_CREATION::TITLE_TEXT,1)
  end
  
end

#==============================================================================
# ** Window_Help
#==============================================================================

class Window_Character_Info_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = R2_DND_CHARACTER_CREATION::HELP_LINES)
    super(R2_DND_CHARACTER_CREATION::HELP_X, R2_DND_CHARACTER_CREATION::HELP_Y, width, fitting_height(line_number))
    self.back_opacity = 255 
    self.z = 120
    @text_desc = []
    @race = nil
  end
  #--------------------------------------------------------------------------
  # * Set Race
  #--------------------------------------------------------------------------
  def set_race(race)
    @race = race
    @text_desc = []
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text_desc and text != nil
      @text_desc = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    contents.clear
    set_text(:none)
  end
  #--------------------------------------------------------------------------
  # * Draw Horizontal Line
  #--------------------------------------------------------------------------
  def draw_horz_line(y)
    line_y = y + line_height / 2 - 1
    contents.fill_rect(0, line_y, contents_width, 2, R2_DND_CHARACTER_CREATION::SEP_COLOUR)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    @y = 0
    draw_text_ex(0, @y, @race)
    @y += line_height
    draw_horz_line(@y) if R2_DND_CHARACTER_CREATION::USE_SEP
    @y += line_height if R2_DND_CHARACTER_CREATION::USE_SEP
    @text_desc.each do |l|
      next if l == nil
      draw_text_ex(0, @y, word_wrapping(l))
      @y += line_height
    end
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def width
    Graphics.width - R2_DND_CHARACTER_CREATION::HELP_X
  end
  #--------------------------------------------------------------------------
  # * Word Wrapping
  #--------------------------------------------------------------------------
  def word_wrapping(text, pos = 0)
    # Current Text Position
    current_text_position = 0    
    for i in 0..(text.length - 1)
      if text[i] == "\n"
        current_text_position = 0
        next
      end
      # Current Position += character width
      current_text_position += contents.text_size(text[i]).width
      # If Current Position > Window Width
      if (pos + current_text_position) >= (contents.width)
        # Then Format the Sentence to fit Line
        current_element = i
        while(text[current_element] != " ")
          break if current_element == 0
          current_element -= 1
        end
        temp_text = ""
        for j in 0..(text.length - 1)
          temp_text += text[j]
          temp_text += "\n" if j == current_element
          @y += line_height if j == current_element
        end
        text = temp_text
        i = current_element
        current_text_position = 0
      end
    end
    return text
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
    @text = R2_DND_CHARACTER_CREATION::RACES[text]
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
  # * Draw Item
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
    race = R2_DND_CHARACTER_CREATION::RACES[actor.race]
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
    (height - standard_padding * 2) / R2_DND_CHARACTER_CREATION::MAX_SHOWN
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
    add_command(R2_DND_CHARACTER_CREATION::COMMANDS[0], :create, $game_party.members.size < R2_DND_CHARACTER_CREATION::PARTY_SIZE)
    add_command(R2_DND_CHARACTER_CREATION::COMMANDS[1], :delete, $game_party.members.size > 0)
    add_command(R2_DND_CHARACTER_CREATION::COMMANDS[2], :cancel)
  end
    
end

class Window_Character_Option < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    @race_list = []
    R2_DND_CHARACTER_CREATION::RACES.each do |key, value|
      if R2_DND_CHARACTER_CREATION::LOCKED_RACES.include?(key)
        add_command(value.to_s, key.to_sym) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
        @race_list.push(key) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
      else
        add_command(value.to_s, key.to_sym)
        @race_list.push(key)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    race = R2_DND_CHARACTER_CREATION::RACES[@race_list[self.index]]
    desc = R2_DND_CHARACTER_CREATION::RACE_DESCRIPTION[race]
    @help_window.set_race(race)
    @help_window.set_text(desc)
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
    @job_list = []
    @job_keys = []
    R2_DND_CHARACTER_CREATION::JOBS[@race].each do |key, value|
      cls = $data_classes[value].name
      @job_list.push(value)
      @job_keys.push(key)
      add_command(cls.to_s, key.to_sym)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @text = ""
    @text_desc = []
    if R2_DND_CHARACTER_CREATION::USE_NOTE
      if @race != :none
        @text_desc.push(@job_keys[self.index].capitalize.to_s)
        job = $data_classes[@job_list[self.index]]
        results = job.note.scan(R2_DND_CHARACTER_CREATION::CLASS_REGEX)
        results.each do |res|
          res[0].strip.split("\r\n").each do |line| 
            @text_desc.push("#{line}") 
          end
        end
      end
    else
      if @job_keys != nil
        @text_desc.push(@job_keys[self.index].capitalize.to_s)
        @text_desc.push(R2_DND_CHARACTER_CREATION::CLASS_DESCRIPTION[@job_keys[self.index]])
      end
    end
    @help_window.set_text(@text_desc)
  end
end

class Window_Character_Actors < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x,y)
    super(x,y)
    self.height = fitting_height(4)
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    if R2_DND_CHARACTER_CREATION::SPECIFIC_ACTORS == true
      R2_DND_CHARACTER_CREATION::ACTOR_LIST.each do |key, value|
        inc = true
        $game_party.members.each do |mem|
          next if mem.nil?
          inc = false if mem.id == key
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
    @face_window.set_face(R2_DND_CHARACTER_CREATION::ACTOR_LIST.keys[self.index])
  end
end

class Window_Character_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DND_CHARACTER_CREATION::CONFIRM[0], :confirm)
    add_command(R2_DND_CHARACTER_CREATION::CONFIRM[1], :cancel)
  end
  
end

class Window_Character_Delete_Confirm < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    super
    add_command(R2_DND_CHARACTER_CREATION::DELETE_CONFIRM[0], :confirm)
    add_command(R2_DND_CHARACTER_CREATION::DELETE_CONFIRM[1], :cancel)
  end
  
end

class Scene_Character_Create < Scene_Base
  
  #--------------------------------------------------------------------------
  # * Initialization of the process
  #--------------------------------------------------------------------------
  def start
    super
    create_title_window
    create_help_window
    create_command_window
    create_list_window
    create_option_window
    create_confirm_window
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
  # * Create Title Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Character_Info_Help.new
    @help_window.hide
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
    @option_window.help_window = @help_window
    @option_window.hide
    @option_window.deactivate
    race_list = []
    R2_DND_CHARACTER_CREATION::RACES.each do |key, value|
      if R2_DND_CHARACTER_CREATION::LOCKED_RACES.include?(key)
        race_list.push(key) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
      else
        race_list.push(key)
      end
    end
    race_list.each { |k| 
      @option_window.set_handler(k.to_sym, method(:option_confirm)) 
    }
    @option_window.set_handler(:cancel,   method(:option_cancel))
    @option_window.height = race_list.size * 24 + 24
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
    @actor_job_window.help_window = @help_window
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
    if R2_DND_CHARACTER_CREATION::SPECIFIC_ACTORS == true
      R2_DND_CHARACTER_CREATION::ACTOR_LIST.each do |key, value| 
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
    if $game_party.members.size >= R2_DND_CHARACTER_CREATION::PARTY_SIZE
      Sound.play_buzzer
      @command_window.activate
      return
    end
    @command_window.deactivate
    @help_window.show
    @option_window.show
    @option_window.activate
    @option_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Delete character command
  #--------------------------------------------------------------------------
  def command_delete
    @command_window.deactivate
    @list_window.top_row=(0)
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
      R2_DND_CHARACTER_CREATION::RACES.each do |key, value|
        if R2_DND_CHARACTER_CREATION::LOCKED_RACES.include?(key)
          race_list.push(key) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
        else
          race_list.push(key)
        end
      end
      race = race_list[@option_window.index]
      @race_window.set_text(race)
      R2_DND_CHARACTER_CREATION::JOBS[race].each do |k, i| 
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
    @help_window.hide
  end
  #--------------------------------------------------------------------------
  # * Confirm Create Character choice
  #--------------------------------------------------------------------------
  def create_confirm
    race_list = []
    R2_DND_CHARACTER_CREATION::RACES.each do |key, value|
      if R2_DND_CHARACTER_CREATION::LOCKED_RACES.include?(key)
        race_list.push(key) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
      else
        race_list.push(key)
      end
    end
    race = race_list[@option_window.index]
    pick = R2_DND_CHARACTER_CREATION::JOBS[race].keys
    job = pick[@actor_job_window.index]
    prof = R2_DND_CHARACTER_CREATION::JOBS[race][job]
    act_cls = $data_classes[prof]
    actor = nil
    if R2_DND_CHARACTER_CREATION::SPECIFIC_ACTORS == true
      id = R2_DND_CHARACTER_CREATION::ACTOR_LIST.keys[@actor_window.index]
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
    new_actor.points = DISTRIBUTE_CONFIG::INITIAL_POINTS[new_actor.race]
    bonus_points(new_actor)
    new_actor.recover_all
    @list_window.bottom_row=($game_party.members.size-1) if $game_party.members.size > 4
    @list_window.refresh
    @actor_window.refresh
    @command_window.refresh
    actor_cancel
    @confirm_window.deactivate
    @confirm_window.hide
    if R2_DND_CHARACTER_CREATION::CALL_NAME_CHANGE
      SceneManager.call(Scene_Name)
      SceneManager.scene.prepare(actor.id, R2_DND_CHARACTER_CREATION::NAME_SIZE)
    end
  end
  #--------------------------------------------------------------------------
  # * Cancel Create Character choice
  #--------------------------------------------------------------------------
  def create_cancel
    @confirm_window.deactivate
    @confirm_window.hide
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
  # * Confirm Delete choice
  #--------------------------------------------------------------------------
  def delete_confirm
    if R2_DND_CHARACTER_CREATION::REMOVE_EQUIP_ON_DELETE
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
    R2_DND_CHARACTER_CREATION::RACES.each do |key, value|
      if R2_DND_CHARACTER_CREATION::LOCKED_RACES.include?(key)
        race_list.push(key) if $game_switches[R2_DND_CHARACTER_CREATION::LOCKED_RACES[key]] == true
      else
        race_list.push(key)
      end
    end
    race = race_list[@option_window.index]
    prof = R2_DND_CHARACTER_CREATION::JOBS[race].keys
    slt = prof[@actor_job_window.index]
    pick = R2_DND_CHARACTER_CREATION::JOBS[race][slt]
    name = $data_classes[pick].name
    @job_window.set_text(name)
    @actor_job_window.deactivate
    @actor_job_window.hide
    @help_window.hide
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
    @help_window.hide
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
    bonus = DISTRIBUTE_CONFIG::RACE_BONUS[actor.race]
    actor.points += bonus
  end
  #--------------------------------------------------------------------------
  # * Change Actor Stats
  #--------------------------------------------------------------------------
  def update_stats(actor)
    data = DISTRIBUTE_CONFIG::RACE_SETTINGS[actor.race]
    data.each_with_index do |prm, i|
      actor.change_param_base(i+2, prm[1][:base])
    end
  end
end
