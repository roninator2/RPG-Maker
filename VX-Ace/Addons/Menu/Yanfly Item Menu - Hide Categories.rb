# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly Item Menu - Hide Categories     ║  Version: 1.02     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║    Hide categories in Item Menu               ║    07 Feb 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║      Specify if certain categories are to be hidden                ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║   Categories will not be shown if there are no items in them       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 30 Sep 2021 - Script finished                               ║
# ║ 1.01 - 07 Feb 2022 - Script updated                                ║
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
# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_timhc] = 1.02        # Yanfly Item Menu - Hide Categories

class Window_ItemCommand < Window_Command
  def make_command_list
    for command in YEA::ITEM::COMMANDS
      case command
      #--- Default Commands ---
      when :item
        add_command(Vocab::item, :item) unless $game_party.items.empty?
      when :weapon
        add_command(Vocab::weapon, :weapon) unless $game_party.weapons.empty?
      when :armor
        add_command(Vocab::armor, :armor) unless $game_party.armors.empty?
      when :key_item
        add_command(Vocab::key_item, :key_item)
      #--- Imported ---
      when :gogototori
        next unless $imported["KRX-AlchemicSynthesis"]
        process_custom_command(command)
      #--- Custom Commands ---
      else
        process_custom_command(command)
      end
    end
  end
end
class Window_ItemType < Window_Command
  def make_command_list
    return if @type.nil?
    #---
    case @type
    when :item
      commands = YEA::ITEM::ITEM_TYPES
    when :weapon
      commands = YEA::ITEM::WEAPON_TYPES
    else
      commands = YEA::ITEM::ARMOUR_TYPES
    end
    #---
    for command in commands
      case @type
      when :weapon
        for i in 0..$game_party.weapons.size - 1
          if $game_party.weapons[i].note.include?(command[1])
            add_command(command[1], command[0], true, @type) unless @list.find {|x| x[:name] == command[1]}
          end
        end
      when :armor
        for i in 0..$game_party.armors.size - 1
          if $game_party.armors[i].note.include?(command[1])
            add_command(command[1], command[0], true, @type) unless @list.find {|x| x[:name] == command[1]}
          end
        end
      when :item
        for i in 0..$game_party.items.size - 1
          if $game_party.items[i].note.include?(command[1])
            add_command(command[1], command[0], true, @type) unless @list.find {|x| x[:name] == command[1]}
          end
        end
      end
      add_command(command[1], command[0], true, @type) if command[0] == :all
    end
  end
end
