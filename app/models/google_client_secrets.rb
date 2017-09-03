class GoogleClientSecrets
  require 'google/api_client/client_secrets.rb'

  def self.secrets(user)
    Google::APIClient::ClientSecrets.new({
      web: { access_token: user.google_access_token,
              refresh_token: user.google_refresh_token,
              client_id: ENV['GOOGLE_CLIENT_ID'],
              client_secret: ENV['GOOGLE_CLIENT_SECRET']
      }
    })
  end
end

