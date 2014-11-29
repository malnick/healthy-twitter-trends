module Health
	class Search
		def initialize(query, log)
			@query = query
			results = get_result(query)
			log.info(results)
		end
		
		def get_result(query)
			query
		end
	end
end
