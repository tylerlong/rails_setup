# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :username, :name, :password, :password_confirmation

  has_secure_password

  before_save :create_remember_token
  before_validation :create_name

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }

  EMAIL_REGEX = /\A[_a-z0-9-]+(?:\.[_a-z0-9-]+)*@[a-z0-9-]+(?:\.[a-z0-9-]+)*(?:\.[a-z]{2,3})\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: { with: EMAIL_REGEX }, length: { minimum: 3, maximum: 100 }

  USERNAME_REGEX = /\A[0-9a-z]{3,50}\z/i
  validates :username, presence: true, uniqueness: { case_sensitive: false },
    format: { with: USERNAME_REGEX }, length: { minimum: 3, maximum: 50 }

  validates :password, length: { minimum: 6, maximum: 100 }

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def create_name
      self.name = self.username if self.name.blank?
    end
end