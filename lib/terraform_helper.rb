require 'net/http'

def install_latest_version_of_terraform
  terraform_releases_uri = URI('https://releases.hashicorp.com')
  terraform_releases_html = Net::HTTP.get(terraform_releases_uri)
end
