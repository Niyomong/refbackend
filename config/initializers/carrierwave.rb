require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? # 本番環境の場合はS3へアップロード
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory = ENV['S3_BUCKET']
    
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1',
      path_style: true
    }

    config.asset_host = ENV['AWS_S3_URL_HOST']

  else # 本番環境以外の場合はアプリケーション内にアップロード
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end

  # 日本語ファイル名の設定
  # CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/


  
