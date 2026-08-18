# ╔═══════════════════════════════════════════════╦════════════════════╗
# ║ Title: Magic Shard addon                      ║  Version: 1.01     ║
# ║ Author: Roninator2                            ║                    ║
# ╠═══════════════════════════════════════════════╬════════════════════╣
# ║ Function:                                     ║   Date Created     ║
# ║                                               ╠════════════════════╣
# ║   Alter Script Processing                     ║    14 Mar 2026     ║
# ╚═══════════════════════════════════════════════╩════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Requires: Galv's Magic Shards                                      ║
# ║                                                                    ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Brief Description:                                                 ║
# ║       Allows combinations of 3 shards                              ║
# ╚════════════════════════════════════════════════════════════════════╝
# ╔════════════════════════════════════════════════════════════════════╗
# ║ Instructions:                                                      ║
# ║   These are setup in Galvs script NOT HERE!                        ║
# ║   [shard_id,shard_id,shard_id] => skill_id,                        ║
# ║   [1,2,3] => 46, # fire and water and earth = skill 46             ║
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
$imported[:r2_gmst] = 1.01         # Galv Magic Shards Three


class Game_Actor < Game_Battler
  def shard_linked_skills_three
    lst = Galv_Shard::SHARDS
    return [] if !shards
    sarray = []
    shards.each_with_index { |s,i|
      nxt = shards[i + 1].nil? ? 0 : i + 1
      fst = shards[i - 1].nil? ? 0 : i - 1
      next if s == :blank || shards[nxt] == :blank || shards[fst] == :blank
      check_three = [shards[i].shard,shards[nxt].shard,shards[fst].shard].sort
      sarray << lst[check_three] if lst.keys.include?(check_three)
    }
    sarray.compact
  end
  alias r2_galv_shards_ga_added_skills added_skills
  def added_skills
    r2_galv_shards_ga_added_skills + shard_linked_skills_three
  end
  def add_shard_actor(actor,amount)
    if actor == 0
      $game_party.leader.add_shard_level(amount)
    elsif actor > 0
      return if $game_actors[actor].nil?
      $game_actors[actor].add_shard_level(amount)
    end
  end
end

class Scene_Shards < Scene_MenuBase

  def do_shard_change
    learned = @actor.shard_linked_skills - @actor.known_links && @actor.shard_linked_skills_three - @actor.known_links
    forgot = @actor.known_links - @actor.shard_linked_skills && @actor.known_links - @actor.shard_linked_skills_three
    learn_usable = []
    forgot_usable = []
    learned.each { |sid|
      if @actor.added_skill_types.include?($data_skills[sid].stype_id)
        learn_usable << sid
      end
    }
    forgot.each { |sid|
      if @actor.added_skill_types.include?($data_skills[sid].stype_id)
        forgot_usable << sid
      end
    }

    @info_window.display(learn_usable,forgot_usable)
    @actor.known_links = @actor.shard_linked_skills && @actor.shard_linked_skills_three
  end

end
