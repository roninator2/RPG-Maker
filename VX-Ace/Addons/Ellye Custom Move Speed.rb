# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Custom Move Speed                      ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Script Function                             ║    25 Oct 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Adjust Move speed on different maps                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   A simple script made by Ellye.                                   ║
# ║   This is a free and unencumbered script,                          ║
# ║   provided "as is", no warranties.                                 ║
# ║   Modified by Roninator2                                           ║
# ║   Now allows to specify which maps have different speeds.          ║
# ║                                                                    ║
# ║   Configure the maps to set the speed on below                     ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Sep 2020 - Script finished                               ║
# ║ 1.00 - 25 Oct 2020 - Improved                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Ellye                                                            ║
# ║   A-Moonless-Night                                                 ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_Map_Speed
    # change the number to include the maps where your speed needs to be changed
MAP_SPEED = {:crawl => [2, 19, 20],
             :slow  => [3, 4, 5, 6],
#             :normal => [7, 8, 9, 10],
             :fast  => [11,12,13,14,15,16],
             :ultra => [1, 17, 18]
            }
SPEED_OFF = 4  # switch used to turn on map speed control above
#-------------------------------------------------------------------
# * Options:
#-------------------------------------------------------------------

# Base speed for every moving character. Default RPG Maker value is 4.
Base_character_speed = 4

# Player movement speed. Default RPG Maker value is 4.
Player_speed = 4

# Player dashing speed bonus. Default RPG Maker value is 1.
# You can also set a negative value, so that you'd have a
# "Walk / Sneaky Button" instead of a "Dash Button".
Dash_speed = 1

# Vehicules movement speed. Default RPG Maker values are 5, 6 and 7.
Boat_speed = 5
Ship_speed = 6
Airship_speed = 7

# when switch is on this will add to the speed when in a vehicle
Vehicle_bonus = 2

#----------------AMN add-on----------------------------
# I would have the vehicle speeds in their own hash with the vehicle's symbol.
# That way it's easier to set the vehicle's speed without having to check what
# the vehicle is first, and then it's also easy to add extra vehicle types if
# you had a script that added vehicle types.
# The preference is also to use all caps for constants.
VEHICLE_SPEEDS = {
  boat: 5,
  ship: 6,
  airship: 7,
}
#----------------AMN add-on----------------------------

end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

#-----------------AMN add-on-----------------------------------------
module DataManager
  # Alias the method for a module
  class << self; alias :r2_move_setup_new_game :setup_new_game; end
 
  def self.setup_new_game
    r2_move_setup_new_game
    # Set the player's speed for the first map
    $game_player.set_custom_move_speed($data_system.start_map_id)
  end
 
end

#--------------------------------------------------------------------

class Game_CharacterBase
  #Add custom movement speed to characters Init
  alias :old_init_public_members :init_public_members
  def init_public_members
    old_init_public_members
    @move_speed = R2_Map_Speed::Base_character_speed
  end

  #Add custom dash bonus speed
  alias :old_real_move_speed :real_move_speed
  def real_move_speed
    old_real_move_speed
    return @move_speed + (dash? ? R2_Map_Speed::Dash_speed : 0)
  end

end

class Game_Player
  #Add custom movement speed to player Init
  alias :old_initialize :initialize
  def initialize
    old_initialize
    @move_speed = R2_Map_Speed::Player_speed
  end
 
  #---------------AMN add-on------------------------------
  # It's better to not overwrite perform_transfer, especially since there isn't
  # anything that alters the @move_speed in there. Instead, get the value of
  # the new map ID and use that to get the move speed
  alias r2_move_perform_transfer  perform_transfer
  def perform_transfer
    if transfer? && @new_map_id != $game_map.map_id
      set_custom_move_speed(@new_map_id)
    end
    r2_move_perform_transfer
  end
 
  # Make a custom method for setting the move speed, since you'll use this more
  # than once across other methods
  def set_custom_move_speed(map_id)
    # find which key in the hash has a value that includes the map_id
    key = R2_Map_Speed::MAP_SPEED.find { |k, v| v.include?(map_id) }
    # set the key to the first element of the array if we found something before
    # if not, set it to the symbol :normal
    key = key ? key[0] : :normal
    # set the speed to the result of the switch statement (this is a neat thing
    # that you can do with switch statements—anything that reduces duplication
    # is a big bonus in programming). I think they're also a lot clearer to read
    # than lots of if statements
    speed = case key
    when :crawl then -2
    when :slow  then -1
    when :fast  then 1
    when :ultra then 2
    else 0 # this is a catch all for if the key doesn't exist or if it's :normal
    end
    @move_speed = R2_Map_Speed::Player_speed + speed
  end
 
  #The default get_off_vehicle method sets the player speed to 4...
  alias :old_get_off_vehicule :get_off_vehicle
  def get_off_vehicle
      old_get_off_vehicule
      #--------------AMN add-on--------------------------------
      set_custom_move_speed($game_map.map_id) if $game_switches[R2_Map_Speed::SPEED_OFF]
  end
end

class Game_Vehicle
  #Set custom Vehicle speeds
  alias r2_move_get_on_speed  get_on
  def get_on
    r2_move_get_on_speed
    
    #----AMN add-on------------------------------
    if R2_Map_Speed::VEHICLE_SPEEDS.key?(@type)
      @move_speed = R2_Map_Speed::VEHICLE_SPEEDS[@type]
    end
    if $game_switches[R2_Map_Speed::SPEED_OFF]
      @move_speed += R2_Map_Speed::Vehicle_bonus
    end
  end
end
