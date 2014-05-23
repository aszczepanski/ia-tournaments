class AddMaxNumberOfContestantsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :max_number_of_contestants, :integer, null: false, default: 0
  end
end
