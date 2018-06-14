class AddIsLegendToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_legend, :boolean
  end
end
