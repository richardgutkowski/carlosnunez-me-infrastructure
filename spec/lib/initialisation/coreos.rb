require 'json'
require 'net/http'

def obtain_latest_coreos_version_and_ami!
  coreos_ami_release_feed_uri = "https://coreos.com/dist/aws/aws-stable.json"
  coreos_ami_releases_raw = 
    Net::HTTP.get(URI.parse(coreos_ami_release_feed_uri))
  coreos_ami_releases_json = JSON.parse(coreos_ami_releases_raw)

  $latest_coreos_ami_details = {}
  $latest_coreos_ami_details[:latest_version] = 
    coreos_ami_releases_json['release_info']['version']

  # this is a tad confusing without understanding that .delete deletes the key
  # provided from the hash in place.
  _ = coreos_ami_releases_json.delete 'release_info'
  $latest_coreos_ami_details.merge! coreos_ami_release_json

  return $latest_coreos_ami_details
end
