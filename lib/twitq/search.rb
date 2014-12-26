require 'rubygems'
require 'yaml'
require 'firebase'
require 'twitter'

module Twitq 

	HOME 		= ENV['HOME'] 
	TWITTER_CREDS 	= 'twitter-creds.yaml' #"#{HOME}/.twitter-creds.yaml"

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
firebase_secret: YOUR_FIREBASE_SECRET
INFO
				log.info(text)
			end

			results = get_result(log, creds, @query)
			log.info("Query results: #{results}")
			post_results_firebase(results, creds, log, @query)
		end
		
		def get_result(log, creds, query)
			results = []
			log.info("Running search on #{query}")
			#log.debug("Consumer key: #{creds['consumer_key']}")
			#log.debug("Consumer secret: #{creds['consumer_secret']}")
			#log.debug("Access token: #{creds['access_token']}")
			#log.debug("Access token secret: #{creds['access_token_secret']}")

			client = Twitter::REST::Client.new do |config|
				config.consumer_key        = creds['consumer_key']
				config.consumer_secret     = creds['consumer_secret']
				config.access_token        = creds['access_token']
				config.access_token_secret = creds['access_token_scret']
			end
			log.info("Running search...")
			client.search(query).take(10).collect do |tweet|	
				log.debug("Adding tweet: #{tweet.text}")
				results.push(tweet.text.chomp)
			end
			results
		end

		def post_results_firebase(results, creds, log, query)
			query.delete! '#'
			log.debug("Firebase secret: #{creds['firebase_secret']}")
			fbs = creds['firebase_secret']
			base_uri = 'https://sizzling-fire-8626.firebaseio.com'

			firebase = Firebase::Client.new(base_uri, fbs)
			results.each do |twt|
				log.debug("Sending to Firebase: #{twt}")
				response = firebase.push("#{query}", "#{twt}")
				log.debug("Firebase response: #{response.body}")
				unless response.success?
					log.info("Something broke pushing #{twt} to Firebase")
				end
			end

		end

	end
end
