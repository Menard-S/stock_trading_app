class User < ApplicationRecord

  has_many :transactions
  has_many :portfolios

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :invitable

  enum role: { trader: 0, admin: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :email, :name, :asset, presence: true
  validates :yob, presence: true, numericality: { only_integer: true }
  validate :at_least_18

  before_create :generate_invitation_token_if_invited_by_admin
  before_validation :set_default_asset, on: :create
  
  after_initialize :set_default_role_and_status, if: :new_record?

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
    approved? ? :signed_in : :not_approved
  end

  private

  def block_from_invitation?
    false
  end

  def at_least_18
    if yob.present? && Date.today.year - yob < 18
      errors.add(:yob, 'You must be at least 18 years old to sign up.')
    end
  end

  def generate_invitation_token_if_invited_by_admin
    if invited_by_admin
      self.invitation_token = Devise.friendly_token
      self.invitation_created_at = Time.now.utc
      self.invitation_sent_at = Time.now.utc
    end
  end

  def set_default_asset
    self.asset ||= 0.0
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
end
