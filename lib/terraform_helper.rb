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
  download_terraform_into_working_directory! uri_as_string:latest_terraform_release_uri
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
    referred_uri = URI.parse(response.header['location'])
    if not referred_uri.hostname
      next_uri = create_uri scheme: uri_object.scheme, \
        hostname: uri_object.hostname, \
        path: referred_uri.path
    else
      next_uri = create_uri scheme: referred_uri.scheme, \
        hostname: referred_uri.hostname, \
        path: referred_uri.path
    end
    do_http_get_with_forwards! uri: next_uri.to_s, \
      redirects_remaining: redirects_remaining-1
  else
    response.body.split("\n")
  end
end

def create_uri(scheme:, hostname:, path:)
  case scheme.downcase
  when 'http'
    URI::HTTP.build({
      :host => hostname,
      :path => path
    })
  when 'https'
    URI::HTTPS.build({
      :host => hostname,
      :path => path
    })
  else
    nil
  end
end   

def download_terraform_into_working_directory!(uri_as_string:)
  file_name = "terraform.zip"
  uri = URI(uri_as_string)
  session = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme == 'https'
    session.use_ssl == true
  end
  session.start do |session|
    request = Net::HTTP::Get.new uri
    require 'pry'
    binding.pry
    session.request request do |response|
      open file_name, 'w' do |file_handle|
        response.read_body do |chunk|
          file_handle.write chunk
        end
      end
    end
  end

  Zip::ZipFile.open(file_name) do |zip_file|
    zip_file.each do |file|
      zip_file.extract file, Dir.pwd
    end
  end
end
