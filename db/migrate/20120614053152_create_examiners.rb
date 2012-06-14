class CreateExaminers < ActiveRecord::Migration
  def change
    create_table :examiners do |t|
      t.string :worker_id

      t.timestamps
    end
  end
end
