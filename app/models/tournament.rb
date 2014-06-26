require 'ostruct'

class Tournament < ActiveRecord::Base
  belongs_to :organizer, class_name: "User"
  default_scope -> { order('date') }
  scope :name_like, ->(search) { where("name LIKE ?", "%#{search}%") }
  validates :organizer_id, presence: true
  validates :name, presence: true, length: { minimum: 4 }
  validates :date, presence: true
  validates :deadline, presence: true
  validate :date_date_cannot_be_in_past,
           :deadline_date_cannot_be_in_past,
           :deadline_has_to_be_before_date

  validates :max_number_of_contestants, presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :seeding_number, presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 0,
                                less_than_or_equal_to: :max_number_of_contestants }

  has_many :participations, dependent: :destroy

  has_many :contestants, through: :participations, source: :user

  validate :contestants_limits

  has_many :matches

  has_many :sponsors

  validates :address, presence: true
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def is_contestant?(user)
    participations.find_by(user_id: user.id)
  end

  def add_contestant!(user)
    participations.create!(user_id: user.id)
  end

  def joinable?
    contestants.size < max_number_of_contestants && deadline.localtime > Time.zone.now
  end

  def has_winner?
    pow = first_round_contestants_ceiling
    if matches.count > 0
      matches.find_by(inner_id: pow-1).has_winner?
    else
      false
    end
  end

  def winner_name
    pow = first_round_contestants_ceiling
    matches.find_by(inner_id: pow-1).winner_name
  end

  def generate_matches
    pow = next_power_of_2 contestants.size
    participations.order('user_rank_position').each_with_index do |p, index|
      if index < pow/2
        match = matches.create!(inner_id: index+1, left_user_id: p.id,
                left_user_winner_id: p.id, right_user_id_winner: p.id)
      else
        match = matches.find_by(inner_id: index+1-pow/2)
        match.update_attributes(right_user_id: p.id,
                left_user_winner_id: nil, right_user_id_winner: nil)
      end
    end

    for i in pow/2+1..pow-1 do
      match = matches.create!(inner_id: i)
      left_match = matches.find_by(inner_id: (pow-((pow-i)*2+1)))
      if left_match.has_winner?
        match.update_attributes(left_user_id: left_match.left_user_winner_id)
      end
      right_match = matches.find_by(inner_id: (pow-((pow-i)*2)))
      if right_match.has_winner?
        match.update_attributes(right_user_id: right_match.left_user_winner_id)
      end
    end
  end

  def cancel_matches
    matches.each do |match|
      match.destroy
    end
  end

  def user_next_match(user)
    participation = participations.find_by(user_id: user.id)
    return nil if !participation
    left = matches.order('inner_id DESC').find_by(left_user_id: participation.id)
    right = matches.order('inner_id DESC').find_by(right_user_id: participation.id)
    match = nil
    if !right
      match = left
    elsif !left
      match = right
    elsif left.inner_id > right.inner_id
      match = left
    else
      match = right
    end
    
    if !match || match.has_winner?
      return nil
    else
      return match
    end
  end

  def print_matches
    pow = next_power_of_2 contestants.size
    ar = []
    matches.order('inner_id').each do |match|
      line = "#{match.inner_id}"
      print "#{match.inner_id}"
      left_user = participations.find_by(id: match.left_user_id).user if match.left_user_id
      if left_user
        line += " #{left_user.full_name}"
        print " #{left_user.full_name}"
      else
        if match.inner_id > pow/2
          line += " [winner #{pow-((pow-match.inner_id)*2+1)}]"
          print " [winner #{pow-((pow-match.inner_id)*2+1)}]"
        else
          line += " [free]"
          print " [free]"
        end
      end
      line += " - "
      right_user = participations.find_by(id: match.right_user_id).user if match.right_user_id
      if right_user
        line += " #{right_user.full_name}"
        print " #{right_user.full_name}"
      else
        if match.inner_id > pow/2
          line += "[winner #{pow-((pow-match.inner_id)*2)}]"
          print "[winner #{pow-((pow-match.inner_id)*2)}]"
        else
          line += "[free]"
          print "[free]"
        end
      end
      ar.append line
    end
    return ar
  end

  def first_round_contestants_ceiling
    next_power_of_2 contestants.size
  end

  private

    def date_date_cannot_be_in_past
      if date.present? && date.localtime < Time.zone.now
        errors.add :date, "can't be in the past"
      end
    end

    def deadline_date_cannot_be_in_past
      if deadline.present? && deadline.localtime < Time.zone.now
        errors.add :deadline, "can't be in the past"
      end
    end

    def deadline_has_to_be_before_date
      if date.present? && deadline.present? && date < deadline
        errors.add :base, "Date can't be before deadline"
      end
    end

    def contestants_limits
      if contestants.size > max_number_of_contestants
        errors.add :max_number_of_contestants, "already exceeded"
      end
    end

    def next_power_of_2(number)
      pow = 2
      while pow < number
        pow *= 2
      end
      return pow
    end
end
