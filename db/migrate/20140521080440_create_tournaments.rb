class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :organizer_id
      t.datetime :date
      t.datetime :deadline

      t.timestamps
    end
    add_index :tournaments, [:organizer_id, :date]
  end
end
