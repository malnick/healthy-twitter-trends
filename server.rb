require 'sinatra'
require 'erb'
require 'webrick'
require 'logger'
require 'erb'
require './lib/twitq'

LOGFILE = File.expand_path(File.dirname(__FILE__)) + '/logs/server.log'
HTML	= File.expand_path(File.dirname(__FILE__)) + '/public/index.html'
D3	= File.expand_path(File.dirname(__FILE__)) + '/public/d3fire.js'
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

	post '/query' do
		LOG.info("Submitting twitter query for #{response.body}")
		@query = response.body
		Twitq::Options.new(@query)
		erb :index
	end

end		

Rack::Handler::WEBrick.run(Server, opts) do |server|
	[:INT, :TERM].each { |sig| trap(sig) { server.stop } }
end

