require 'sinatra'
require 'erb'
require 'webrick'
require 'logger'


LOGFILE = 'logs/server.log' #File.expand_path(File.dirname(__FILE__)) + '/logs/server.log'
puts LOGFILE
HTML	= File.expand_path(File.dirname(__FILE__)) + '/public/index.html'
puts HTML
D3	= File.expand_path(File.dirname(__FILE__)) + '/public/d3fire.js'
puts D3
LOG = Logger.new(LOGFILE)

opts = {
	:Port		=> ENV['PORT'],
	:Logger		=> WEBrick::Log::new(LOGFILE, WEBrick::Log::DEBUG),
	:ServerType	=> WEBrick::Daemon,
	:SSLEnable	=> false,
}

class Server < Sinatra::Base

	get '/' do			
		LOG.info("HTML Path: #{HTML}")
		get_html
	end

	get '/d3fire.js' do
		LOG.info("Sending d3fire.js")
		LOG.info(D3)
		content_type :js
		send_file(D3)
	end

	get '/fuck' do
		"fuck"
	end


	def get_html
		File.open(HTML, 'r').readlines
	end
end		

Rack::Handler::WEBrick.run(Server, opts) do |server|
	[:INT, :TERM].each { |sig| trap(sig) { server.stop } }
end

