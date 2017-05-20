require 'net/http'

def install_latest_version_of_terraform
  terraform_releases_uri = URI('https://releases.hashicorp.com')
  terraform_releases_html = Net::HTTP.get(terraform_releases_uri).split("\n")
  terraform_versions = terraform_releases_html.map do |html_node|
    version = html_node.gsub!  /.*>(terraform_.*)<.*/,'\1'
    version
  end.compact
end
