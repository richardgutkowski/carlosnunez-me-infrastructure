require 'net/http'
require 'open-uri'
require 'zip'

def install_latest_version_of_terraform!
  os = get_supported_terraform_os_build
  if os == "unsupported"
    raise "Terraform is not supported by your operating system."
  end

  cpu_platform = get_supported_cpu_platform
  if cpu_platform == "unsupported"
    raise "Terraform is not supported by your CPU platform."
  end

  latest_terraform_release_uri = get_latest_terraform_release os:os, cpu_platform:cpu_platform
  download_terraform_to_working_directory! uri_as_string:latest_terraform_release_uri
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

def get_latest_terraform_release(os: ,cpu_platform:)
  terraform_releases_uri = 'https://releases.hashicorp.com/terraform'
  terraform_releases_html = do_http_get_with_forwards! uri:terraform_releases_uri
  terraform_releases_html = Net::HTTP.get(URI(terraform_releases_uri)).split("\n")
  terraform_versions = terraform_releases_html.map do |html_node|
    version = html_node.gsub!  /.*>(terraform_.*)<.*/,'\1'
    version
  end.compact
  _, latest_version = terraform_versions.first.split('_')
  latest_terraform_release_uri = \
    "#{terraform_releases_uri}/#{latest_version}/terraform_#{latest_version}_#{os}_#{cpu_platform}.zip"
  latest_terraform_release_uri
end

def do_http_get_with_forwards!(uri:, redirect_limit: 10)
  loop do
    break if redirect_limit == 0
    uri_with_data = URI(uri)
    request = Net::HTTP::Get.new(uri_with_data)
    response = Net::HTTP.start(uri_with_data.host, uri_with_data.port) do |session|
      session.request(request)
    end
    case response
    when Net::HTTPSuccess then response
    when Net::HTTPRedirection then
      do_http_get_with_forwards! uri: response['location'], redirect_limit: redirect_limit-1
    else
      response.error!
    end
  end
end

def download_terraform_to_working_directory!(uri_as_string:)
  file_name = "terraform.zip"
  uri = URI(uri_as_string)
  uri_host_with_scheme = "#{uri.scheme}://#{uri.host}"
  Net::HTTP.start(uri_host_with_scheme) do |session|
    response = session.get(uri.request_uri)
    open(file_name, 'wb') do |file|
      file.write(response.body)
    end
  end
  Zip::ZipFile.open(file_name) do |zip_file|
    zip_file.each do |file|
      zip_file.extract file, Dir.pwd
    end
  end
end
