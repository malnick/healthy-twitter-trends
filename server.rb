require 'sinatra'
require 'erb'
require 'webrick'
require 'logger'
require 'erb'
require './lib/twitq'

LOGFILE = File.expand_path(File.dirname(__FILE__)) + '/logs/server.log'
HTML	= File.expand_path(File.dirname(__FILE__)) + '/public/index.html'
D3	= File.expand_path(File.dirname(__FILE__)) + '/public/d3.layout.cloud.js'
LOG 	= Logger.new(LOGFILE) #(LOGFILE)

opts = {
	:Port		=> ENV['PORT'],
	:Logger		=> WEBrick::Log::new(LOGFILE, WEBrick::Log::DEBUG),
	:SSLEnable	=> true,
}

class Server < Sinatra::Base

	get '/' do			
		LOG.info("HTML Path: #{HTML}")
		erb :index
	end

	get '/public/d3.layout.cloud.js' do 
		send_file(D3)
	end

	post '/query' do
		request.body.rewind
		@query = request.body.read.split('=').last
		LOG.info("Submitting twitter query for #{@query}")
		Twitq::Options.new(@query)
		erb :index
	end

end		

Rack::Handler::WEBrick.run(Server, opts) do |server|
	[:INT, :TERM].each { |sig| trap(sig) { server.stop } }
end

