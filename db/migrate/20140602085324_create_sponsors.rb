class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.integer :tournament_id

      t.timestamps
    end
  end
end
