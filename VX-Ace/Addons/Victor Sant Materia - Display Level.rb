# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Materia Level Display                  ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust Materia System                       ║    30 Jan 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Adds Materia level on icon                                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and Play                                                    ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 30 Jan 2022 - Script finished                               ║
# ║ 1.01 - 14 Mar 2026 - Added Import Value                            ║
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
$imported[:r2_mldy] = 1.01         # Materia Level Display

class RPG::Armor < RPG::EquipItem
  attr_accessor :ap_list
end

class Window_MateriaList < Window_Selectable
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    now = item.level.to_i
    max = item.ap_list.length.to_i
    num = now == max ? "M" : now
    draw_icon(item.icon_index, x, y, enabled, item)
    draw_text(x, y, width, line_height, num, 0)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end

class Window_MateriaEquip < Window_Selectable
  def draw_materia_icons(x)
    actor.equip_slots.size.times do |i|
      next unless actor.materia_slots[i]
      actor.materia_slots[i].each_with_index do |m, y|
        draw_materia(m.icon_index, x + y * 32, i * 50 + 24, m, 200) if m
        now = m.level.to_i if m
        max = m.ap_list.length.to_i if m
        num = max == now ? "M" : now if m
        draw_text(x + y * 32, i * 50 + 24, 40, line_height, num, 0) if m
      end
    end
  end
end
