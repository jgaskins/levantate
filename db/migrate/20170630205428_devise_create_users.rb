class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :provider
      t.string :uid

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.references :engineer, type: :uuid
      t.timestamps null: false
    end

    add_foreign_key :users, :engineers, index: true, column: :engineer_id

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
