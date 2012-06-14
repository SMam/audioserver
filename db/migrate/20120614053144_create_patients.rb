class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :hp_id

      t.timestamps
    end
  end
end
