require 'json'
require 'net/http'

def obtain_latest_coreos_version_and_ami!
  coreos_ami_release_feed_uri = "https://coreos.com/dist/aws/aws-stable.json"
  coreos_ami_releases_raw = 
    Net::HTTP.get(URI.parse(coreos_ami_release_feed_uri))
  coreos_ami_releases_json = JSON.parse(coreos_ami_releases_raw)

  ami_data_to_return = {}
  ami_data_to_return[:latest_version] = 
    coreos_ami_releases_json['release_info']['version']

  # this is a tad confusing without understanding that .delete deletes the key
  # provided from the hash in place.
  _ = coreos_ami_releases_json.delete 'release_info'
  ami_data_to_return.merge! coreos_ami_releases_json

  return ami_data_to_return
end
