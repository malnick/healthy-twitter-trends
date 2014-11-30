require 'yaml'
require 'twitter'

module Health

	HOME 		= ENV['HOME'] 
	TWITTER_CREDS 	= "#{HOME}/.twitter-creds.yaml"

	class Search
		def initialize(query, log)
	
			if query
				@query = query
				log.info("Running Twitter query on #{@query}")
			else
				@query = '#healthy'
				log.info("Running Twitter query on #{@query}")
			end

			if File.exists?(TWITTER_CREDS)
				log.info("Found credentials at #{TWITTER_CREDS}:")
				creds = YAML.load_file(TWITTER_CREDS)
				log.debug(creds.inspect)
			else
				log.info("No credentials found at: #{TWITTER_CREDS}")
				text = <<INFO
No twitter credentials file found. 
Please place a credentials dot file at $HOME/.twitter-creds in YAML format:

---
consumer_key: YOUR_CONSUMER_KEY
consumer_secret: YOUR_CONSUMER_SECRET
access_token: YOUR_ACCESS_TOKEN
access_token_secret: YOUR_ACCESS_SECRET
INFO
				log.info(text)
			end

			results = get_result(log, creds, @query)
			log.info("Query results: #{results}")
			#post_results_firebase(results)
		end
		
		def get_result(log, creds, query)
			log.info("Running search on #{query}")
			log.debug("Consumer key: #{creds['consumer_key']}")
			log.debug("Consumer secret: #{creds['consumer_secret']}")
			log.debug("Access token: #{creds['access_token']}")
			log.debug("Access token secret: #{creds['access_token_secret']}")

			client = Twitter::Rest::Client.new do |config|
				config.consumer_key        = creds['consumer_key']
				config.consumer_secret     = creds['consumer_secret']
				config.access_token        = creds['access_token']
				config.access_token_secret = creds['access_token_scret']
			end
			log.info("Running search...")
			
			result = client.search(query)	
			log.info(result)
		end

		def post_results_firebase(results)

		end
	end
end
