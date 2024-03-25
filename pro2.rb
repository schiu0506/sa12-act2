require 'httparty'
require 'json'

class CryptoMarketAnalyzer
    include HTTParty
    base_uri 'https://api.coingecko.com/api/v3'

    def fetch_crypto_data
        response = self.class.get("/coins/markets?vs_currency=usd")
        if response.success?
            JSON.parse(response.body)
        else
            puts "Failed to fetch cryptocurrency data. Status code: #{response.code}"
            return []
        end
    end

    def analyze_crypto_data(crypto_data)
        return if crypto_data.empty?

        sorted_cryptos = crypto_data.sort_by { |crypto| -crypto['market_cap'] }

        puts "Top 5 Cryptocurrencies by Market Capitalization:"
        sorted_cryptos.first(5).each do |crypto|
        puts "Name: #{crypto['name']}"
        puts "Price: $#{crypto['current_price']}"
        puts "Market Cap: $#{crypto['market_cap']}"
        end
    end
end

analyzer = CryptoMarketAnalyzer.new
crypto_data = analyzer.fetch_crypto_data
analyzer.analyze_crypto_data(crypto_data)
