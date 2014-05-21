class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :forename, presence: true
  validates :surname, presence: true

  has_many :tournaments, foreign_key: :organizer_id, dependent: :destroy
  validates_associated :tournaments

  def full_name
    "#{self.forename} #{self.surname}"
  end

end
