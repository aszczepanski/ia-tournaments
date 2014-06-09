class AddMapsParametersToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :address, :string
    add_column :tournaments, :latitude, :float
    add_column :tournaments, :longitude, :float
    add_column :tournaments, :gmaps, :boolean
  end
end
