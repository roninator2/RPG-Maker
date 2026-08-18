# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Yazik Skill Shop - switchs & variables ║  Version: 1.07     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║   Provide Switches, Variables                 ╠════════════════════╣
# ║   and Stat changes in shop                    ║    06 Jul 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Addon to Yazik Skill and State Shop                          ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   Input the settings to your preference. read carefully            ║
# ║        ShopDatabase = {                                            ║
# ║                                                                    ║
# ║    Switch item format : [switch_id, price, :switch,                ║
# ║                           "Description", item index],              ║
# ║      item index for switches and variables and stats is            ║
# ║      used to pull in an item for drawing an icon                   ║
# ║    Variable item format : [var_id, price, :variable, "Description",║
# ║                            item index, amount],                    ║
# ║    Stat item format : [stat_id, price, :stat, "Description",       ║
# ║                        item index, amount, multi purchase,         ║
# ║                        change by, subtract amount],                ║
# ║      stat amount is how much the stat increases                    ║
# ║      Stat_id options are 0, 1, 2, 3, 4, 5, 6, 7                    ║
# ║        MHP, MMP, ATK, DEF, MAT, MDF, AGI, LUK                      ║
# ║      Multi purchase is true or false. False is single purchase     ║
# ║      Change by is the point which further purchases would reduce   ║
# ║        the amount gained by the subtract amount                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 06 Jul 2022 - Initial Publish                               ║
# ║ 1.01 - 07 Jul 2022 - Set switches to only be activated once        ║
# ║                Updated instructions                                ║
# ║ 1.02 - 09 Jul 2022 - Modified variables to be used only once       ║
# ║ 1.03 - 18 Jul 2022 - Fixed Help Text                               ║
# ║ 1.04 - 20 Jul 2022 - Corrected system to have data per actor       ║
# ║ 1.05 - 25 Aug 2022 - Added multi purchase of stats                 ║
# ║ 1.06 - 29 Aug 2022 - Reworked code to fix multi purchase           ║
# ║ 1.07 - 14 Mar 2026 - Added Import Value                            ║
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
$imported[:r2_ysssv] = 1.07         # Yazik Skill Shop switchs & variables

class Game_Actor < Game_Battler
  attr_accessor :skill_variables
  attr_accessor :stat_boost_skill
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias r2_skill_var_sw_setup setup
  def setup(actor_id)
    r2_skill_var_sw_setup(actor_id)
    @skill_variables = []
    @stat_boost_skill = []
  end
end

class Window_ShopSkill < Window_SkillList
  def make_item_list
    if @actor
      skills = []
      db = Yazik::SkillShop::ShopDatabase[@actor.id]
      for i in 0...db.size
        if db[i][2] == :state
          state_id = db[i][0]
          if @actor.state_addable?(state_id)
            state = $data_states[state_id]
            skills.push(state)
          end
        elsif db[i][2] == :switch
          switch_id = db[i][0]
          switch = [$game_switches[switch_id], $data_items[db[i][4]], :switch]
          skills.push(switch)
        elsif db[i][2] == :variable
          var_id = db[i][0]
          @actor.skill_variables[var_id] = false if @actor.skill_variables[var_id] == nil
          var = [$game_variables[var_id], $data_items[db[i][4]], :variable, db[i][5], @actor.skill_variables[var_id]]
          skills.push(var)
        elsif db[i][2] == :stat
          @actor.stat_boost_skill[i] = [false,0,db[i][6],db[i][7],db[i][8]] if @actor.stat_boost_skill[i] == nil
          stat = [db[i][0], $data_items[db[i][4]], :stat, db[i][5], @actor.stat_boost_skill[i][0]]
          skills.push(stat)
        else
          skill = $data_skills[db[i][0]]
          if @actor.added_skill_types.include?(skill.stype_id)
            skills.push(skill)
          end
        end
      end
      @data = skills
    else
      @data = []
    end
  end
  def draw_item(index)
    data = @data[index]
    if data
      rect = item_rect(index)
      rect.width -= 4
      if data.class == RPG::Skill
        enabled = @actor.skill_learn?(data)
      elsif data.class ==  RPG::State
        enabled = @actor.state?(data.id)
      elsif data[2] == :switch
        enabled = true if data[0].is_a?(FalseClass)
      elsif data[2] == :variable
        enabled = true if data[4] == false
      elsif data[2] == :stat
        enabled = true if data[4] == false
      end
      draw_skill_icon(index, data, rect.x, rect.y, enabled)
      draw_skill_price(rect, index)
    end
  end
  def draw_skill_icon(index, item, x, y, enabled)
    return unless item
    if item.is_a?(Array)
      draw_icon(item[1].icon_index, x, y, enabled)
    else
      draw_icon(item.icon_index, x, y, enabled)
    end
  end
end

class Scene_SkillShop < Scene_Skill
  def on_item_ok
    is_skill = item.class == RPG::Skill
    is_state = item.class == RPG::State
    is_array = item.class == Array
    if (is_skill and !@actor.skill_learn?(item)) or (is_state and !@actor.state?(item.id)) or (is_array)
      db = Yazik::SkillShop::ShopDatabase[@actor.id]
      price = db[@item_window.index][1]
      if db[@item_window.index][2] == :switch
        if ($game_switches[db[@item_window.index][0]] == true) ||
          (price > $game_actors[@actor.id].skill_point)
          Sound.play_buzzer
          @item_window.activate
        else
          @confirm_window.open
          @confirm_window.select(0)
          @confirm_window.activate
        end
      elsif db[@item_window.index][2] == :variable
        if (@actor.skill_variables[db[@item_window.index][0]] == true) ||
          (price > $game_actors[@actor.id].skill_point)
          Sound.play_buzzer
          @item_window.activate
        else
          @confirm_window.open
          @confirm_window.select(0)
          @confirm_window.activate
        end
      elsif db[@item_window.index][2] == :stat
        if (@actor.stat_boost_skill[@item_window.index][0] == true) ||
          (price > $game_actors[@actor.id].skill_point) || 
          Sound.play_buzzer
          @item_window.activate
        else
          @confirm_window.open
          @confirm_window.select(0)
          @confirm_window.activate
        end
      elsif price <= $game_actors[@actor.id].skill_point
        @confirm_window.open
        @confirm_window.select(0)
        @confirm_window.activate
      else
        Sound.play_buzzer
        @item_window.activate
      end
    else
      @item_window.activate
    end
  end
  def buy_item
    db = Yazik::SkillShop::ShopDatabase[@actor.id]
    if db[@item_window.index][2] == :state
      state_id = db[@item_window.index][0]
      state_price = db[@item_window.index][1]
      $game_actors[@actor.id].skill_point -= state_price
      $game_actors[@actor.id].add_state(state_id)
    elsif db[@item_window.index][2] == :switch
      switch_id = db[@item_window.index][0]
      switch_price = db[@item_window.index][1]
      $game_actors[@actor.id].skill_point -= switch_price
      $game_switches[switch_id] = !$game_switches[switch_id]
    elsif db[@item_window.index][2] == :variable
      var_id = db[@item_window.index][0]
      var_price = db[@item_window.index][1]
      var_amount = db[@item_window.index][5]
      $game_actors[@actor.id].skill_point -= var_price
      $game_actors[@actor.id].skill_variables[db[@item_window.index][0]] = true
      $game_variables[var_id] += var_amount
    elsif db[@item_window.index][2] == :stat
      stat_id = db[@item_window.index][0]
      amount = db[@item_window.index][5]
      stat_price = db[@item_window.index][1]
      $game_actors[@actor.id].stat_boost_skill[@item_window.index][0] = true if ($game_actors[@actor.id].stat_boost_skill[@item_window.index][2] == false)
      $game_actors[@actor.id].skill_point -= stat_price
			if ($game_actors[@actor.id].stat_boost_skill[@item_window.index][1] >= $game_actors[@actor.id].stat_boost_skill[@item_window.index][3]) &&
				($game_actors[@actor.id].stat_boost_skill[@item_window.index][2] == true)
				amount = amount - ($game_actors[@actor.id].stat_boost_skill[@item_window.index][4])
				($game_actors[@actor.id].stat_boost_skill[@item_window.index][1] += 1)
			end
			@actor.add_param(stat_id, amount)
		else
      skill_id = db[@item_window.index][0]
      skill_price = db[@item_window.index][1]
      $game_actors[@actor.id].skill_point -= skill_price
      $game_actors[@actor.id].learn_skill(skill_id)
    end
    @info_window.refresh
    @confirm_window.close
    @confirm_window.deactivate
    @item_window.refresh
    @item_window.activate
  end
end

class Window_ShopHelp < Window_Help
  def set_item(item)
    if item.class == Array
      itemn = item[1]
      set_name(itemn.name)
    else
      set_name(item ? item.name : "")
    end
    if SceneManager.scene_is?(Scene_SkillShop)
      if (item) and ((item.class == RPG::State) or (item.class == Array))
        set_text(SceneManager.scene.database_item[3])
        return
      end
    end
    yazik_ss_set_item(item)
  end
end
