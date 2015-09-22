
CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET_KEY'],
    #:region                => 'Oregon',
    :region                 => 'us-west-2', 
 #   :host                  => 'https://s3-us-west-2.amazonaws.com'
  }
  config.fog_directory     =  'battlecodearena'
end