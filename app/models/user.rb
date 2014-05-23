class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :forename, presence: true
  validates :surname, presence: true

  validates :max_number_of_contestants, presence: true

  has_many :tournaments, foreign_key: :organizer_id, dependent: :destroy

  has_many :participations, dependent: :destroy # TODO maybe change it
  has_many :participated_tournaments, through: :participations, source: :tournament

  def full_name
    "#{self.forename} #{self.surname}"
  end

end
