require "mondo"
require "date"
require "active_support"
require "csv"

class Mondo2CSV
	
	attr_reader :csv
	
	def initialize(year, month, token)
		start_date = DateTime.new(year.to_i, month.to_i, 1)
		end_date = start_date.end_of_month
		
		mondo = Mondo::Client.new(token: token)
		
		rows = [['Transaction ID', 'Date', 'Description', 'Amount']]
		rows += mondo.transactions(since: start_date.rfc3339, before: end_date.rfc3339)
			.map{|transaction|
				[
					transaction.id,
					transaction.created,
					transaction.description,
					transaction.amount,
				]
			}
		
		@csv = rows.map(&:to_csv).join
		
	end
	
end