class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name, null: false, index: true

      t.timestamps null: false
    end
  end
end
