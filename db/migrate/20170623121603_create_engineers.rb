class CreateEngineers < ActiveRecord::Migration[5.0]
  def change
    create_table :engineers do |t|
      t.string :login, unique: true, index: true, null: false
      t.string :avatar_url

      t.timestamps
    end
  end
end
