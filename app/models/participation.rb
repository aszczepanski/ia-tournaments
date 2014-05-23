class Participation < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :user
  validates :tournament, presence: true
  validates :user, presence: true
  validates :tournament_id, uniqueness: { scope: :user_id }
  validate :can_join

  private

    def can_join
      if !self.tournament.joinable?
        errors.add :tournament, "limits exceeded"
      end
    end
end
