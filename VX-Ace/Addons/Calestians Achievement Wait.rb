# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Achievement wait                       ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Specifies a wait period                     ║    05 Apr 2019     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Calestian Achievement System                             ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║           Set a wait time for achievement window to close          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   You can set the time to wait before the window starts            ║
# ║   to disappear and the window skin to use for the message          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 05 Apr 2019 - Script finished                               ║
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

  Notification_Pause        = 160       # Frames to wait before disappearing
  Window_Skin            = "Window_Effects" # Must be in quotes
  
end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Window_AchievementNotification < Window_Base
 
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize
    @window = $game_party.notifications[0][1]
    @item   = $game_party.notifications[0][0]
    super(x, 0, width, height)
    $game_party.notification_enabled = false
    self.windowskin = Cache.system(Clstn_Achievement_System::Window_Skin)
    @view = Clstn_Achievement_System::Notification_Pause
    refresh
  end
  
  def update
    if !disposed? && @view > 0
      @view -= 1
    elsif !disposed? && self.opacity > 0
      self.opacity -= 5
      self.contents_opacity -= 5
      self.back_opacity -= 5
    else
      $game_party.notifications.delete_at(0) unless $game_party.notifications.empty?
      if !$game_party.notifications.empty?
        $game_party.notification_enabled = true
      else
        $game_party.notification_enabled = false
        SceneManager.call(Scene_Map)
      end
      @view = Clstn_Achievement_System::Notification_Pause
    end
  end
end
