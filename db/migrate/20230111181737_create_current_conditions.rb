class CreateCurrentConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :current_conditions do |t|
      t.integer :epoch_time, null: false
      t.datetime :local_observation_date_time
      t.jsonb :content, null: false, default: {}

      t.timestamps
    end
  end
end
