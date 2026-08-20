# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Mr Trivel Hurt Sounds SAS IV           ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║  Play Hurt Sounds                             ╠════════════════════╣
# ║  Rewrite of Mr Trivel script                  ║    18 Jul 2022     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: nil                                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Hurt Sounds for SAS IV                                       ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║                                                                    ║
# ║   Compatibility patch for SAS IV                                   ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Updates:                                                           ║
# ║ 1.00 - 18 Jul 2022 - Initial publish                               ║
# ║ 1.01 - 14 Mar 2026 - Added Import Value                            ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Credits and Thanks:                                                ║
# ║   Roninator2                                                       ║
# ║   Mr Trivel                                                        ║
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
$imported[:r2_mthssas] = 1.01      # Mr Trivel Hurt Sounds SAS IV

class Sapphire_Enemy
  alias :r2_hurt_initialize :initialize
  attr_accessor :hurt_sound
  attr_accessor :dead_sound
  def initialize(event,id)
    r2_hurt_initialize(event,id)
    @hurt_sound = []
    @dead_sound = []
    results = @game_enemy.note.scan(R2_Hurt_Sound_Mod::Hurt_Regex)
    results.each do |res|
      @hurt_sound.push(res)
    end
    dresults = @game_enemy.note.scan(R2_Hurt_Sound_Mod::Dead_Regex)
    dresults.each do |res|
      @dead_sound.push(res)
    end
  end
end
# )----------------------------------------------------------------------------(
# )--  Class: Game_Event                                                     --(
# )----------------------------------------------------------------------------(
class Game_Event < Game_Character
  def damage_enemy(value,by_player=false)
    value -= @enemy.defence
    value = 0 if value < 0
    @enemy.hp -= value
    dead_sound = @enemy.dead_sound
    hurt_sound = @enemy.hurt_sound
    $game_map.show_text(self,value) unless @enemy.object
    if @enemy.hp <= 0
      if dead_sound.size == 0
        kill_enemy(by_player)
      else
        i = rand(@enemy.dead_sound.size)
        Audio.se_play("Audio/SE/"+dead_sound[i][0], dead_sound[i][1].to_i, dead_sound[i][2].to_i)
        kill_enemy(by_player)
      end
    elsif by_player && @request_view
      @balloon_id = 1 if Sapphire_Core::Enemy_Exclamation
      @move_type = 2
      @move_frequency = 6
      @request_view = false
    end
    return unless (hurt_sound.size > 0) && (value > 0)
    i = rand(hurt_sound.size)
    Audio.se_play("Audio/SE/"+hurt_sound[i][0], hurt_sound[i][1].to_i, hurt_sound[i][2].to_i)
  end
  def skill_damage_enemy(value,by_player=false)
    value -= @enemy.mdefence
    value = 0 if value < 0
    @enemy.hp -= value
    dead_sound = @enemy.dead_sound
    hurt_sound = @enemy.hurt_sound
    $game_map.show_text(self,value) unless @enemy.object
    if @enemy.hp <= 0
      if dead_sound.size == 0
        kill_enemy(by_player)
      else
        i = rand(@enemy.dead_sound.size)
        Audio.se_play("Audio/SE/"+dead_sound[i][0], dead_sound[i][1].to_i, dead_sound[i][2].to_i)
        kill_enemy(by_player)
      end
    elsif by_player && @request_view
      @balloon_id = 1 if Sapphire_Core::Enemy_Exclamation
      @move_type = 2
      @move_frequency = 6
      @request_view = false
    end
    return unless (hurt_sound.size > 0) && (value > 0)
    i = rand(hurt_sound.size)
    Audio.se_play("Audio/SE/"+hurt_sound[i][0], hurt_sound[i][1], hurt_sound[i][2])
  end
  alias r2_sas_iv_trivel_kill_enemy kill_enemy
end
# )----------------------------------------------------------------------------(
# )--  Class: Game_Player                                                     --(
# )----------------------------------------------------------------------------(
class Game_Player < Game_Character
  alias r2_sas_iv_trivel_player_hurt_damage damage_hero
  def damage_hero(value)
    r2_sas_iv_trivel_player_hurt_damage(value)
    actor = $game_party.members[0]
    return unless actor && value > 0
    hurt_sound = []
    results = actor.note.scan(R2_Hurt_Sound_Mod::Hurt_Regex)
    results.each do |res|
      hurt_sound.push(res)
    end
    return unless hurt_sound && value > 0
    i = rand(hurt_sound.size)
    Audio.se_play("Audio/SE/"+hurt_sound[i][0], hurt_sound[i][1].to_i, hurt_sound[i][2].to_i)
    return unless actor.hp == 0
    dead_sound = []
    dresults = actor.note.scan(R2_Hurt_Sound_Mod::Dead_Regex)
    dresults.each do |res|
      dead_sound.push(res)
    end
    i = rand(dead_sound.size)
    Audio.se_play("Audio/SE/"+dead_sound[i][0], dead_sound[i][1].to_i, dead_sound[i][2].to_i)
  end
  alias r2_sas_iv_trivel_player_hurt_skill skill_damage_hero
  def skill_damage_hero(value)
    r2_sas_iv_trivel_player_hurt_skill(value)
    actor = $game_party.members[0]
    return unless actor && value > 0
    hurt_sound = []
    results = actor.note.scan(R2_Hurt_Sound_Mod::Hurt_Regex)
    results.each do |res|
      hurt_sound.push(res)
    end
    return unless hurt_sound && value > 0
    i = rand(hurt_sound.size)
    Audio.se_play("Audio/SE/"+hurt_sound[i][0], hurt_sound[i][1].to_i, hurt_sound[i][2].to_i)
    return unless actor.hp == 0
    dead_sound = []
    dresults = actor.note.scan(R2_Hurt_Sound_Mod::Dead_Regex)
    dresults.each do |res|
      dead_sound.push(res)
    end
    i = rand(dead_sound.size)
    Audio.se_play("Audio/SE/"+dead_sound[i][0], dead_sound[i][1].to_i, dead_sound[i][2].to_i)
  end
end
