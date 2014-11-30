module Health
	class Search

		HOME 		= '/Users/malnick'
		TWITTER_CREDS 	= "#{HOME}/.twitter-creds"


		def initialize(query, log)
			@query = query
			if File.exists?(TWITTER_CREDS)
				log.debug("Found credentials at #{TWITTER_CREDS}")
				@creds = JSON.parse(TWITTER_CREDS)
			else
				log.debug("No credentials found at: #{TWITTER_CREDS}")
				text = <<INFO
No twitter credentials file found. 
Please place a credentials dot file at $HOME/.twitter-creds in JSON format:

{"config.consumer_key":"YOUR_CONSUMER_KEY","config.consumer_secret":"YOUR_CONSUMER_SECRET","config.access_token":"YOUR_ACCESS_TOKEN","config.access_token_secret":"YOUR_ACCESS_SECRET"}
INFO
				log.info(text)
			end
			results = get_result(query)
			log.info(results)
			post_results_firebase(results)
		end
		
		def get_result(query)
			#client = Twitter::Rest::Client.new do |config|
			#	config.consumer_key        = "YOUR_CONSUMER_KEY"
			#	config.consumer_secret     = "YOUR_CONSUMER_SECRET"
			#	config.access_token        = "YOUR_ACCESS_TOKEN"
			#	config.access_token_secret = "YOUR_ACCESS_SECRET"
			#end
			
			client.search	
			query
		end

		def post_results_firebase(results)

		end
	end
end
