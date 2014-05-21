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
end
