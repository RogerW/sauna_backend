class CreateShotMessagesTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :shot_messages_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
