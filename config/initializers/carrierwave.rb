CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'],
      path_style: true
    }
  else
    config.asset_host = "http://localhost:3001" #バックエンド側のドメイン名
    # config.asset_host = ENV['BACKEND_LOCAL_DOMAIN'],
    config.storage = :file
    config.cache_storage = :file
  end
end