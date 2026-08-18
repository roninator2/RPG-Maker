# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Spell Charge System Standalone         ║  Version: 1.03     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║  Set system to use Spell Charges              ║    06 Feb 2024     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║ Recreates the spell charge system like Final Fantasy 1             ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Configure settings Below                                         ║
# ║   Configure Actors and Classes for FF1 style play                  ║
# ║     i.e. fighters don't use skills or spells.                      ║
# ║   Specify how many charges each class has at what levels           ║
# ║                                                                    ║
# ║ Addional instructions are found below                              ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 12 Feb 2024 - Script finished                               ║
# ║ 1.01 - 12 Feb 2024 - Cleaned up code                               ║
# ║ 1.02 - 14 Feb 2024 - Combined shop code and battle code            ║
# ║ 1.03 - 14 Mar 2026 - Added Import Value                            ║
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

#==============================================================================
# ** Vocab
#==============================================================================
module Vocab
  
  # Spell Screen
  Spell         = "Magic"
  Drop_spell    = "Remove Spell"
  Use_Spell     = "Use Spell"
  Exit_Spell    = "Exit"
  Confirm_Drop  = "Are you sure?"
  Cancel_Drop   = "Return"
  # Spell Shop Screen
  Spell_Buy     = "Buy"
  Spell_Cancel  = "Exit"
  Shop_Title    = "Welcome to my Magic Shop"
  Not_Usable    = "This cannot be used by you"
  Spells_Full   = "Your spells are full"
  Spell_Owned   = "You already have this spell"
  # Spell Battle Screen - Actor Command
  Battle_Spell = "Magic"

end

#==============================================================================
# ** Spell Charge
#==============================================================================
module Spell_Charge
  # specify to use the chart below or the note tags further down
  USE_CHART = true
  
  # Chart used to specify what spell charges each class will have and 
  # how many charges at the actors level
  CHART = {
           :C1 => { # class 1 - Fighter
                 # spell level
                        # levels 1 2 3 4 5... to 28
                        # levels 29 30 31 32.. to 50 
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C2 => { # class 2 - Thief
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C3 => { # class 3 - Monk
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C4 => { # class 4 - Red Mage
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,7,7,8,9,9,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,4,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,5,6,6,6,6,6,
                        6,6,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,
                        3,3,3,3,4,4,5,5,5,6,6,6,6,6,6,7,7,7,7,7,8,8],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
                },
           :C5 => { # class 5 - White Mage
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,
                        7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,
                        6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,
                        3,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,9]
                },
           :C6 => { # class 6 - Black Mage
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,
                        7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,
                        6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,
                        3,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,9]
                },
           :C7 => { # class 7 - Knight
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,
                        3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,
                        2,2,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,
                        1,1,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C8 => { # class 8 - Ninja
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,
                        3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,
                        2,2,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,
                        1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C9 => { # class 9 - Master
                :L1 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L2 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L3 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L4 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                },
           :C10 => { # class 10 - Red Wizard
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,
                        7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,
                        6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,
                        3,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,9]
                },
           :C11 => { # class 11 - White Wizard
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,
                        7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,
                        6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,
                        3,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,9]
                },
           :C12 => { # class 12 - Black Wizard
                :L1 => [2,3,3,4,4,4,5,5,5,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,
                        9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L2 => [0,1,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,6,6,6,7,7,7,7,8,
                        8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9],
                :L3 => [0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,6,7,7,
                        7,7,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9],
                :L4 => [0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,
                        7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9],
                :L5 => [0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,4,5,5,5,5,5,6,6,
                        6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,9,9,9,9],
                :L6 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,5,5,5,5,
                        5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9],
                :L7 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,3,3,4,4,4,
                        5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9],
                :L8 => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,3,
                        3,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,9]
                },
        }
#==============================================================================
# ** Spell Options
#==============================================================================
  module Options
    
    # Recover Spell uses on leveling up
    RECOVER_SPELLS_ON_LEVEL_UP = false
    
    # Recover Spell uses on leveling up
    SHOW_SPELLS_ON_ALL = false
    
    # Specify if your game will use this magic system 
    # and the default skill system. true or false
    INCLUDE_SKILLS = false
    
    # the below options are for the regex system
    
    # maximum number of spells you can use per tier i.e. 9 for FF1
    # this is the heart of the spell charge system
    # 9 means you can use that tier's spells 9 times
    MAX_SPELLS = 9 # global for all magic users
    
    # maximum number of tiers that each magic user will have
    MAX_TIERS = 8 # global for all magic users
    
    # maximum number of spells that can be learned for each tier. i.e. 3 for FF1
    MAX_PER_LEVEL = 3 # global for all magic users
    
    # time to wait before message window disappears
    MESSAGE_WAIT = 160
    
  end
  
#==============================================================================
# ** Shop Options
#==============================================================================
    # ╔══════════════════════════════════════════════════════════╗
    # ║ Shop Setup:                                              ║
    # ║                                                          ║
    # ║ To create a skill shop, you'll need to do a script call  ║
    # ║   Step 1. Under the event commands, choose tab 3         ║
    # ║      then under advanced choose Script.                  ║
    # ║   Step 2. In the script window, you'll need to enter     ║
    # ║                                                          ║
    # ║      goods = [35,36,37,38]                               ║
    # ║      SceneManager.call(Scene_Spell_Shop)                 ║
    # ║      SceneManager.scene.prepare(goods)                   ║
    # ║                                                          ║
    # ║   Description of goods                                   ║
    # ║      goods = [3, 4, 5, 6] <= skill id numbers            ║
    # ║                                                          ║
    # ╚══════════════════════════════════════════════════════════╝
  module Shop
    # maximum number of party members in Image Window
    MAX_PARTY = 4
    
  end
  
#==============================================================================
# ** Regex Method
#==============================================================================
  module Regex
    
    # ╔══════════════════════════════════════════════════════════╗
    # ║ Instructions:                                            ║
    # ║                                                          ║
    # ║ Note tags                                                ║
    # ║   Skills                                                 ║
    # ║     <spell level: 1>                                     ║
    # ║       Will make the skill as a level 1 skill             ║
    # ║                                                          ║
    # ║   Class                                                  ║
    # ║    <spell gain: spell level, starting actor level,       ║
    # ║                gain amount, every # levels>              ║
    # ║      <spell gain: 1, 1, 1, 3>                            ║
    # ║        Will mark the actor as learning 1 additional      ║
    # ║        level one spell charge every 3 levels             ║
    # ║        starting from level 1                             ║
    # ║                                                          ║
    # ║    <spell bonus: spell level, amount>                    ║
    # ║      <spell bonus: 1, 2>                                 ║
    # ║      <spell bonus: 2, 1>                                 ║
    # ║      You do not need to use a tag for no bonus added     ║
    # ║      Will mark the actor as starting with 2 uses         ║
    # ║      of the level 1 spells                               ║
    # ║    This is a bonus to the spell gain.                    ║
    # ║    At level one the player will get 3 spell uses for     ║
    # ║    level 1 as shown.                                     ║
    # ║      <spell start: 1, 2> + <spell gain: 1, 1, 1, 3>      ║
    # ║                       ▲                       ▲          ║
    # ║    Spell level 1 will have 2 + 1 uses                    ║
    # ║                                                          ║
    # ╚══════════════════════════════════════════════════════════╝
    # Skill notetag
    # <spell tier: 1> # for Ff1 there are 8 spell tiers (levels)
    SPELL_LEVEL = /<spell[ -_]level:[ -_](\d+)>/i
    
    # How fast new spell uses are earned
    # NOTE - Place on class or actor
    # <spell gain: spell tier, actor level, gain amount, every # levels>
    # <spell gain:      1,           1,           1,          4>
    # <spell gain: 1, 1, 1, 4>
    SPELL_GAIN = /<spell[ -_]gain:[ -_](\d+),[ -_](\d+),[ -_](\d+),[ -_](\d+)>/i
    
    # How many uses to have when starting a new game
    # NOTE - Place on class or actor
    # <spell bonus: spell level, amount>
    # <spell bonus:      1,        2>
    # <spell bonus: 1, 2>
    SPELL_BONUS = /<spell[ -_]bonus:[ ](\d+),[ -_](\d+)>/i
    # This must go below the spell gain note tag
    
  end
  
#==============================================================================
# ** Spell Settings
#==============================================================================
  module Spell
    # ╔══════════════════════════════════════════════════════════╗
    # ║ Instructions:                                            ║
    # ║                                                          ║
    # ║ Note tags                                                ║
    # ║   Skills                                                 ║
    # ║     <spell level: 1>                                     ║
    # ║       Will make the skill a level 1 spell                ║
    # ║                                                          ║
    # ║     <spell cost: 100>                                    ║
    # ║       Will make the spell cost 100 gold to buy           ║
    # ║                                                          ║
    # ║     <class learn: class id, class id...>                 ║
    # ║       will specify what classes can learn the spell      ║
    # ║                                                          ║
    # ╚══════════════════════════════════════════════════════════╝
    
    # Skill notetag
    # <spell user: true> # specify if the class can use spells
    # combines with SHOW_SPELLS_ON_ALL. if a magic user, spell count is shown
    SPELL_USER = /<spell[ -_]user:[ -_](\w*)>/i
    
    # Skill notetag
    # <spell cost: 100> # specify the cost to buy the skill
    SPELL_COST = /<spell[ -_]cost:[ -_](\d+)>/i
    
    # Skill notetag
    # <class learn: 4, 5, 7, 10, 11> # specify what classes can learn the skill
    CLASS_LEARN = /<class[ -_]learn:([ -_](\d+)(?:|(,[ -_])(\d+))*)>/i
    
    # Skill notetag
    # <spell level: 1> # spell tier (level)
    SPELL_LEVEL = /<spell[ -_]level:[ -_](\d+)>/i
    
  end
end
# ╔══════════════════════════════════════════════════════════╗
# ║              End of Editable section                     ║
# ╚══════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_scsstand] = 1.03           # Spell Charge System Standalone

#==============================================================================
# * DataManager
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # alias method: load_database
  #--------------------------------------------------------------------------
  class <<self; alias load_database_spellclass load_database; end
  def self.load_database
    load_database_spellclass
    initialize_spellclass
  end
  #--------------------------------------------------------------------------
  # new method: initialize_spellgroup
  #--------------------------------------------------------------------------
  def self.initialize_spellclass
    groups = [$data_classes, $data_skills]
    for group in groups
      for obj in group
        next if obj.nil?
          obj.initialize_spellclass
      end
    end
  end
end

#==============================================================================
# * RPG::BaseItem
#==============================================================================
class RPG::Skill < RPG::UsableItem
  attr_accessor :spell_tier
  attr_accessor :spell_cost
  attr_accessor :spell_level
  attr_accessor :class_learn
  #--------------------------------------------------------------------------
  # new method: initialize_spellgroup
  #--------------------------------------------------------------------------
  def initialize_spellclass
    @spell_tier = 0
    @spell_cost = 0
    @spell_level = 0
    @class_learn = []
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Spell_Charge::Regex::SPELL_LEVEL
        @spell_tier = $1.to_i
      when Spell_Charge::Spell::SPELL_COST
        @spell_cost = $1.to_i
      when Spell_Charge::Spell::SPELL_LEVEL
        @spell_level = $1.to_i
      when Spell_Charge::Spell::CLASS_LEARN
        @class_learn = $1.split(/,\s*/).collect {|item| item.to_i }
      end
    }
  end
end

#==============================================================================
# ** Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Determine Skill/Item Usability
  #--------------------------------------------------------------------------
  def skill_purchase?(item)
    return true if item.class_learn.include?(self.class_id)
    return false
  end
end

#==============================================================================
# * Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Determine if Cost of Using Skill Can Be Paid
  #--------------------------------------------------------------------------
  def skill_cost_payable?(skill)
    if self.is_a?(Game_Actor)
      case skill.spell_tier
      when 1..Spell_Charge::Options::MAX_TIERS
        return true if self.spell_count[skill.spell_tier] > 0
        return false if self.spell_count[skill.spell_tier] <= 0
      else
        tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
      end
    else
      tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * Pay Cost of Using Skill
  #--------------------------------------------------------------------------
  def pay_skill_cost(skill)
    if self.is_a?(Game_Actor)
      case skill.spell_tier
      when 1..Spell_Charge::Options::MAX_TIERS
        self.spell_count[skill.spell_tier] -= 1
      else
        self.mp -= skill_mp_cost(skill)
        self.tp -= skill_tp_cost(skill)
      end
    else
      self.mp -= skill_mp_cost(skill)
      self.tp -= skill_tp_cost(skill)
    end
  end
end

#==============================================================================
# * RPG::Class
#==============================================================================
class RPG::Class < RPG::BaseItem
  attr_accessor :spell_gain
  attr_accessor :spell_bonus
  attr_reader :spell_user
  #--------------------------------------------------------------------------
  # new method: initialize_spellgroup
  #--------------------------------------------------------------------------
  def initialize_spellclass
    @spell_gain = []
    @spell_bonus = []
    @spell_user = false
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when Spell_Charge::Regex::SPELL_GAIN
        @spell_gain[$1.to_i] = [$2.to_i, $3.to_i, $4.to_i]
      when Spell_Charge::Regex::SPELL_BONUS
        @spell_bonus[$1.to_i] = $2.to_i
      when Spell_Charge::Spell::SPELL_USER
        @spell_user = $1.downcase == "true" ? true : false
      end
    }
  end
end

#==============================================================================
# ** Game_Actor
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :spell_gain
  attr_accessor :spell_count
  attr_accessor :spell_list
  attr_accessor :spell_max_count
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias r2_actor_spells_setup   setup
  def setup(actor_id)
    @spell_max_count = []
    @spell_count = []
    @spell_list = {}
    r2_actor_spells_setup(actor_id)
    setup_spells
  end
  #--------------------------------------------------------------------------
  # * Add Actor Spell Counts
  #--------------------------------------------------------------------------
  def setup_spells
    if Spell_Charge::USE_CHART
      chart_spells
      @spell_gain = nil
    else
      add_new_spell_count
    end
  end
  #--------------------------------------------------------------------------
  # * Learn Spell
  #--------------------------------------------------------------------------
  def learn_spell(skill_id)
    spell = $data_skills[skill_id]
    return unless spell_learn?(spell)
    lvl = spell.spell_level
    if @spell_list[lvl].nil?
      @spell_list[lvl] = []
    end
    tier = @spell_list[lvl].size
    @spell_list[lvl].push(skill_id) if tier != Spell_Charge::Options::MAX_PER_LEVEL
  end
  #--------------------------------------------------------------------------
  # * Determine if Spell Is Already Learned
  #--------------------------------------------------------------------------
  def spell_learn?(spell)
    can_learn = spell.class_learn
    return false if !can_learn.include?(self.class_id)
    if @spell_list[spell.spell_level].nil?
      return true if spell.is_a?(RPG::Skill)
    else
      return true if spell.is_a?(RPG::Skill) && 
      !@spell_list[spell.spell_level].include?(spell.id)
    end
  end
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  alias :r2_recover_all_spells  :recover_all
  def recover_all
    r2_recover_all_spells
    restore_spells(true)
  end
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias :r2_level_up_recover_spells   :level_up
  def level_up
    r2_level_up_recover_spells
    restore_spells(false)
  end
  #--------------------------------------------------------------------------
  # * Restore spells
  #--------------------------------------------------------------------------
  def restore_spells(restore)
    return if actor.nil?
    current_count = []
    current_count = Marshal.load( Marshal.dump(@spell_count) )
    if Spell_Charge::USE_CHART
      chart_spells
    else
      add_new_spell_count
    end
    @spell_count = Marshal.load( Marshal.dump(current_count) ) if !Spell_Charge::Options::RECOVER_SPELLS_ON_LEVEL_UP
    @spell_count = Marshal.load( Marshal.dump(@spell_max_count) ) if restore
  end
  #--------------------------------------------------------------------------
  # * Chart spells
  #--------------------------------------------------------------------------
  def chart_spells
    sp_cls = "C#{self.class_id}".to_sym
    chart_list = Spell_Charge::CHART[sp_cls]
    i = 1
    chart_list.each do |key, value|
      @spell_count[i] = value[self.level - 1]
      @spell_max_count[i] = value[self.level - 1]
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Change Maximum spell count for using note tags
  #--------------------------------------------------------------------------
  def add_new_spell_count
    gain = $data_classes[self.class_id].spell_gain
    bonus = $data_classes[self.class_id].spell_bonus
    (Spell_Charge::Options::MAX_TIERS + 1).times { |ch| bonus[ch] = 0 if bonus[ch].nil? }
    gain.each_with_index do |data, i|
      next if data.nil?
      @spell_max_count[i] = 0 if @spell_count[i] == nil
      next if data[0] > self.level
      # do math
      gnamt = 0
      gnamt = ((self.level - data[0]) / data[2]).to_i if self.level > data[0]
      addsp = gnamt * data[1]
      addsp += 1 if self.level >= data[0]
      amt = (bonus[i] + addsp)
      amt = Spell_Charge::Options::MAX_SPELLS if amt >= Spell_Charge::Options::MAX_SPELLS
      @spell_max_count[i] = amt
    end
  end
end

#==============================================================================
# ** Window_MenuStatus
#==============================================================================
class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Draw Spell Charges
  #--------------------------------------------------------------------------
  def draw_spell_charge(actor, x, y, width = 124)
    if Spell_Charge::Options::SHOW_SPELLS_ON_ALL
      change_color(system_color)
      draw_text(x, y, 60, line_height, "Spells")
      change_color(normal_color)
      cls_id = actor.class_id
      spells = ""
      actor.spell_count.each_with_index do |sp, i|
        next if i == 0
        spells += sp.to_s
        spells += "/" if i != actor.spell_count.size - 1
      end
      draw_text(x+60, y, 170, line_height, spells)
    else
      return unless actor.class.spell_user
      change_color(system_color)
      draw_text(x, y, 60, line_height, "Spells")
      change_color(normal_color)
      cls_id = actor.class_id
      spells = ""
      actor.spell_count.each_with_index do |sp, i|
        next if i == 0
        spells += sp.to_s
        spells += "/" if i != actor.spell_count.size - 1
      end
      draw_text(x+60, y, 170, line_height, spells)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 120, y)
    draw_actor_hp(actor, x + 120, y + line_height * 1, 210)
    draw_spell_charge(actor, x + 120, y + line_height * 2)
  end
end

#==============================================================================
# ** Window_Spell_List
#==============================================================================

class Window_Spell_List < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super
    @actor = nil
    @data = []
    @drop = false
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    @actor ? Spell_Charge::Options::MAX_PER_LEVEL : 3
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    if Spell_Charge::USE_CHART
      @data ? col_max * Spell_Charge::Options::MAX_TIERS : 0
    else
      @data ? col_max * (@actor.spell_count.size - 1) : 0
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    (width - 100 - standard_padding * 2 + spacing) / col_max - spacing - 10
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    return nil if @index < 0
    lvl = (@index / 3).to_i
    ind = @index % 3
    item = @data[lvl][ind] if @data[lvl] != nil
    spell = $data_skills[item] if item != nil
  end
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    @actor ? @actor.spell_count.size - 1 : Spell_Charge::Options::MAX_TIERS
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return false if @index < 0
    lvl = (@index / 3).to_i
    ind = @index % 3
    item = @data[lvl][ind] if @data[lvl] != nil
    spell = $data_skills[item] if item != nil
    return false if spell.nil?
    enable?(spell)
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def include?(item)
    return true
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true if @drop
    @actor && @actor.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * remove spell from actor list
  #--------------------------------------------------------------------------
  def drop_spell
    lvl = (@index / 3).to_i
    ind = @index % 3
    @actor.spell_list[lvl].delete_at(ind)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def all_select
    @drop = true
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def no_select
    @drop = false
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor ? @actor.spell_list : []
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw skill levels
  #--------------------------------------------------------------------------
  def draw_spell_tier(i)
    spells = @actor.spell_list[i]
    return if spells == nil
    Spell_Charge::Options::MAX_PER_LEVEL.times do |s|
      num = spells[s]
      next if num.nil?
      spell = $data_skills[num]
      rect = spell_rect(i, s)
      rect.width -= 4
      rect.x += 60
      draw_item_name(spell, rect.x, rect.y, enable?(spell))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name, 1)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def spell_rect(i, s)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = s % col_max * (item_width + spacing)
    rect.y = i / row_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Draw spell
  #--------------------------------------------------------------------------
  def draw_spell_levels(size)
    y = 0
    size.times do |i|
      text = "LEVEL: #{i+1}"
      draw_text(0, y, 100, 24, text)
      y += 24
    end
  end
  #--------------------------------------------------------------------------
  # * Draw skill count per level
  #--------------------------------------------------------------------------
  def draw_spell_count(size)
    y = 0
    change_color(normal_color)
    size.times do |i|
      text = "#{@actor.spell_count[i+1]}"
      draw_text(Graphics.width - 45, y, 40, 24, text)
      y += 24
    end
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    size = @actor.spell_count.size - 1
    draw_spell_levels(size)
    @actor ? size.times { |i| draw_spell_tier(i) } : nil
    draw_spell_count(size)
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    return if @index < 0
    lvl = (@index / 3).to_i
    ind = @index % 3
    item = @data[lvl][ind] if @data[lvl] != nil
    spell = $data_skills[item] if item != nil
    @help_window.set_item(spell)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
      cursor_rect.x += 100
    end
  end
end


#==============================================================================
# ** Window_MenuCommand
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Add Main Commands to List
  #--------------------------------------------------------------------------
  def add_main_commands
    add_command(Vocab::item,   :item,   main_commands_enabled)
    add_command(Vocab::Spell,  :spell,  main_commands_enabled)
    add_command(Vocab::skill,  :skill,  main_commands_enabled) if Spell_Charge::Options::INCLUDE_SKILLS
    add_command(Vocab::equip,  :equip,  main_commands_enabled)
    add_command(Vocab::status, :status, main_commands_enabled)
  end
end

#==============================================================================
# ** Scene_Menu
#==============================================================================
class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  alias :r2_scene_spell_command   :create_command_window
  def create_command_window
    r2_scene_spell_command
    @command_window.set_handler(:spell,     method(:command_personal))
  end
  #--------------------------------------------------------------------------
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  alias :r2_personal_ok_spell_scene   :on_personal_ok
  def on_personal_ok
    r2_personal_ok_spell_scene
    case @command_window.current_symbol
    when :spell
      SceneManager.call(Scene_Spell)
    end
  end
end

#==============================================================================
# ** Window_SpellCommand
#==============================================================================

class Window_SpellCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 160
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return 4
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_command(Vocab::Use_Spell,   :use)
    add_command(Vocab::Drop_spell,  :drop)
    add_command(Vocab::Exit_Spell,  :cancel)
  end
end

#==============================================================================
# ** Window_SpellStatus
#==============================================================================

class Window_SpellStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 160
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Spell Charges
  #--------------------------------------------------------------------------
  def draw_spell_charge(actor, x, y, width = 124)
    if Spell_Charge::Options::SHOW_SPELLS_ON_ALL
      change_color(system_color)
      draw_text(x, y, 60, line_height, "Spells")
      change_color(normal_color)
      cls_id = actor.class_id
      spells = ""
      actor.spell_count.each_with_index do |sp, i|
        next if i == 0
        spells += sp.to_s
        spells += "/" if i != actor.spell_count.size - 1
      end
      draw_text(x+60, y, 170, line_height, spells)
    else
      return unless actor.class.spell_user
      change_color(system_color)
      draw_text(x, y, 60, line_height, "Spells")
      change_color(normal_color)
      cls_id = actor.class_id
      spells = ""
      actor.spell_count.each_with_index do |sp, i|
        next if i == 0
        spells += sp.to_s
        spells += "/" if i != actor.spell_count.size - 1
      end
      draw_text(x+60, y, 170, line_height, spells)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 120, y)
    draw_actor_hp(actor, x + 120, y + line_height * 1, 210)
    draw_spell_charge(actor, x + 120, y + line_height * 2)
  end
end

#==============================================================================
# ** Window Confirm Drop Spell
#==============================================================================
class Window_Confirm_Drop_Spell < Window_Command
  def initialize
    super(0, 0)
    self.back_opacity = 255
    move_window
  end
  
  def window_width
    return 200
  end
  
  def move_window
    self.x = (Graphics.width - width) / 2
    self.y = Graphics.height / 2
  end
  
  def update_help
  end
  
  def make_command_list
    add_command(Vocab::Confirm_Drop, :on_drop_ok)
    add_command(Vocab::Cancel_Drop, :on_drop_cancel)
  end
  
  def alignment
    return 1
  end
end

#==============================================================================
# ** Scene_Skill
#==============================================================================

class Scene_Spell < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_command_window
    create_status_window
    create_item_window
    create_confirm_window
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    wy = @help_window.height
    @command_window = Window_SpellCommand.new(0, wy)
    @command_window.viewport = @viewport
    @command_window.help_window = @help_window
    @command_window.actor = @actor
    @command_window.set_handler(:use,    method(:command_use))
    @command_window.set_handler(:drop,    method(:command_drop))
    @command_window.set_handler(:cancel,   method(:return_scene))
    @command_window.set_handler(:pagedown, method(:next_actor))
    @command_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    y = @help_window.height
    @status_window = Window_SpellStatus.new(@command_window.width, y)
    @status_window.viewport = @viewport
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wx = 0
    wy = @status_window.y + @status_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_window = Window_Spell_List.new(wx, wy, ww, wh)
    @item_window.actor = @actor
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Confirm Window
  #--------------------------------------------------------------------------
  def create_confirm_window
    @confirm_window = Window_Confirm_Drop_Spell.new
    @confirm_window.z = 201
    @confirm_window.hide.deactivate
    @confirm_window.set_handler(:ok,     method(:on_drop_ok))
    @confirm_window.set_handler(:cancel, method(:on_drop_cancel))
  end
  #--------------------------------------------------------------------------
  # * Get Skill's User
  #--------------------------------------------------------------------------
  def user
    @actor
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  def command_use
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * [Skill] Command
  #--------------------------------------------------------------------------
  def command_drop
    @item_window.activate
    @item_window.all_select
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @actor.last_skill.object = item
    case @command_window.index
    when 0
      determine_item
    when 1
      @confirm_window.show
      @confirm_window.activate
      @confirm_window.select(0)
    end
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * spell [OK]
  #--------------------------------------------------------------------------
  def on_drop_ok
    @item_window.no_select
    @item_window.drop_spell
    @confirm_window.deactivate
    @confirm_window.hide
    @item_window.refresh
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * spell [Cancel]
  #--------------------------------------------------------------------------
  def on_drop_cancel
    @item_window.no_select
    @confirm_window.deactivate
    @confirm_window.hide
    @item_window.refresh
    @item_window.activate
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_skill
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @status_window.refresh
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @command_window.actor = @actor
    @status_window.actor = @actor
    @item_window.actor = @actor
    @command_window.activate
  end
end

#==============================================================================
# ** Window_Spell_Group
#==============================================================================

class Window_Spell_Group < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    @text = ""
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def group(text)
    if text != @text
      @text = text.to_s
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * window_width
  #--------------------------------------------------------------------------
  def window_width
    160
  end
  #--------------------------------------------------------------------------
  # * window_height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(1)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Window_Spell_Title
#==============================================================================

class Window_Spell_Title < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 1)
    super(0, 0, Graphics.width - 160, fitting_height(line_number))
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    text = Vocab::Shop_Title
    draw_text(0, 0, contents.width, 24, text, 1)
  end
end

#==============================================================================
# ** Window_Spell_Message
#==============================================================================

class Window_Spell_Message < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 1)
    @text = ""
    super(Graphics.width / 4, Graphics.height / 2, window_width, fitting_height(line_number))
    @timer = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Window Width
  #--------------------------------------------------------------------------
  def window_width
    @text.size * 12
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      @timer = 0
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
    refresh
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    @timer += 1 if @timer >= 0
    if @timer >= Spell_Charge::Options::MESSAGE_WAIT
      set_text("")
      self.hide
      @timer = -1
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.width = window_width
    contents.clear
    contents.dispose
    create_contents
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Window_Spell_Help
#==============================================================================

class Window_Spell_Help < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(line_number = 1)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  #--------------------------------------------------------------------------
  # * Set Text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_text(item ? item.description : "")
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end

#==============================================================================
# ** Window_SpellCommand
#------------------------------------------------------------------------------
#  This window is for selecting buy/sell on the shop screen.
#==============================================================================

class Window_SpellShopCommand < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(window_width)
    @window_width = window_width
    super(0, 0)
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    @window_width
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::Spell_Buy,    :buy)
    add_command(Vocab::Spell_Cancel, :cancel)
  end
end

#==============================================================================
# ** Window_ClassStatus
#==============================================================================

class Window_ClassStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, wh)
    super(x, y, window_width, wh)
    @item = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    200
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_class_use
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def item=(item)
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Draw classes that can use spell
  #--------------------------------------------------------------------------
  def draw_class_use
    return if @item.nil?
    y = 0
    @item.class_learn.each do |id|
      act_cls = $data_classes[id]
      draw_text(0, y, 160, 24, act_cls.name, 1)
      y += 24
    end
  end
end # Window_ClassStatus

#==============================================================================
# ** Window_SpellBuy
#==============================================================================

class Window_SpellBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :class_window            # Status window
  attr_reader   :image_window            # Status window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(y, w, h, shop_goods)
    super(0, y, w, h)
    @shop_goods = shop_goods
    @money = 0
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data[index]
  end
  #--------------------------------------------------------------------------
  # * Set Party Gold
  #--------------------------------------------------------------------------
  def money=(money)
    @money = money
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Get Price of Item
  #--------------------------------------------------------------------------
  def price(item)
    @price[item]
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    item && price(item) <= @money
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      item = $data_skills[goods] if goods != nil
      if item
        @data.push(item)
        @price[item] = item.spell_cost
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)
  end
  #--------------------------------------------------------------------------
  # * Set Status Window
  #--------------------------------------------------------------------------
  def class_window=(class_window)
    @class_window = class_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Status Window
  #--------------------------------------------------------------------------
  def image_window=(image_window)
    @image_window = image_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item) if @help_window
    @class_window.item = item if @class_window
    @image_window.item = item if @image_window
  end
end # Window_SpellBuy

#==============================================================================
# ** Window_ImageStatus
#==============================================================================

class Window_ImageStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @index = -1
    @walk = 0
    @page_index = 0
    @animtime = 0
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return page_size
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def item=(item)
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    return if @item.nil?
    make_actor_list
    page_size.times do |i|
      draw_party(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Create Actor List
  #--------------------------------------------------------------------------
  def make_actor_list
    @data = status_members
  end
  #--------------------------------------------------------------------------
  # * Draw Quantity Possessed
  #--------------------------------------------------------------------------
  def draw_party(i)
    x = i * (item_width + spacing) + 84
    rect = Rect.new(x, 40, 48, 48)
    return if @data[i].nil?
    draw_actor_graphic(@data[i], rect.x, rect.y, @data[i].skill_purchase?(@item))
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return Graphics.width / page_size - item_width - page_size * 4
  end
  #--------------------------------------------------------------------------
  # * Number of Actors Displayable at Once
  #--------------------------------------------------------------------------
  def page_size
    return Spell_Charge::Shop::MAX_PARTY
  end
  #--------------------------------------------------------------------------
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def contents_width
    Graphics.width - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Pages
  #--------------------------------------------------------------------------
  def page_max
    ($game_party.members.size + page_size - 1) / page_size
  end
  #--------------------------------------------------------------------------
  # * Array of Actors for Which to Draw Equipment Information
  #--------------------------------------------------------------------------
  def status_members
    $game_party.members[@page_index * page_size, page_size]
  end
  #--------------------------------------------------------------------------
  # * Overwrite: draw_character
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index, x, y, ani = false)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    step = 0
    step = @walk if ani
    src_rect = Rect.new((n%4*3+1+step)*cw, (n/4*4)*ch, cw, ch)
    contents.blt(x - cw / 2, y - ch, bitmap, src_rect, ani ? 255 : translucent_alpha)
  end
  #--------------------------------------------------------------------------
  # * Overwrite: draw_actor_graphic
  #--------------------------------------------------------------------------
  def draw_actor_graphic(actor, x, y, ani = false)
    draw_character(actor.character_name, actor.character_index, x, y, ani)
  end
  #--------------------------------------------------------------------------
  # * New Method: ani_motion
  #--------------------------------------------------------------------------
  def ani_motion
    @animtime += 1
    if @animtime == 10
      case @walk
      when 1; @walk -= 1
      when -1; @walk += 1
      when 0
        if @step == 1
          @walk = -1
          @step = 0
        else
          @walk = 1
          @step = 1
        end
      end
      refresh
      @animtime = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    ani_motion
  end
  #--------------------------------------------------------------------------
  # * Update Page
  #--------------------------------------------------------------------------
  def update_page
    if visible && Input.trigger?(:A) && page_max > 1
      @page_index = (@page_index + 1) % page_max
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    48
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    48
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    item_height
  end
  #--------------------------------------------------------------------------
  # * Get Leading Digits
  #--------------------------------------------------------------------------
  def top_col
    ox / (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Set Leading Digits
  #--------------------------------------------------------------------------
  def top_col=(col)
    col = 0 if col < 0
    col = col_max - 1 if col > col_max - 1
    self.ox = col * (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # * Get Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col
    top_col + col_max - 1
  end
  #--------------------------------------------------------------------------
  # * Set Trailing Digits
  #--------------------------------------------------------------------------
  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_col = index if index < top_col
    self.bottom_col = index if index > bottom_col
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Displaying Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.x = index * (item_width + spacing) + 60
    rect.y = 0
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
end # Window_ImageStatus

#==============================================================================
# ** Spell_Shop
#==============================================================================

class Scene_Spell_Shop < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Prepare
  #--------------------------------------------------------------------------
  def prepare(goods, shop)
    @goods = goods
    @shop = shop
  end
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_spell_class_window
    create_title_window
    create_gold_window
    create_command_window
    create_help_window
    create_class_window
    create_image_window
    create_buy_window
    create_msg_window
  end
  #--------------------------------------------------------------------------
  # * Create Spell Class Window
  #--------------------------------------------------------------------------
  def create_spell_class_window
    @spell_class_window = Window_Spell_Group.new
    @spell_class_window.viewport = @viewport
    @spell_class_window.x = Graphics.width - @spell_class_window.width
    @spell_class_window.group(@shop)
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_title_window
    @title_window = Window_Spell_Title.new
    @title_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_msg_window
    @msg_window = Window_Spell_Message.new
    @msg_window.viewport = @viewport
    @msg_window.z = 210
    @msg_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Gold Window
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @spell_class_window.height
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    ww = Graphics.width - @gold_window.width
    @command_window = Window_SpellShopCommand.new(ww)
    @command_window.viewport = @viewport
    @command_window.y = @title_window.height
    @command_window.set_handler(:buy,    method(:command_buy))
    @command_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Spell_Help.new
    @help_window.viewport = @viewport
    @help_window.y = @command_window.y + @command_window.height
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_class_window
    wy = @help_window.y + @help_window.height
    wh = Graphics.height - @help_window.y - @help_window.height - 72
    @class_window = Window_ClassStatus.new(0, wy, wh)
    @class_window.viewport = @viewport
    @class_window.x = Graphics.width - @class_window.width
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_image_window
    wy = Graphics.height - 72
    ww = Graphics.width
    wh = 72
    @image_window = Window_ImageStatus.new(0, wy, ww, wh)
    @image_window.viewport = @viewport
    @image_window.set_handler(:ok,     method(:on_image_ok))
    @image_window.set_handler(:cancel, method(:on_image_cancel))
  end
  #--------------------------------------------------------------------------
  # * Create Purchase Window
  #--------------------------------------------------------------------------
  def create_buy_window
    wy = @help_window.y + @help_window.height
    ww = Graphics.width - @class_window.width
    wh = Graphics.height - @help_window.height - @help_window.y - @image_window.height
    @buy_window = Window_SpellBuy.new(wy, ww, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.class_window = @class_window
    @buy_window.image_window = @image_window
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end
  #--------------------------------------------------------------------------
  # * Activate Purchase Window
  #--------------------------------------------------------------------------
  def command_buy
    @buy_window.money = money
    @buy_window.show.activate
    @buy_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Buy [OK]
  #--------------------------------------------------------------------------
  def on_buy_ok
    @item = @buy_window.item
    @image_window.activate
    @image_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Buy [Cancel]
  #--------------------------------------------------------------------------
  def on_buy_cancel
    @buy_window.unselect
    @image_window.item = nil
    @class_window.item = nil
    @command_window.activate
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  def on_image_ok
    index = @image_window.index
    act = $game_party.members[index]
    not_usable = true
    buy = false
    if act.skill_purchase?(@item)
      not_usable = false
      buy = true
      if act.spell_list[@item.spell_level] != nil
        buy = false if act.spell_list[@item.spell_level].include?(@item.id)
        buy = false if act.spell_list[@item.spell_level].size == Spell_Charge::Options::MAX_PER_LEVEL
      end
    else
      Sound.play_buzzer
      @image_window.activate
    end
    if buy
      $game_party.lose_gold(@item.spell_cost)
      @gold_window.refresh
      act.learn_spell(@item.id)
      @image_window.activate
    else
      if not_usable
        @msg_window.set_text(Vocab::Not_Usable)
        @msg_window.show
        @image_window.activate
      else
        if act.spell_list[@item.spell_level].size == Spell_Charge::Options::MAX_PER_LEVEL
          @msg_window.set_text(Vocab::Spells_Full)
          @msg_window.show
          @image_window.activate
        else
          @msg_window.set_text(Vocab::Spell_Owned)
          @msg_window.show
          @image_window.activate
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Actor [Cancel]
  #--------------------------------------------------------------------------
  def on_image_cancel
    @image_window.unselect
    @image_window.deactivate
    @buy_window.activate
  end
  #--------------------------------------------------------------------------
  # * Get Party Gold
  #--------------------------------------------------------------------------
  def money
    @gold_window.value
  end
  #--------------------------------------------------------------------------
  # Get Currency Unit
  #--------------------------------------------------------------------------
  def currency_unit
    @gold_window.currency_unit
  end
  #--------------------------------------------------------------------------
  # * Get Purchase Price
  #--------------------------------------------------------------------------
  def buying_price
    @buy_window.price(@item)
  end
end

#==============================================================================
# ** Window_ActorCommand
#==============================================================================

class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_attack_command
    add_spell_command
    add_skill_commands if Spell_Charge::Options::INCLUDE_SKILLS
    add_guard_command
    add_item_command
  end
  #--------------------------------------------------------------------------
  # * Add Magic Command to List
  #--------------------------------------------------------------------------
  def add_spell_command
    add_command(Vocab::Battle_Spell, :spell)
  end
end

#==============================================================================
# ** Window_BattleSpell
#==============================================================================

class Window_BattleSpell < Window_Spell_List
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     info_viewport : Viewport for displaying information
  #--------------------------------------------------------------------------
  def initialize(help_window, info_viewport)
    y = help_window.height
    super(0, y, Graphics.width, info_viewport.rect.y - y)
    self.visible = false
    @help_window = help_window
    @info_viewport = info_viewport
  end
  #--------------------------------------------------------------------------
  # * Show Window
  #--------------------------------------------------------------------------
  def show
    select_last
    @help_window.show
    super
  end
  #--------------------------------------------------------------------------
  # * Hide Window
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    super
  end
end

#==============================================================================
# ** Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Create All Windows
  #--------------------------------------------------------------------------
  def create_all_windows
    create_message_window
    create_scroll_text_window
    create_log_window
    create_status_window
    create_info_viewport
    create_party_command_window
    create_actor_command_window
    create_help_window
    create_skill_window if Spell_Charge::Options::INCLUDE_SKILLS
    create_spell_window
    create_item_window
    create_actor_window
    create_enemy_window
  end
  #--------------------------------------------------------------------------
  # * Create Actor Commands Window
  #--------------------------------------------------------------------------
  alias :r2_battle_spell_actor_command_window   :create_actor_command_window
  def create_actor_command_window
    r2_battle_spell_actor_command_window
    @actor_command_window.set_handler(:spell,  method(:command_spell))
  end
  #--------------------------------------------------------------------------
  # * Create Spell Window
  #--------------------------------------------------------------------------
  def create_spell_window
    @spell_window = Window_BattleSpell.new(@help_window, @info_viewport)
    @spell_window.set_handler(:ok,     method(:on_spell_ok))
    @spell_window.set_handler(:cancel, method(:on_spell_cancel))
  end
  #--------------------------------------------------------------------------
  # * Actor [OK]
  #--------------------------------------------------------------------------
  def on_actor_ok
    BattleManager.actor.input.target_index = @actor_window.index
    @actor_window.hide
    @skill_window.hide if @skill_window
    @spell_window.hide if @spell_window
    @item_window.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # * Enemy [OK]
  #--------------------------------------------------------------------------
  def on_enemy_ok
    BattleManager.actor.input.target_index = @enemy_window.enemy.index
    @enemy_window.hide
    @skill_window.hide if @skill_window
    @spell_window.hide if @spell_window
    @item_window.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # * [Spell] Command
  #--------------------------------------------------------------------------
  def command_spell
    @spell_window.actor = BattleManager.actor
    @spell_window.refresh
    @spell_window.show.activate
  end
  #--------------------------------------------------------------------------
  # * Spell [OK]
  #--------------------------------------------------------------------------
  def on_spell_ok
    @spell = @spell_window.item
    BattleManager.actor.input.set_skill(@spell.id)
    BattleManager.actor.last_skill.object = @spell
    if !@spell.need_selection?
      @spell_window.hide
      next_command
    elsif @spell.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  #--------------------------------------------------------------------------
  # * Spell [Cancel]
  #--------------------------------------------------------------------------
  def on_spell_cancel
    @spell_window.hide
    @actor_command_window.activate
  end
end

# ╔══════════════════════════════════════════════════════════╗
# ║              End of Script                               ║
# ╚══════════════════════════════════════════════════════════╝
