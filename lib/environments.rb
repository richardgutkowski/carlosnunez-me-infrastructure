def get_supported_environments
  require 'aws-sdk'
  return nil if !ENV['AWS_S3_INFRASTRUCTURE_BUCKET']
  s3_client = Aws::S3::Client.new
  objects_in_infrastructure_bucket =
    s3_client.list_objects(bucket: ENV['AWS_S3_INFRASTRUCTURE_BUCKET'])
  tfvars_found = objects_in_infrastructure_bucket.select do |s3_object|
    s3_object.key.include? 'tfvars/'
  end.map(&:key)
  environments_found = tfvars_found.map do |s3_object_key|
    s3_object_key.split('/')[1]
  end
  environments_found.uniq
end
