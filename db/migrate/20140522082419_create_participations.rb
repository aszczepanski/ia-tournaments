class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :tournament_id
      t.integer :user_id

      t.timestamps
    end
    add_index :participations, :tournament_id
    add_index :participations, :user_id
    add_index :participations, [:tournament_id, :user_id], unique: true
  end
end
