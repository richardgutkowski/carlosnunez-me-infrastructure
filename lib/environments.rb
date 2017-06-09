def get_supported_environments
  require 'aws-sdk'
  return nil if !ENV['AWS_S3_TERRAFORM_TFVARS_BUCKET']
  bucket_to_query = ENV['AWS_S3_TERRAFORM_TFVARS_BUCKET'].split('/')[0]
  s3_client = Aws::S3::Client.new
  objects_in_infrastructure_bucket = s3_client.list_objects(bucket: bucket_to_query)
  tfvars_found = objects_in_infrastructure_bucket.contents.select do |s3_object|
    s3_object.key.include? 'tfvars/'
  end.map(&:key)
  environments_found = tfvars_found.map do |s3_object_key|
    s3_object_key.split('/')[1]
  end
  environments_found.uniq
end
