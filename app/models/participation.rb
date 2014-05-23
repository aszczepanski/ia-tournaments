class Participation < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :user
  validates :tournament_id, presence: true
  validates :user_id, presence: true
  validates :tournament_id, uniqueness: { scope: :user_id }
end
