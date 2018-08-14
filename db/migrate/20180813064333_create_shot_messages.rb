class CreateShotMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :shot_messages do |t|
      t.belongs_to :user, foreign_key: true
      t.string :content
      t.string :code
      t.string :aasm_state
      t.integer :retries
      t.string :phone
      t.datetime :next_at

      t.timestamps
    end
  end
end
