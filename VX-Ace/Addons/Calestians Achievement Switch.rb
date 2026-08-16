# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Achievement switch                     ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║           Add a switch to achievements        ║    01 Nov 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Calestians Achievement System                            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║         Set achievement data to use switches                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Add in a switch to the Achievement data and then                 ║
# ║   you can hide the achievement until the switch is on              ║
# ║                                                                    ║
# ║   For example                                                      ║
# ║    1 => {                                                          ║
# ║      :Name              => "Treasure Hunter",                      ║
# ║      :Tiers             => [50, 100, 150, 200, 250],               ║
# ║      :Help              => "Find Treasures",                       ║
# ║      :Title             => "Treasure Sluth",                       ║
# ║      :RewardItem        => :none,                                  ║
# ║      :RewardGold        => :none,                                  ║
# ║      :Category          => "General",                              ║
# ║      :AchievementPoints => :none,                                  ║
# ║      :Prerequisite      => :none,                                  ║
# ║      :Repeatable        => 5,                                      ║
# ║      :Switch            => 15,                                     ║
# ║    },                                                              ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 01 Nov 2020 - Script finished                               ║
# ║                                                                    ║
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
# ║  Anyone using this script in their project before these terms      ║
# ║  were changed are allowed to use this script even if it conflicts  ║
# ║  with these new terms. New terms effective 03 Apr 2024             ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module Clstn_Achievement_System
  
  def self.get_category_achievements
    category = []
    Achievement_Categories.each { |key|
      temp = []
      Achievements.each_value { |value|
        temp.push(value[:Name]) if (value[:Category] == key[0]) &&
        ($game_switches[value[:Switch]] == true)
      }
      category.push(temp.empty? ? 0 : temp)
    }
    return category
  end

end
