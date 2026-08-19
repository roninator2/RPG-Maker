# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Roofs                                  ║  Version: 1.00     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Hide map locations                          ║    09 Aug 2026     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Make a cover to hide a room or building                      ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Set your Map Note Tags                                           ║
# ║                                                                    ║
# ║     <roof: 1: r x: [4,8] , y: [2,6]>                               ║
# ║      Roof cover labeled with id 1                                  ║
# ║                                                                    ║
# ║     <roof: 2: r x: [14,18] , y: [8,12]>                            ║
# ║     <roof: 2: r x:[14,18] , y:[8,12]>                              ║
# ║     <roof: 2 r x[14,18], y[8,12]>                                  ║
# ║     <roof2rx[14,18]y[8,12]>                                        ║
# ║        These examples are all the same.                            ║
# ║                                                                    ║
# ║     <roof: 2: r x: [14,18] , y: [8,12]>                            ║
# ║     2 = ID (colon optional) -> ID required to distinguish the roof ║
# ║     r = Range or spot -> range is defining an area                 ║
# ║     x = X position                                                 ║
# ║     [14,18] = X range -> start at tile 14 and go until tile 18     ║
# ║     y = Y position                                                 ║
# ║     [8,12] = Y range -> works the same as X range                  ║
# ║                                                                    ║
# ║     <roof: 2: s [16,13]>                                           ║
# ║     2 = ID (colon optional) -> required. Adds onto previous entry  ║
# ║     s = Spot -> a single tile that will be covered                 ║
# ║         Useful when you want to add a bit of the door to the room  ║
# ║     [16,13] = X and Y coordinate for the spot. [X, Y]              ║
# ║                                                                    ║
# ║   Use <hide roof: 2> to specify if the roof will not come back     ║
# ║       when you leave the area (room)                               ║
# ║                                                                    ║
# ║   By default the roof will return when walking away.               ║
# ║                                                                    ║
# ║   Use <roof image: 1, roof> to specify a specific image file       ║
# ║      In this case "Roof.png" for zone 1.                           ║
# ║                                                                    ║
# ║   Roof Image files must be 32 x 32 pixels                          ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 09 Aug 2026 - Script finished                               ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   TheoAllen                                                        ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Terms of use:                                                      ║
# ║  Follow the original Authors terms of use where applicable         ║
# ║    - When not made by me (Roninator2)                              ║
# ║  Free for all uses in RPG Maker except nudity                      ║
# ║  No part of this code can be used with AI programs or tools        ║
# ║  Credit must be given                                              ║
# ╚════════════════════════════════════════════════════════════════════╝

module R2_ROOF_COVER_OPTIONS
  # file used if no image name is provided for roof id
  DEFAULT_IMAGE = "Roof"
end


# ╔════════════════════════════════════════════════════════════════════╗
# ║                      End of editable region                        ║
# ╚════════════════════════════════════════════════════════════════════╝

$imported = {} if $imported.nil?
$imported[:r2_rci] = 1.00          # Roof Cover Image

#=============================================================================
# ** Plane_Mask
#----------------------------------------------------------------------------
#  Sprite that same size as the map size. It's also scrolled alongside the map
# if it's updated. It can be used to draw anything on map. Can be used as base
# class of parallax lock actually
#=============================================================================
class R2_Plane_Mask < Plane
  
  def initialize(vport)
    super(vport)
    @width = 1
    @height = 1
  end
  
  def update
    if $game_map
      if @width != $game_map.width || @height != $game_map.height
        @width = $game_map.width
        @height = $game_map.height
        update_bitmap
      end
      self.ox = $game_map.display_x * 32
      self.oy = $game_map.display_y * 32
    end
  end
  
  def update_bitmap
    bmp = Bitmap.new(@width * 32, @height * 32)
    self.bitmap = bmp
  end
  
end

#=============================================================================
# ** RoofMask
# -------------------------------------------- ------------------------------
# Sprite that same size as the map size. It's also scrolled alongside the map
# if it's updated. It can be used to draw anything on map. In this script, it
# used to manually draw "Fog of War" on map screen.
#=============================================================================
class RoofMask < R2_Plane_Mask
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    update_roofs if refresh_cover
  end
  #--------------------------------------------------------------------------
  # * Update bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    super
    update_roofs
  end
  #--------------------------------------------------------------------------
  # * Update Roofs
  #--------------------------------------------------------------------------
  def update_roofs
    # load roof id and process for each
    bitmap.clear
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |id, data|
        image = $game_map.roof_image[$game_map.map_id][id.to_i]
        image = R2_ROOF_COVER_OPTIONS::DEFAULT_IMAGE if image == nil
        next if $game_player.under_zone(id.to_i)
        next if $game_map.roof_hidden[$game_map.map_id][id.to_i] == true
        # Load your custom graphic texture (32x32 size works best)
        tile_graphic = Cache.picture(image)
        rect = Rect.new(0, 0, tile_graphic.width, tile_graphic.height)
        # Fill all old/inactive region positions with the graphic
        positions = []
        if key == :spots
          data.each do |pos|
            x = pos[0] * 32
            y = pos[1] * 32
            bitmap.blt(x, y, tile_graphic, rect)
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for i in xzone[0]..xzone[1]
              for j in yzone[0]..yzone[1]
                x = i * 32
                y = j * 32
                bitmap.blt(x, y, tile_graphic, rect)
              end
            end
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Refresh cover
  #--------------------------------------------------------------------------
  def refresh_cover
    if $game_map.refresh_roofmask
      $game_map.refresh_roofmask = false
      return true
    end
    return false
  end
  
end

#=============================================================================
# ** Game_Map
#=============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Public Attributes
  #--------------------------------------------------------------------------
  attr_accessor :refresh_roofmask
  attr_reader :roof_hide
  attr_reader :roof_hidden
  attr_reader :roofs
  attr_reader :roof_image
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias :r2_roof_setup :setup
  def setup(map_id)
    r2_roof_setup(map_id)
    record_roofs(map_id)
    @refresh_roofmask
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #     main:  Interpreter update flag
  #--------------------------------------------------------------------------
  alias :r2_roof_update_main :update
  def update(main = false)
    r2_roof_update_main(main)
    under_cover?
  end
  #--------------------------------------------------------------------------
  # * Record / pre-cache regions
  #--------------------------------------------------------------------------
  def record_roofs(id)
    @refresh_roofmask = true
    @roofs ||= {}
    @roofs[id.to_i] ||= {}
    @roofs[id.to_i][:spots] ||= {}
    @roofs[id.to_i][:range] ||= {}
    @roof_hide ||= {}
    @roof_hide[id.to_i] ||= []
    @roof_hidden ||= {}
    @roof_hidden[id.to_i] ||= []
    @roof_image ||= {}
    @roof_image[id.to_i] ||= []
    regex = /<roof(?:|:)(?:|[ -_])(\d+)(?:|:)(?:|[ -_])(\w)(?:|[ -_])(?:|(\w)(?:|:)(?:| ))\[(\d+),(\d+)](?:|[ -_])(?:|,)(?:|(?:|[ -_])(?:|(\w)(?:|:)(?:| ))\[(\d+),(\d+)])>/i
    hide_regex = /<hide[ -_]roof:(?:| *)(\d+)>/i
    cover_regex = /<roof[ -_]image: (\d+), (\w*)>/i
    x = []
    y = []
    @map.note.split(/[\r\n]+/).each do |line|
      if line =~ regex
        if $2.to_s.downcase == 's'
          next if @roof_hidden[id.to_i][$1.to_i] == true
          if @roofs[id.to_i][:spots][$1.to_i].nil?
            (@roofs[id.to_i][:spots][$1.to_i] ||= []) << [$4.to_i,$5.to_i] 
          else 
            @roofs[id.to_i][:spots][$1.to_i] << [$4.to_i,$5.to_i] unless @roofs[id.to_i][:spots][$1.to_i].include?([$4.to_i,$5.to_i])
          end
        elsif $2.to_s.downcase == 'r'
          next if @roof_hidden[id.to_i][$1.to_i] == true
          if $3.to_s.downcase == 'x' && $6.to_s.downcase == 'y'
            x = [$4.to_i,$5.to_i]
            y = [$7.to_i,$8.to_i]
          elsif $3.to_s.downcase == 'y' && $6.to_s.downcase == 'x'
            x = [$7.to_i,$8.to_i]
            y = [$4.to_i,$5.to_i]
          else
            $game_message.add("Map note tags are not working.")
          end
          if @roofs[id.to_i][:range][$1.to_i].nil?
            (@roofs[id.to_i][:range][$1.to_i] ||= []) << [x,y] 
          else
            @roofs[id.to_i][:range][$1.to_i] << [x,y] unless @roofs[id.to_i][:range][$1.to_i].include?([x,y])
          end
        end
      elsif line =~ hide_regex
        @roof_hide[id.to_i][$1.to_i] = true
      elsif line =~ cover_regex
        @roof_image[id.to_i][$1.to_i] = $2.to_s
      end
    end
  end
  #--------------------------------------------------------------------------
  # * under cover?
  #--------------------------------------------------------------------------
  def under_cover?
    if $game_player.under_roof?
      update_roofmask
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # * update roofmask
  #--------------------------------------------------------------------------
  def update_roofmask
    @refresh_roofmask = true
  end
  #--------------------------------------------------------------------------
  # * Remvoe roof if no longer hiding
  #--------------------------------------------------------------------------
  def remove_roof(id)
    @roofs[$game_map.map_id].each do |key, value|
      if key == :spots
        value.delete(id)
      elsif key == :range
        value.delete(id)
      end
      @roof_hide[@map_id][id] = nil
    end
    @roof_hidden[@map_id][id] = true
  end
end

#=============================================================================
# ** Game_Player
#=============================================================================

class Game_Player
  #--------------------------------------------------------------------------
  # * Opacity
  #--------------------------------------------------------------------------
  def opacity
    return @opacity
  end  
  #--------------------------------------------------------------------------
  # * Under a Roof?
  #--------------------------------------------------------------------------
  def under_roof?
    under = false
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |id, data|
        if key == :spots
          data.each do |pos|
            if pos == screen_position
              under = true
              $game_map.remove_roof(id) if $game_map.roof_hide[$game_map.map_id][id] == true
            end
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for i in xzone[0]..xzone[1]
              for j in yzone[0]..yzone[1]
                pos = [i, j]
                if pos == screen_position
                  under = true
                  $game_map.remove_roof(id) if $game_map.roof_hide[$game_map.map_id][id] == true
                end
              end
            end
          end
        end
      end
    end
    return under
  end  
  #--------------------------------------------------------------------------
  # * Under a Roof?
  #--------------------------------------------------------------------------
  def under_zone(id)
    under = false
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |i, data|
        next if i != id
        if key == :spots
          data.each do |pos|
            under = true if pos == screen_position
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for i in xzone[0]..xzone[1]
              for j in yzone[0]..yzone[1]
                under = true if @x == i && @y == j
              end
            end
          end
        end
      end
    end
    return under
  end  
  #--------------------------------------------------------------------------
  # * Screen_position
  #--------------------------------------------------------------------------
  def screen_position
    [@x,@y]
  end
end

#=============================================================================
# ** Game_Event
#=============================================================================

class Game_Event
  #--------------------------------------------------------------------------
  # * Stay Visible?
  #--------------------------------------------------------------------------
  def stay_visible?
    if @last_list != @list
      @last_list = @list
      return false unless @list
      @stay_visible = false
      @list.each do |command|
        next unless [108,408].include?(command.code)
        @stay_visible = true if command.parameters[0] =~ /<visible>/i
      end
    end
    return @stay_visible
  end
  #--------------------------------------------------------------------------
  # * Opacity
  #--------------------------------------------------------------------------
  def opacity
    get_roof if @event_roof == nil
    return @opacity if stay_visible? || player_match
    return 0 if event_covered?
    return @opacity
  end
  #--------------------------------------------------------------------------
  # * Screen Z value
  #--------------------------------------------------------------------------
  def screen_z
    return 25 if stay_visible? && event_covered?
    return super
  end
  #--------------------------------------------------------------------------
  # * Screen_position
  #--------------------------------------------------------------------------
  def screen_position
    [@x,@y]
  end
  #--------------------------------------------------------------------------
  # * Get Event roof cover ID
  #--------------------------------------------------------------------------
  def get_roof
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |id, data|
        if key == :spots
          data.each do |pos|
            @event_roof = id if (pos == screen_position)
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for j in xzone[0]..xzone[1]
              for k in yzone[0]..yzone[1]
                @event_roof = id if screen_position == [j,k]
              end
            end
          end
        end
      end
    end
    @event_roof = 0 if @event_roof == nil
  end
  #--------------------------------------------------------------------------
  # * Screen_position
  #--------------------------------------------------------------------------
  def event_covered?
    under = false
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |id, data|
        if key == :spots
          data.each do |pos|
            under = true if (pos == screen_position)
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for i in xzone[0]..xzone[1]
              for j in yzone[0]..yzone[1]
                under = true if (@x == i && @y == j)
              end
            end
          end
        end
        under = false if $game_player.under_zone(@event_roof)
      end
    end
    return under
  end
  #--------------------------------------------------------------------------
  # * Player Match event position
  #--------------------------------------------------------------------------
  def player_match
    match = false
    $game_map.roofs[$game_map.map_id].each do |key, value|
      value.each do |id, data|
        if key == :spots
          data.each do |pos|
            if (pos == $game_player.screen_position)
              match = true if (id == @event_roof) && $game_player.under_zone(@event_roof)
            end
          end
        elsif key == :range
          data.each do |i|
            xzone = i[0]
            yzone = i[1]
            for i in xzone[0]..xzone[1]
              for j in yzone[0]..yzone[1]
                if $game_player.screen_position == [i,j]
                  match = true if (id == @event_roof) && $game_player.under_zone(@event_roof)
                end
              end
            end
          end
        end
      end
    end
    return match
  end
end

#=============================================================================
# ** Spriteset_Map
#=============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Create Viewports
  #--------------------------------------------------------------------------
  alias :r2_roof_create_vwport :create_viewports
  def create_viewports
    r2_roof_create_vwport
    @roofmask = RoofMask.new(@viewport1)
    @roofmask.z = 50
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  alias :r2_roof_update :update
  def update
    r2_roof_update
    @roofmask.update
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias :r2_roof_dispose :dispose
  def dispose
    r2_roof_dispose
    @roofmask.dispose
  end
  
end
