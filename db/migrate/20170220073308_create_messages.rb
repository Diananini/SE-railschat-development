class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user, index: true, foreign_key: true
      t.references :chat, index: true, foreign_key: true
      t.timestamps null: false
      t.float  :positive, :default => 0.0
      t.float  :negative, :default => 0.0
    end
  end
end
