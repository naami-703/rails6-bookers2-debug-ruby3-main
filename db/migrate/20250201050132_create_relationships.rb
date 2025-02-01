class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      
      # フォローするユーザーのid
      t.integer :follower_id
      # フォローされるユーザーのid
      t.integer :followed_id

      t.timestamps
    end
  end
end
