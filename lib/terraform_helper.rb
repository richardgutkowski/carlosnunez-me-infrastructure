require 'net/http'

def install_latest_version_of_terraform
  terraform_releases_uri = URI('https://releases.hashicorp.com')
  if ENV['TERRAFORM_RELEASES_URI']
    terraform_releases_uri = URI(ENV['TERRAFORM_RELEASES_URI'])
  end
  terraform_releases_html = Net::HTTP.get(URI('https://releases.hashicorp.com'))
end
