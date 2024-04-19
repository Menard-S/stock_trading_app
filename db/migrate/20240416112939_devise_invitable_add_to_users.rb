class DeviseInvitableAddToUsers < ActiveRecord::Migration[7.1]
  
  def up
    change_table :users do |t|
      t.string     :invitation_token unless column_exists?(:users, :invitation_token)
      t.datetime   :invitation_created_at unless column_exists?(:users, :invitation_created_at)
      t.datetime   :invitation_sent_at unless column_exists?(:users, :invitation_sent_at)
      t.datetime   :invitation_accepted_at unless column_exists?(:users, :invitation_accepted_at)
      t.integer    :invitation_limit unless column_exists?(:users, :invitation_limit)
      unless column_exists?(:users, :invited_by_id) && column_exists?(:users, :invited_by_type)
      t.references :invited_by, polymorphic: true
      end
      t.integer    :invitations_count, default: 0 unless column_exists?(:users, :invitations_count)
      t.index      :invitation_token, unique: true unless index_exists?(:users, :invitation_token, unique: true)
      t.index      :invited_by_id unless index_exists?(:users, :invited_by_id)
    end
  end

  def down
    change_table :users do |t|
      if column_exists?(:users, :invited_by_id) && column_exists?(:users, :invited_by_type)
        t.remove_references :invited_by, polymorphic: true
      end
      t.remove :invitations_count if column_exists?(:users, :invitations_count)
      t.remove :invitation_limit if column_exists?(:users, :invitation_limit)
      t.remove :invitation_sent_at if column_exists?(:users, :invitation_sent_at)
      t.remove :invitation_accepted_at if column_exists?(:users, :invitation_accepted_at)
      t.remove :invitation_token if column_exists?(:users, :invitation_token)
      t.remove :invitation_created_at if column_exists?(:users, :invitation_created_at)
    end
  end
end
