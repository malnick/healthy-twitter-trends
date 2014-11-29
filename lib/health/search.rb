module Health
	class Search
		def initialize(query, log)
			@query = query
			results = get_result(query)
			log.info(results)
		end
		
		def get_result(query)
			client = Twitter::Rest::Client.new do |config|
				config.consumer_key        = "YOUR_CONSUMER_KEY"
				config.consumer_secret     = "YOUR_CONSUMER_SECRET"
				config.access_token        = "YOUR_ACCESS_TOKEN"
				config.access_token_secret = "YOUR_ACCESS_SECRET"
			end
			
			client.search	
			query
		end
	end
end
