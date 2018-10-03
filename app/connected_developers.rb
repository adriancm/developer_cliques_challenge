
require 'twitter'

class ConnectedDevelopers

  attr_reader :developers

  def initialize developers:, twitter_client:, github_client: nil
    @twitter_client = twitter_client
    @github_client = github_client
    @developers = developers
  end

  def graph
    @graph ||= generate_graph
  end

  def friends user_name
    twitter_retry { @twitter_client.friends(user_name).entries.map{ |u| u.screen_name } }
  end

  def followers user_name
    twitter_retry { @twitter_client.followers(user_name).entries.map{ |u| u.screen_name } }
  end

  def organizations user_name

  end

  private

  def generate_graph
    local_graph = {}

    @developers.each do |user_name|
      puts "===user===", user_name
      friends_names = friends(user_name)
      puts "===friends===", friends_names
      followers_names = followers(user_name)
      puts "===followers===", followers_names
      connected =  friends_names & followers_names & developers
      local_graph[user_name] = connected
    end
    local_graph
  end

  def twitter_retry &block
    begin
      block.call
    rescue Twitter::Error::TooManyRequests => error
      # NOTE: Your process could go to sleep for up to 15 minutes but if you
      # retry any sooner, it will almost certainly fail with the same exception.
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end

end