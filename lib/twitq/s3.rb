require 'yaml'
require 'aws-sdk'

module Twitq
	class S3
		def initialize(query, results, log)
			log.info("Posting results to S3")
			aws_config(log)
			@s3 = AWS::S3.new
			init_bucket(query, results, log)
		end

		def init_bucket(query, results, log)
			log.info("Writing results to S3 bucket: #{results}")
			bucket = @s3.buckets['twitq']
			results.each do |r|
				log.debug("Writing object 'text' => #{r}")
				bucket.objects['text'].write(r)
			end
		end

		def aws_config(log)
			log.info("Initializing aws credentials")
			aws_config = YAML.load_file(ENV['HOME'] + '/.aws.yaml') # ('~/.aws.yaml')
			log.debug(aws_config)
			AWS.config(
				:access_key_id 		=> aws_config['access_key_id'],
				:secret_access_key 	=> aws_config['secret_access_key'],
			)
		end
	end
end
