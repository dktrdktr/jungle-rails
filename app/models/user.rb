class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true
  
  def self.authenticate_with_credentials(email, password)
    user = User.find_by_email(email.downcase.strip)
    if user && user.authenticate(password)
      return user
    end
    nil
  end
  
end
