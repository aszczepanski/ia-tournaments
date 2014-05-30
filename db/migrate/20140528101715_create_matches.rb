class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :tournament_id
      t.integer :inner_id
      t.integer :left_user_id
      t.integer :left_user_winner_id
      t.integer :right_user_id
      t.integer :right_user_id_winner

      t.timestamps
    end
    add_index :matches, :tournament_id
    add_index :matches, [:tournament_id, :inner_id], unique: true
  end
end
