class RemoveGmapsFromTournaments < ActiveRecord::Migration
  def change
    remove_column :tournaments, :gmaps, :boolean
  end
end
