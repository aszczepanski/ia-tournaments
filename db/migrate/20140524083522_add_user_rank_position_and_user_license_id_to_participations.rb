class AddUserRankPositionAndUserLicenseIdToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :user_rank_position, :integer
    add_column :participations, :user_license_id, :integer
    add_index :participations, [:tournament_id, :user_rank_position], unique: true
    add_index :participations, [:tournament_id, :user_license_id], unique: true
  end
end
