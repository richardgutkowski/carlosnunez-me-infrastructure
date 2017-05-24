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
  if latest_terraform_release_uri == "NOT_FOUND"
    raise "Couldn't retrieve latest the link to the latest version of Terraform. You'll need to install it manually."
  end
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
  if terraform_versions.empty?
    return "NOT_FOUND"
  end
  _, latest_version = terraform_versions.first.split('_')
  latest_terraform_release_uri = \
    "#{terraform_releases_uri}/#{latest_version}/terraform_#{latest_version}_#{os}_#{cpu_platform}.zip"
  latest_terraform_release_uri
end

def do_http_get_with_forwards!(uri:, redirects_remaining: 10)
  raise "Too many redirects to uri #{uri}" if redirects_remaining == 0
  uri_object = URI(uri)
  response = Net::HTTP.get_response(uri_object)
  if response.code == "301" or response.code == "302"
    uri_object_to_visit_next = URI.parse(response.header['location'])
    if uri_object_to_visit_next.hostname.to_s == ""
      uri_to_visit_next = \
        "#{uri_object.scheme}://#{uri_object.hostname}/#{uri_object_to_visit_next.to_s}"
    else
      uri_to_visit_next = uri_object_to_visit_next.to_s
    end
    require 'pry'
    binding.pry
    do_http_get_with_forwards! uri: uri_to_visit_next, \
      redirects_remaining: redirects_remaining-1
  end
  response.body
end

def create_uri(scheme:, hostname:, path:)
  case scheme.downcase
  when 'http'
    URI::HTTP.build {
      :host => hostname,
      :path => path
    }
  when 'https'
    URI::HTTPS.build {
      :host => hostname,
      :path => path
    }
  else
    nil
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
