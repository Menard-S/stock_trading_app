class ChangeYobColumnInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :yob, true
  end
end
