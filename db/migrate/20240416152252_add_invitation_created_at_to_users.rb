class AddInvitationCreatedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invitation_created_at, :datetime
  end
end