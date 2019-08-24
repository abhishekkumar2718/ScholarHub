class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.integer :inviter_id
      t.integer :invitee_id

      t.timestamps
    end
  end
end
