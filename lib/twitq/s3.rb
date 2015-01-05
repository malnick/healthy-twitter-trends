require 'yaml'
require 'aws-sdk'

module Twitq
	class PostToS3
		def initialize(query, results, log)
			log.info("Posting results to S3")
			aws_config(log)
			@s3 = AWS::S3.new
			init_bucket(query, results, log)
		end

		def init_bucket(query, results, log)
			string = stringfy(results)
			log.debug("Writing results to S3 bucket: #{string}")
			log.info("Creating S3 Bucket: twitq-#{query}")
			bucket = @s3.buckets.create("twitq-#{query}")
			bucket.objects["twitq-#{query}"].write(string)
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

		def stringfy(results)
			string_results = ''
			results.each do |r|
				string_results << r
			end
			string_results
		end
	end

	class GetFromS3
		def initialize(query, log)
			@localpath = File.expand_path(File.dirname(__FILE__))
			aws_config(log)
			@s3 = AWS::S3.new
			@@results = get_results(query,log)
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

		def get_results(query,log)
			log.info("Writing S3 results for #{query} to local file system: #{@localpath}../../public/twitq-#{query}-data")
			File.open("#{@localpath}../../public/twitq-#{query}-data", 'wb') do |file|
				reap = s3.get_object({ bucket:"twitq-#{query}", key:'output' }, target: file)
			end
		end

		def self.s3_results
			@@results
		end
	end
end
