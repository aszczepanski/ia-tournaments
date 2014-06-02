class Sponsor < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "250x250>", :thumb => "80x80>" }
  validates_attachment_presence :logo
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :logo, :in => 0..100.kilobytes

  belongs_to :tournament
  validates :tournament, presence: true

  validates :name, presence: true
end
