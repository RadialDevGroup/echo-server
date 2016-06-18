class AddSessionIdToEchoable < ActiveRecord::Migration
  def change
    add_column :echoables, :session_id, :string
  end
end
