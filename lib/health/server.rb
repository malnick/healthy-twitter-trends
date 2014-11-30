require 'sinatra'
require 'erb'
require 'webrick'
require 'logger'

module Health

	LOGFILE = '../../logs/server.log'
	HTML	= File.join(File.expand_path(File.dirname(__FILE__), 'views/index.erb'))

	opts = {
		:PORT		=> 8080,
		:Logger		=> WEBrick::Log::new(LOGFILE, WEBrick::Log::DEBUG),
		:ServerType	=> WEBrick::Daemon,
		:SSLEnable	=> false,
	}
	
	class Server < Sinatra::Base

		LOG = Logger.new(LOGFILE)

		get '/' do			
			LOG.info(HTML)
			get_html
		end

		def get_html
			running_dir = File.expand_path(File.dirname(__FILE__))
			File.open(HTML, 'r').readlines
		end
	end		
	
	Rack::Handler::WEBrick.run(Server, opts) do |server|
		[:INT, :TERM].each { |sig| trap(sig) { server.stop } }
	end
end
# For testing
Health::Server.new
