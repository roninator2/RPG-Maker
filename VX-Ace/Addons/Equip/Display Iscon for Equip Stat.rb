# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Display Icon for Equip Stat            ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║       Modify arrow display                    ║    05 Aug 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Draw an icon instead of the arrow on the equip screen        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║    Change the numbers below to the icon you wish                   ║
# ║    to use for the icons                                            ║
# ║    Increase is the icon for when stats go up                       ║
# ║    Decrease is the icon for when stats go down                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Aug 2022 - Script finished                               ║
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

module R2_Arror_Icon_Equip
	Increase = 111
	Decrease = 112
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝
$imported = {} if $imported.nil?
$imported[:r2_difes] = 1.01        # Display Icon for Equip Stat

class Window_EquipStatus < Window_Base
  def draw_item(dx, dy, param_id)
    draw_background_colour(dx, dy)
    draw_param_name(dx + 4, dy, param_id)
    draw_current_param(dx + 4, dy, param_id) if @actor
    drx = (contents.width + 22) / 2
		old_value = @actor.param(param_id) if @actor
		new_value = @temp_actor.param(param_id) if @temp_actor
    if @actor && @temp_actor
      value = new_value - old_value
    else
      value = 0
    end
    draw_right_arrow_icon(drx, dy, value)
    draw_new_param(drx + 22, dy, param_id) if @temp_actor
    reset_font_settings
  end
  def draw_right_arrow_icon(x, y, value = 0)
		if value > 0
			draw_icon(R2_Arror_Icon_Equip::Increase, x, y)
		elsif value < 0
			draw_icon(R2_Arror_Icon_Equip::Decrease, x, y)
		end
  end
end
