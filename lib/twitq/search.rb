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
				query = query
				log.info("Running Twitter query on #{query}")
			else
				query = '#healthy'
				log.info("Running Twitter query on #{query}")
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

			@@results = get_result(log, creds, query)
			log.info("Query results: #{@@results}")
		end

		def self.results
			@@results
		end
	
		def get_result(log, creds, query)
			results = []
			log.info("Running search on #{query}")

			client = Twitter::REST::Client.new do |config|
				config.consumer_key        = '5LmU6ckudMC5spqqRK1kJHVsu' #creds['consumer_key']
				config.consumer_secret     = 'peJT1FuU8mx7uKANO2Ym95Lw2CQOKoplV2qcJfBvi3lmtEne2S' #creds['consumer_secret']
				config.access_token        = '2251466376-nx6hde34spMTqEPVHXQOU5rcqJelzhthXMehMRS' #creds['access_token']
				config.access_token_secret = 'nik8N8VQbTWPyyrGrCPHYFkayd3dk1MHWJe1fOLhcY4WS' #creds['access_token_scret']
			end
			log.info("Running search...")
			client.search(query).take(1000).collect do |tweet|	
				log.debug("Adding tweet: #{tweet.text}")
				results.push(tweet.text.chomp)
			end
			results
		end
	
	end
end
