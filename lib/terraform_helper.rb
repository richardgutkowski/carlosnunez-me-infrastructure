require 'net/http'

def get_supported_terraform_os_build
  case RUBY_PLATFORM
  when /win32/
    "windows"
  when /darwin/
    "darwin"
  when /linux/
    "linux"
  when /openbsd/
    "openbsd"
  when /solaris/
    "solaris"
  else
    "unsupported"
  end
end

def install_latest_version_of_terraform
  os = get_supported_terraform_os_build
  if os == "unsupported"
    raise "Terraform is not supported by your OS [#{RUBY_PLATFORM}]."
  end
  terraform_releases_uri = URI('https://releases.hashicorp.com')
  terraform_releases_html = Net::HTTP.get(terraform_releases_uri).split("\n")
  terraform_versions = terraform_releases_html.map do |html_node|
    version = html_node.gsub!  /.*>(terraform_.*)<.*/,'\1'
    version
  end.compact
  latest_version = terraform_versions.first

end
