class AddSeedingNumberToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :seeding_number, :integer, null: false, default: 0
  end
end
