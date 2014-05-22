class Participation < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :user
  validates :tournament_id, presence: true
  validates :user_id, presence: true
end
