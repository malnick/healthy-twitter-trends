require 'yaml'
require 'logger'
require 'elasticity'

module Twitq
	class Emr
		
		def initialize(log, query)
			@LOG = log
			creds = set_creds
			job = create_flow(query, creds)
			start_job(job, query)
			@@results = get_results(query)
		end

		def create_flow(query, creds)
			jobflow = Elasticity::JobFlow.new(creds['access_key_id'], creds['secret_access_key'])
			streaming_step = Elasticity::StreamingStep.new(
				"s3n://twitq-#{query}/twitq-#{query}", # 's3n://elasticmapreduce/samples/wordcount/input', 
				"s3n://twitq-#{query}/ouput", #'s3n://elasticityoutput/wordcount/output/2012-07-23', 
				's3n://elasticmapreduce/samples/wordcount/wordSplitter.py', 
				'aggregate')

			jobflow.add_step(streaming_step)
		end

		def start_job(job, query)
			@log.info("Running EMR job for #{query}")
			job.run
			job.wait_for_completion do |elapsed_time, job_flow_status|
				@log.info("Waiting for #{elapsed_time}, jobflow status: #{job_flow_status.state}")
			end

		def set_creds
			aws_config = YAML.load_file(ENV['HOME'] + '/.aws.yaml') # ('~/.aws.yaml')
			aws_config = {
				:access_key_id 		=> aws_config['access_key_id'],
				:secret_access_key 	=> aws_config['secret_access_key'],
			}
		end


		def self.results
			@@results
		end


	end
end

		
