class Match < ActiveRecord::Base
  belongs_to :tournament

  def to_string
    pow = tournament.first_round_contestants_ceiling
    str = "[#{inner_id}]"
    left_user = tournament.participations.find_by(id: left_user_id).user if left_user_id
    if left_user
      str += " #{left_user.full_name}"
    else
      if inner_id > pow/2
        str += " [winner #{pow-((pow-inner_id)*2+1)}]"
      else
        str += " [free]"
      end
    end
    str += " vs "
    right_user = tournament.participations.find_by(id: right_user_id).user if right_user_id
    if right_user
      str += " #{right_user.full_name}"
    else
      if inner_id > pow/2
        str += "[winner #{pow-((pow-inner_id)*2)}]"
      else
        str += "[free]"
      end
    end
    return str
  end

  def left_user_to_string
    user = left_user
    if user
      return "name", user.full_name
    else
      pow = tournament.first_round_contestants_ceiling
      if inner_id > pow/2
        return "match", "#{pow-((pow-inner_id)*2+1)}"
      else
        return "free", "free"
      end
    end
  end

  def right_user_to_string
    user = right_user
    if user
      return "name", user.full_name
    else
      pow = tournament.first_round_contestants_ceiling
      if inner_id > pow/2
        return "match", "#{pow-((pow-inner_id)*2)}"
      else
        return "free", "free"
      end
    end
  end

  def user_names
    left_user_name = left_user.full_name if left_user
    right_user_name = right_user.full_name if right_user
    return { left_user_id => left_user_name, right_user_id => right_user_name }
  end

  def participates?(user)
    left_user == user || right_user == user
  end

  def left_user
    tournament.participations.find_by(id: left_user_id).user if left_user_id
  end

  def right_user
    tournament.participations.find_by(id: right_user_id).user if right_user_id
  end

  def is_ready?
    left_user_id && right_user_id && tournament.date.localtime < Time.zone.now
  end

  def add_winner(user, winner_name)
    if left_user.full_name == user.full_name
      if left_user.full_name == winner_name
        update_attributes(left_user_winner_id: left_user_id)
      elsif right_user.full_name == winner_name
        update_attributes(left_user_winner_id: right_user_id)
      end
    elsif right_user.full_name == user.full_name
      if left_user.full_name == winner_name
        update_attributes(right_user_id_winner: left_user_id)
      elsif right_user.full_name == winner_name
        update_attributes(right_user_id_winner: right_user_id)
      end
    end

    if left_user_winner_id && right_user_id_winner
      if left_user_winner_id == right_user_id_winner
        pow = tournament.first_round_contestants_ceiling
        if inner_id < pow-1
          if inner_id % 2 == 1
            next_id = (inner_id + pow + 1) / 2
            tournament.matches.find_by(inner_id: next_id)
                .update_attributes(left_user_id: left_user_winner_id)
          else
            next_id = (inner_id + pow) / 2
            tournament.matches.find_by(inner_id: next_id)
                .update_attributes(right_user_id: left_user_winner_id)
          end
        end
      else
        update_attributes(left_user_winner_id: nil, right_user_id_winner: nil)
      end
    end  
  end
  
  def has_winner?
    left_user_winner_id && right_user_id_winner
  end

  def winner_name
    if left_user_winner_id && right_user_id_winner && left_user_winner_id == right_user_id_winner
      tournament.participations.find_by(id: left_user_winner_id).user.full_name
    end
  end

  def user_added_winner?(user)
    if left_user == user && left_user_winner_id
      return true
    elsif right_user == user && right_user_id_winner
      return true
    else
      return false
    end
  end
end
