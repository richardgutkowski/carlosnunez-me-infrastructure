def get_supported_environments
  require 'aws-sdk'
  s3_client = Aws::S3::Client.new
  our_buckets = s3_client.list_buckets
  Dir.glob('config/*.yaml').map do |file|
    file.split('.')[1]
  end
end
