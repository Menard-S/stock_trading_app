class User < ApplicationRecord

  has_many :transactions
  has_many :portfolios

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :invitable

  enum role: { trader: 0, admin: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :email, presence: true
  validates :name, presence: true
  validates :yob, presence: true, numericality: { only_integer: true }
  validate :at_least_18

  before_create :generate_invitation_token, if: -> { invited_by_admin }
  before_validation :set_default_asset, on: :create
  
  after_initialize :set_default_role_and_status, if: :new_record?
  after_create :send_admin_mail, :send_pending_approval_email

  def active_for_authentication? 
    super && approved?
  end 

  def inactive_message 
    approved? ? super : :not_approved
  end

  def deactivate!
    update(status: 'rejected')
  end
  

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(10)
    self.invitation_sent_at = Time.current
  end
  
  def send_invitation_email
    UserMailer.invitation_email(self).deliver_now
  end

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
  
  def set_default_asset
    self.asset ||= 0
  end
end
