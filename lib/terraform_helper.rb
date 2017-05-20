require 'net/http'
require 'open-uri'

def install_latest_version_of_terraform!
  os = get_supported_terraform_os_build
  if os == "unsupported"
    raise "Terraform is not supported by your operating system."
  end

  cpu_platform = get_supported_cpu_platform
  if cpu_platform == "unsupported"
    raise "Terraform is not supported by your CPU platform."
  end

  latest_terraform_release_uri = get_latest_terraform_release os:os,cpu_platform:cpu_platform
  terraform_binary = open("https://releases.hashicorp.com/terraform/#{latest_version}/#{terraform_file_to_get}")
end

private
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

def get_supported_cpu_platform
  case RUBY_PLATFORM
  when /x86_64/
    "amd64"
  when /i686/
    "386"
  else
    "unsupported"
  end
end

def get_latest_terraform_release(os,cpu_platform)
  terraform_releases_uri = 'https://releases.hashicorp.com'
  terraform_releases_html = Net::HTTP.get(URI(terraform_releases_uri)).split("\n")
  terraform_versions = terraform_releases_html.map do |html_node|
    version = html_node.gsub!  /.*>(terraform_.*)<.*/,'\1'
    version
  end.compact
  _, latest_version = terraform_versions.first.split('_')
  latest_terraform_release_uri = \
    "#{terraform_releases_uri}/terraform/#{latest_version}/terraform_#{latest_version}_#{os}_#{cpu_platform}.zip"
  latest_terraform_release_uri
end

def download_file_to_working_directory(uri, file_name)
end
