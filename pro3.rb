require 'httparty'
require 'json'

class WorldTimeFetcher
    include HTTParty
    base_uri 'http://worldtimeapi.org/api/timezone'

    def fetch_time(area, location)
        response = self.class.get("/#{area}/#{location}")
        if response.success?
            parsed_response = JSON.parse(response.body)
            { date: parsed_response['datetime'][0..9], time: parsed_response['datetime'][11..18] }
        else
            puts "Failed to fetch time. Status code: #{response.code}"
            { date: nil, time: nil }
        end
    end
end

fetcher = WorldTimeFetcher.new
area = 'United States'
location = 'New York'
time_data = fetcher.fetch_time(area, location)

if time_data[:date] && time_data[:time]
    puts "The current time in #{area}/#{location} is #{time_data[:date]} #{time_data[:time]}"
else
    puts "Failed to fetch time for #{area}/#{location}."
end
