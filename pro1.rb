require 'httparty'

class GitHubRepoAnalyzer
    include HTTParty
    base_uri 'https://api.github.com'

    def initialize(username)
        @username = username
    end

    def fetch_repositories
        response = self.class.get("/users/#{@username}/repos")
        if response.success?
            JSON.parse(response.body)
        else
            puts "Failed to fetch repositories for #{@username}. Status code: #{response.code}"
            return []
        end
    end

    def analyze_repositories(repositories)
        return if repositories.empty?

        most_starred_repo = repositories.max_by { |repo| repo['stargazers_count'] }

        puts "Most Starred Repository:"
        puts "Name: #{most_starred_repo['name']}"
        puts "Description: #{most_starred_repo['description']}"
        puts "Stars: #{most_starred_repo['stargazers_count']}"
        puts "URL: #{most_starred_repo['html_url']}"
    end
end

username = 'schiu0506'
analyzer = GitHubRepoAnalyzer.new(username)
repositories = analyzer.fetch_repositories
analyzer.analyze_repositories(repositories)

