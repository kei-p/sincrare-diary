require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'
require 'fog/aws'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        provider: 'AWS',
        aws_access_key_id: ENV['S3_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
        region: ENV['S3_REGION']
    }

    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_public = false
  else
    config.storage :file
    config.asset_host = "http://localhost:3000"
  end
end