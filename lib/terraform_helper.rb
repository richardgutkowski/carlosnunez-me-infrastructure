require 'net/http'
require 'open-uri'
require 'zip'
require 'fileutils'

def lint_terraform_configurations_in_this_directory
  lint_result = `\$PWD/terraform validate 2>&1`
  lint_successful = false
  if lint_result.empty?
    lint_successful = true
  end
  return lint_successful, lint_result
end

def install_specific_version_of_terraform_into_working_directory!(version:)
  install_terraform_into_working_directory! version:version
end

def install_latest_version_of_terraform_into_working_directory!
  install_terraform_into_working_directory! version:'latest'
end

def install_terraform_into_working_directory!(version:)
  os = get_supported_terraform_os_build
  if os == "unsupported"
    raise "Terraform is not supported by your operating system."
  end

  cpu_platform = get_supported_cpu_platform
  if cpu_platform == "unsupported"
    raise "Terraform is not supported by your CPU platform."
  end

  if version == 'latest'
    terraform_release_details = get_latest_terraform_release os:os, cpu_platform:cpu_platform
  else
    terraform_release_details = get_specific_terraform_release os:os, \
      cpu_platform:cpu_platform, \
      version:version
  end
  terraform_version = terraform_release_details[:version]
  terraform_release_uri = terraform_release_details[:version_uri]
  if terraform_release_uri == "NOT_FOUND"
    raise "Couldn't retrieve version #{version} of Terraform. You'll need to install it manually."
  end

  if version == 'latest'
    file_name_to_use = ''
    is_latest = true
  else
    file_name_to_use = 'old_terraform.zip'
    is_latest = false
  end
  download_terraform_into_working_directory! uri_as_string:terraform_release_uri, \
    file_name:file_name_to_use
  if not terraform_installed_successfully? is_latest:is_latest, version_expected:terraform_version
    raise "Terraform #{terraform_version} not updated successfully. You'll need to install it manually."
  end
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

def get_specific_terraform_release(os:, cpu_platform:, version:)
  terraform_releases_uri = 'https://releases.hashicorp.com/terraform'
  terraform_cpu_arch_stub = "#{os}_#{cpu_platform}"
  specific_terraform_release_uri = [
    terraform_releases_uri,
    version,
    "terraform_#{version}_#{terraform_cpu_arch_stub}.zip"
  ].join('/')
  {
    :version => version,
    :version_uri => specific_terraform_release_uri
  }
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
  {
    :version => latest_version,
    :version_uri => latest_terraform_release_uri
  }
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

def download_terraform_into_working_directory!(file_name:,uri_as_string:)
  uri = URI(uri_as_string)
  if not file_name or file_name.empty?
    file_name = uri.path.split('/')[-1]
    actual_file_name = 'terraform'
  end
  if !File.exist? file_name
    session = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      session.use_ssl = true
    end
    session.start do |session|
      request = Net::HTTP::Get.new uri
      session.request request do |response|
        total_download_size = response.header['content-length'].to_i
        open file_name, 'w' do |file_handle|
          amount_downloaded_so_far = 0
          response.read_body do |chunk|
            this_chunk_size = chunk.length
            amount_downloaded_so_far += this_chunk_size
            # Ruby defaults to using integer division instead of floating point
            # division. One needs to use .to_f on one of the divisors to
            # override this.
            percent_downloaded = \
              ((amount_downloaded_so_far.to_f/total_download_size)*100).round(2)
            print "Downloading #{file_name} (#{percent_downloaded}% complete). " \
              "[#{amount_downloaded_so_far}/#{total_download_size}] bytes downloaded.\r"
              $stdout.flush
            file_handle.write chunk
          end
          puts "\n"
        end
      end
    end
  else
    puts "#{file_name} already downloaded."
  end

  Zip::File.open(file_name) do |zip_file|
    zip_file.each do |file|
      if not actual_file_name
        actual_file_name = file_name.sub('.zip','')
      end
      puts "Extracting #{file.name} from #{file_name} and naming it #{actual_file_name}"
      if File.exist? actual_file_name
        `rm #{actual_file_name}`
      end
      file.extract(actual_file_name)
      File.chmod(0744, actual_file_name)
    end
  end
end

def terraform_installed_successfully?(is_latest:, version_expected:)
  if is_latest
    terraform_version_reported = `\$PWD/terraform version`
  else
    terraform_version_reported = `\$PWD/old_terraform version`
  end
  terraform_version_reported.include? "Terraform v#{version_expected}"
end
