require 'sinatra'
require 'erb'
require 'webrick'
require 'logger'


LOGFILE = File.expand_path(File.dirname(__FILE__)) + '/../logs/server.log'
HTML	= File.expand_path(File.dirname(__FILE__)) + '/../public/index.html'
LOG = Logger.new(LOGFILE)

opts = {
	:PORT		=> 8080,
	:Logger		=> WEBrick::Log::new(LOGFILE, WEBrick::Log::DEBUG),
	:ServerType	=> WEBrick::Daemon,
	:SSLEnable	=> false,
}

class Server < Sinatra::Base

	get '/' do			
		LOG.info("HTML Path: #{HTML}")
		get_html
	end

	def get_html
		File.open(HTML, 'r').readlines
	end
end		

Rack::Handler::WEBrick.run(Server, opts) do |server|
[:INT, :TERM].each { |sig| trap(sig) { server.stop } }
end
