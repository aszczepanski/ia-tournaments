class Tournament < ActiveRecord::Base
  belongs_to :organizer, class_name: "User"
  default_scope -> { order('date') }
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

  def is_contestant?(user)
    participations.find_by(user_id: user.id)
  end

  def add_contestant!(user)
    participations.create!(user_id: user.id)
  end

  def joinable?
    contestants.size < max_number_of_contestants # TODO add deadline limit
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
end
