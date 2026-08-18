# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yanfly Shop Options - Buy Categories   ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Add feature to script                       ║    02 Jun 2019     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Yanfly Shop Options                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Plug and play                                                    ║
# ║   modifies the shop option for yanfly to include                   ║
# ║   categories for buying.                                           ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 02 Jun 2019 - Script finished                               ║
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
$imported[:r2_ysobc] = 1.01        # Yanfly Shop Options - Buy Categories

class Window_ShopBuy < Window_Selectable
 
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  
  def make_item_list
    @data = []
    @price = {}
    categories = { :item => 0,:weapon => 1 ,:armor => 2, :key_item => 0 }
    @shop_goods.each do |goods|
      next unless goods[0] == categories[@category]
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        next if (@category == :item && item.key_item?)
        next if (@category == :key_item && !item.key_item?)
        @data.push(item)
        @price[item] = goods[2] == 0 ? item.price : goods[3]
      end
    end
  end
end

class Scene_Shop < Scene_MenuBase

  alias scene_shop_start_r2 start
  def start
    scene_shop_start_r2
    create_buy_category_window
  end

  def create_buy_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @buy_window = Window_ShopBuy.new(0, wy, wh, @goods)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
  end

  def command_buy
    @dummy_window.hide
    @buy_category_window.x = 0
    @command_window.x = Graphics.width
    @buy_window.x = 0
    @sell_window.x = Graphics.width
    @buy_window.unselect
    @buy_window.refresh
    @data_window.item_window = @buy_window
    @buy_window.show
    @status_window.show
    @buy_category_window.show.activate
    @buy_category_window.item_window = @buy_window
  end
  
  def activate_buy_window
    @buy_window.show
    @buy_window.money = money
    @buy_window.show.activate
    @status_window.show
  end
 
  def on_buy_cancel
    @dummy_window.show
    @status_window.item = nil
    @help_window.clear
    @buy_category_window.activate
  end
  
  def create_buy_category_window
    @buy_category_window = Window_ShopCategory.new
    @buy_category_window.viewport = @viewport
    @buy_category_window.help_window = @help_window
    @buy_category_window.y = @category_window.y
    @buy_category_window.hide.deactivate
    @buy_category_window.set_handler(:ok,     method(:on_buy_category_ok))
    @buy_category_window.set_handler(:cancel, method(:on_buy_category_cancel))
  end

  def on_buy_category_ok
    activate_buy_window
    @buy_window.select(0)
  end
  
  def on_buy_category_cancel
    on_category_cancel
    @buy_category_window.hide
    @buy_window.deactivate
    @status_window.item = nil
    @help_window.clear
  end  

end
