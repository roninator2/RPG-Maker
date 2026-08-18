# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: One Person Item Menu                   ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Addon to Doctor Todd's One Person Menu      ║    31 May 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Doctor Todd's One Person Menu                            ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Provide a menu for Items                                     ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   A menu that is modified to work as if you are only using one     ║
# ║   actor.                                                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 31 May 2022 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Doctor Todd                                                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module DTOPMI
  
  #Window skin to use, place in system.
  WINDOW = ('Window')
  
  #Help Window X
  HX = 50

  #Help Window Y
  HY = 50

  #Help Window Width
  HW = 550

  #Help Window Height
  HH = 70

  #Category Window X
  ICX = 50

  #Catagory Window Y
  ICY = 120

  #Category Window Width
  ICW = 550

  #Item Window X
  IX = 50

  #Item Window Y
  IY = 170

  #Item Window Width
  IW = 550

  #Item Window Height
  IH = 300

end

# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_category_window
    create_item_window
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @help_window.x = (DTOPMI::HX)
    @help_window.y = (DTOPMI::HY)
    @category_window = Window_ItemCategory.new
    @category_window.windowskin = Cache.system(DTOPMI::WINDOW)
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.x = (DTOPMI::ICX)
    @category_window.y = (DTOPMI::ICY)
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_ItemList.new((DTOPMI::IX), (DTOPMI::IY), (DTOPMI::IW), (DTOPMI::IH))
    @item_window.windowskin = Cache.system(DTOPMI::WINDOW)
    @item_window.viewport = @viewport
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
  end
end

class Window_Help < Window_Base
  def initialize(line_number = 2)
    super(0, 0, (DTOPMI::HW), (DTOPMI::HH))
  end
end

class Window_ItemCategory < Window_HorzCommand
  def window_width
    (DTOPMI::ICW)
  end
end
