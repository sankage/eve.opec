Rails.application.config.middleware.use OmniAuth::Builder do
  provider :evesso, ENV['EVESSO_CLIENT_ID'], ENV['EVESSO_SECRET_KEY']
end
