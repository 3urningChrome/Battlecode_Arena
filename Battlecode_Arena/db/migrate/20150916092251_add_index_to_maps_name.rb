class AddIndexToMapsName < ActiveRecord::Migration
  def change
    add_index :maps, :name, unique:true
  end
end
