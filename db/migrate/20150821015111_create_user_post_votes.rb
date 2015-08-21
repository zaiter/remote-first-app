class CreateUserPostVotes < ActiveRecord::Migration
  def change
    create_table :user_post_votes do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
