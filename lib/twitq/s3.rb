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
			log.debug("Writing results to S3 bucket: #{results}")
			log.info("Creating S3 Bucket: twitq_#{query}")
			bucket = @s3.buckets.create("twitq_#{query}")
			twt_cnt = 0
			results.each do |r|
				log.debug("Writing to s3: #{r}")
				bucket.objects["text_#{twt_cnt}"].write(r)
				twt_cnt += 1
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
