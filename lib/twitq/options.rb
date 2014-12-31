require 'logger'

module Twitq 

	TWIT_LOG_PATH 	= File.expand_path(File.dirname(__FILE__)) + '/../../logs/twitter.log'
	
	class Options
		def initialize(options)
			log = Logger.new(TWIT_LOG_PATH)
			if options.include? 'start'
				options = parse_options(options)
				if options[:debug]
					log.level = Logger::DEBUG
					log.info("Logger set to Logger::DEBUG")
				else
					log.level = Logger::INFO
					log.info("Logger set to Logger::INFO")
				end
				results = Twitq::Search.new(options[:search], log)			
			else
				query = options
				results = Twitq::Search.new(query, log)
			end
		
			Twitq::S3.new(results, log)
		end		

		def parse_options(options)
			options = {
					:search 	=> nil, 
					:debug 		=> nil
			}

			parser = OptionParser.new do|opts|
				
				opts.banner = "Usage: health.rb -s [search query] -d #debug mode"

				opts.on('-s', '--search query', 'Search') do |query|
					options[:search] = query;
				end

				opts.on('-d', '--debug', 'Debug') do |d|
					options[:debug] = true;
				end
			end.parse!
			options
		end
	end
end
