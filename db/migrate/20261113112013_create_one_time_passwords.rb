class CreateOneTimePasswords < ActiveRecord::Migration[7.1]
  def change
    create_table :one_time_passwords, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.string :code, limit: 6, null: false
      t.integer :attempts, default: 0, null: false
      t.boolean :suspended, default: false, null: false

      t.timestamps
    end
  end
end
