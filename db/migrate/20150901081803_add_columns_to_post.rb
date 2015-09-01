class AddColumnsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :private_status, :boolean, default:false
    remove_column :posts, :remember_me
  end
end
