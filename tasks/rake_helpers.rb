# rake_helpers
# functions used by rakefiles and rake tasks

def log( *msg )
  $stderr.puts( msg.flatten.join(' ') )
end

def trace( *msg )
  $stderr.puts( msg.flatten.join(' ') )
end

def require_all( *libs )
  libs.flatten!
  if libs.last.is_a?(Symbol)
    name = libs.pop.to_s
  else
    name = 'Script'
  end
  libs.each do |lib|
    begin
      require lib.expand_path.to_s
    rescue LoadError => err
      log "%s '%s' failed to load: %s: %s" % 
        [name, lib.to_s, err.class.name, err.message]
      trace "Backtrace: \n " + err.backtrace.join("\n  ")
    rescue ScriptError => err
      log "%s '%s' failed to parse: %s: %s" % 
        [name, lib.to_s, err.class.name, err.message]
      trace "Backtrace: \n " + err.backtrace.join("\n  ")
    rescue => err
      log "%s '%s' failed to load: %s: %s" % 
        [name, lib.to_s, err.class.name, err.message]
      trace "Backtrace: \n " + err.backtrace.join("\n  ")
    end
  end
end


def find_platform
  platform = `uname -a`
  if(platform =~ /^\s*linux/i)
    return :linux
  elsif(platform =~ /^\s*darwin/i)
    return :mac
  else
    return :unknown
  end
end


### Download the file at +sourceuri+ via HTTP and write it to +targetfile+.
def download( sourceuri, targetfile=nil )
  require 'net/http'
  require 'uri'

  targetpath = Pathname.new( targetfile )

  log "Downloading %s to %s" % [sourceuri, targetfile]
  targetpath.open( File::WRONLY|File::TRUNC|File::CREAT, 0644 ) do |ofh|
    
    url = URI.parse( sourceuri )
    downloaded = false
    limit = 5
    
    until downloaded or limit.zero?
      Net::HTTP.start( url.host, url.port ) do |http|
	req = Net::HTTP::Get.new( url.path )

	http.request( req ) do |res|
	  if res.is_a?( Net::HTTPSuccess )
	    log "Downloading..."
	    res.read_body do |buf|
	      ofh.print( buf )
	    end
	    downloaded = true
	    puts "done."
	    
	  elsif res.is_a?( Net::HTTPRedirection )
	    url = URI.parse( res['location'] )
	    log "...following redirection to: %s" % [ url ]
	    limit -= 1
	    sleep 0.2
	    next
	    
	  else
	    res.error!
	  end

	end
      end
    end
    
  end
  
  return targetpath
end


### Return the fully-qualified path to the specified +program+ in the PATH.
def which( program )
  ENV['PATH'].split(/:/).
    collect {|dir| Pathname.new(dir) + program }.
    find {|path| path.exist? && path.executable? }
end

def prompt_for_path( prompt, default )
  value = prompt_until_value( prompt, default )
  return value.gsub( /^~/, ENV['HOME'] )
end

def prompt_until_value( prompt, default )
  value = nil
  while value == nil || value == ''
    value = prompt_with_default( prompt, default )
  end
  return value
end

def prompt_with_default( prompt, default=nil)
  if( default )
    prompt += " [#{default}]: "
  else
    prompt += " : "
  end
  print prompt
  value = $stdin.gets.chomp
  value = default if value == ''
  return value
end

def read_config( config_file )
  config = YAML::load( File.read( config_file ) )
  path = ENV['PATH']
  config['ENV'].each_key do |key|
    ENV[key] = config['ENV'][key]
  end
  ENV['PATH'] += ':' + path
  return config
end

def write_config( config_file, config_data )
  yaml = YAML::dump( config_data )
  File.open(config_file,'w') do |f|
    f.write( yaml )
  end
end

def set_default_config
  c = {
    'ENV' => {}, 
    'CONFIG_PATH' => (BASEDIR + 'config/autoconfig.yml').to_s,
    'REGION' => 'us-west-1',
#    'AVAILABILITY_ZONE' => 'us-west-1a',
  }
  found_key = nil
  found_cert = nil
  %w{cloud ec2 aws ssh/cloud ssh/ec2 ssh/aws}.each do |dir|
    dir = Pathname.new( ENV['HOME'] + '/.' + dir )
    if( dir.exist? )
      # look for keys & certs
      keys = Dir.glob( dir.to_s + '/pk*.pem' )
      certs = Dir.glob( dir.to_s + '/cert*.pem' )
      keys.each do |key|
        key_part = key.split('-')[1]
        if( cert = certs.grep( /#{key_part}/ ).first )
          found_key = key
          found_cert = cert
        end
      end
    end
  end
  c['ENV']['EC2_PRIVATE_KEY'] = found_key if found_key
  c['ENV']['EC2_CERT'] = found_cert if found_cert
  return c
end

def find_java_home
  java_home = ENV['JAVA_HOME']
  unless java_home
    if( find_platform == :mac )
      open('|/usr/libexec/java_home') do |cmd|
        java_home = cmd.read.chomp
      end
    elsif(find_platform == :linux )
      jh = Pathname.new('/usr/lib/jvm/java-6-sun')
      unless jh.exist?
        raise "No java installed, or wrong java version"
      end
      java_home = jh.to_s
    end
  end
  return java_home
end

def run_command( command, &block )
  open("|#{command}") do |cmd|
    yield
  end
end
