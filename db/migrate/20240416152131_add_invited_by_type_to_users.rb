class AddInvitedByTypeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invited_by_type, :string
  end
end
