class CreateEchoable < ActiveRecord::Migration
  def change
    create_table :echoables do |t|
      t.jsonb :data
      t.string :name

      t.timestamps
    end
  end
end
