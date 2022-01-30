require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|

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
end

  # 日本語ファイル名の設定
  # CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/


  
