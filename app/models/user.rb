class User < ApplicationRecord
  has_many :transactions
  has_many :portfolios

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  enum role: { trader: 0, admin: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :email, presence: true
  validates :name, presence: true
  validates :yob, presence: true, numericality: { only_integer: true }
  validate :at_least_18

  after_initialize :set_default_role_and_status, if: :new_record?
  # after_create :send_admin_mail, :send_pending_approval_email
  after_create_commit do
    if invitation_token.present?  # Check if this was an invited user
        @invited_user = self
        AdminMailer.new_user_invitation_notice(@invited_user).deliver_now
    else  # Regular user creation scenario
        send_admin_mail
        send_pending_approval_email
    end
  end 

  def active_for_authentication? 
    super && approved?
  end 

  def inactive_message 
    approved? ? super : :not_approved
  end

  private

  def at_least_18
    if yob.present? && Date.today.year - yob < 18
      errors.add(:yob, 'You must be at least 18 years old to sign up.')
    end
  end

  def set_default_role_and_status
    self.role ||= :trader
    self.status ||= :pending
  end

  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver_now
  end

  def send_pending_approval_email
    UserMailer.pending_approval(self).deliver_now
  end

  def invite_user
    super if defined?(super) 
  end
end
