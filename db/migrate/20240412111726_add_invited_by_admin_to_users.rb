class AddInvitedByAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invited_by_admin, :boolean, default: :false, null: :false
  end
end
