require 'yaml'
require 'logger'
require 'elasticity'

module Twitq
	class Emr
		
		def initialize(query)
			@log = Logger.new(STDOUT)
			set_creds
			job = create_flow(query)
			start_job(job, query)
			@@results = get_results(query)
		end

		def create_flow(query)
			jobflow = Elasticity::JobFlow.new(@aws_config['access_key_id'], @aws_config['secret_access_key'])
			@log.info("Adding wordcount step for #{query} query")
			streaming_step = Elasticity::StreamingStep.new(
				"s3n://twitq-#{query}/twitq-#{query}", # 's3n://elasticmapreduce/samples/wordcount/input', 
				"s3n://twitq-#{query}/ouput", #'s3n://elasticityoutput/wordcount/output/2012-07-23', 
				's3n://elasticmapreduce/samples/wordcount/wordSplitter.py', 
				'aggregate')

			jobflow.add_step(streaming_step)
			jobflow
		end

		def start_job(job, query)
			@log.info("Running EMR job for #{query}")
			job.run
			job.wait_for_completion do |elapsed_time, job_flow_status|
				@log.info("Waiting for #{elapsed_time}, jobflow status: #{job_flow_status.state}")
			end
		end

		def set_creds
			@aws_config = YAML.load_file(ENV['HOME'] + '/.aws.yaml') # ('~/.aws.yaml')
			puts @aws_config.inspect
		end


		def self.results
			@@results
		end
	end
end

Twitq::Emr.new("judith")
		
