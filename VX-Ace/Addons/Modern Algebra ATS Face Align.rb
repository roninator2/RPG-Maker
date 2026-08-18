# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Face Align                             ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Adjust Face position for text               ║    01 Nov 2020     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Modern Algeebra's ATS script                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Move Face Image towards text when centered                   ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and Play                                                    ║
# ║   During a conversation you have the text centered                 ║
# ║   The face image will be on the left side                          ║
# ║   This will determine the size of the text written                 ║
# ║   and move the face graphic towards the text                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 01 Nov 2020 - Script finished                               ║
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
$imported[:r2_mafa] = 1.01          # Modern Algebra face align

class Window_Message < Window_Base
  def new_page(text, pos)
    contents.clear
    face_x = 0
    face_pos = 0
    for i in 0..$game_message.texts.size
      arrvalue = $game_message.texts[i]
      next if arrvalue.nil?
      result = arrvalue.to_s.clone
      result.gsub!(/\i\i\[\d+\]/)          { "" }
      parsetxt = convert_escape_characters(result)
      arrlgth = parsetxt.length * 10
      if arrlgth > face_pos
        face_pos = arrlgth
      end
    end
    face_pos = (Graphics.width - face_pos) / 2 - 20
    if face_pos <= 0; face_pos = 0; end
    draw_face($game_message.face_name, $game_message.face_index, face_pos, 0)
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
end
