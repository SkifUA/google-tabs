class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.find_from_omniauth(auth)
    return false unless auth.info.email

    user = User.find_or_initialize_by(email: auth.info.email)

    user.email = auth.info.email
    user.last_name ||= auth.info.last_name
    user.first_name ||= auth.info.first_name

    user.google_access_token = auth.credentials.token
    user.google_refresh_token = auth.credentials.refresh_token
    user.password = user.password_confirmation = SecureRandom.base64(12) if user.id.nil?

    user.save!
    user
  end

end
