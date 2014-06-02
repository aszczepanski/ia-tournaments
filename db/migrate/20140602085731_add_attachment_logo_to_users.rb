class AddAttachmentLogoToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :sponsors, :logo
  end

  def self.down
    remove_attachment :sponsors, :logo
  end
end
