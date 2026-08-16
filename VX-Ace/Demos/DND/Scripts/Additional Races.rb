# ╔═════════════════════════════════════╦════════════════════╗
# ║ Title: D&D Additional Races         ║  Version: 1.00     ║
# ║ Author: Roninator2                  ║                    ║
# ╠═════════════════════════════════════╬════════════════════╣
# ║ Function:                           ║   Date Created     ║
# ║                                     ╠════════════════════╣
# ║   Allows to add additional races    ║    04 Dec 2023     ║
# ╚═════════════════════════════════════╩════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Requires: DnD Distribution Points by Roninator2          ║
# ║           DnD Character Creation by Roninator2           ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Adding Orc Race type to Config                           ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Instructions:                                            ║
# ║  Follow Parent script instructions                       ║
# ║                                                          ║
# ║  To use this for more races just change a few parts      ║
# ║  You can either copy and paste each section to add on    ║
# ║  more, or you can make a new script slot for each race.  ║
# ║  and copy this script into each slot, then change stuff  ║
# ║                                                          ║
# ║ Race_Settings[:orc] <- change to another name            ║
# ║    e.g. [:goblin]                                        ║
# ║   Change the stat parameters to that race's normal       ║
# ║                                                          ║
# ║ Race_Bonus[:orc] <- change to the same you changed above ║
# ║                                                          ║
# ║ Initial_Points[:orc] <- change to the same as above      ║
# ║                                                          ║
# ║ Max_Initial_Value[:orc] <- change to the same as above   ║
# ║                                                          ║
# ║ Gain_Points[:orc] <- change to same name as above        ║
# ║     Set the points for that race                         ║
# ║                                                          ║
# ║ In R2_DnD_Character_Creation                             ║
# ║   Races[:orc] = "Orc" <- Chnage to new race values       ║
# ║                                                          ║
# ║ Jobs[:orc] = {:fighter => "Fighter",                     ║
# ║               :cleric => "Cleric",                       ║
# ║              }                                           ║
# ║   Change to race name you're using and change the jobs   ║
# ║     that the new race is able to do.                     ║
# ║                                                          ║
# ║ All done. New race will show up when creating a character║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Updates:                                                 ║
# ║ 1.00 - 03 Dec 2023 - Script finished                     ║
# ╚══════════════════════════════════════════════════════════╝
# ╔══════════════════════════════════════════════════════════╗
# ║ Terms of use:                                            ║
# ║ Free for all uses in RPG Maker except nudity             ║
# ╚══════════════════════════════════════════════════════════╝

module Distribute_Config
  # Race Bonus
  Race_Bonus[:orc] = 5

  # one point is gained when reaching a level that is evenly 
  # divided by the number below by race.
  Gain_Points[:orc] = 4
  
  # Points each hero starts with when the race is applied
  Initial_Points[:orc] = 30
                    
  # Initial Max value for assigning stats
  Max_Initial_Value[:orc] = 22
                    
  # Race Settings
  Race_Settings[:orc] = {
  
	  0 => { # 2 = attack
	  vocab: "Strength",
	  icon: 3,
	  base: 12,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Stronger is better!"
	  },
	  
	  1 => { # 3 = Defense
	  vocab: "Dexterity",
	  icon: 4,
	  base: 6,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Avoid the attack is important, \nleast you fall in battle."
	  },
	  
	  2 => { # 4 = Magic Attack
	  vocab: "Constitution",
	  icon: 5,
	  base: 12,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "Good health is long life!"
	  },
	  
	  3 => { # 5 = Magic Defense
	  vocab: "Wisdom",
	  icon: 6,
	  base: 6,
	  point_price: 1,
	  change_price_level: [14,16],
	  max_value: 30,
	  desc: "The Power under your command is great!"
	  },
	  
	  4 => { # 6 = Agility
	  vocab: "Intelligence",
	  icon: 7,
	  base: 6,
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
  }
    
end

module R2_DnD_Character_Creation
  
  # Add race type here
  Races[:orc] = "Orc"
  # Professions for this race
  Jobs[:orc] = {:fighter => "Fighter",
                :cleric => "Cleric",
                }

end
