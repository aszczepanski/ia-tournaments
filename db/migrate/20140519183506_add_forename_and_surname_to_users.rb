class AddForenameAndSurnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :forename, :string, null: false, default: ""
    add_column :users, :surname, :string, null: false, default: ""
  end
end
