Rails.application.config.middleware.use OmniAuth::Builder do
  provider :evesso,
    Rails.application.secrets.evesso_client_id,
    Rails.application.secrets.evesso_secret_key
end
