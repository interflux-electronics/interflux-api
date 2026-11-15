class CreateRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :refresh_tokens, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :token, null: false, index: { unique: true }
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
