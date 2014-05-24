class Participation < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :user
  validates :tournament, presence: true
  validates :user, presence: true
  validates :tournament_id, uniqueness: { scope: :user_id }
  validates :user_rank_position, presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                uniqueness: { scope: :tournament_id }
  validates :user_license_id, presence: true,
                numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                uniqueness: { scope: :tournament_id }
  validate :can_join

  private

    def can_join
      if !self.tournament.joinable?
        errors.add :tournament, "limits exceeded"
      end
    end
end
