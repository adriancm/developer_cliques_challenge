
require 'rspec'
require_relative '../spec_helper'
require_relative '../../lib/developer_cliques'


describe DeveloperCliques do

  def duser user
    double(screen_name: user)
  end

  let(:twitter_client) do
    friends = {
        "user1" => [duser("user2"), duser("user3"), duser("user5")],
        "user2" => [duser("user1"), duser("user3"), duser("user6"), duser("user4")],
        "user3" => [duser("user2"), duser("user4"), duser("user7")],
        "user4" => [duser("user2"), duser("user3"), duser("user1")]
    }

    followers = {
        "user1" => [duser("user2"), duser("user4"), duser("user5")],
        "user2" => [duser("user1"), duser("user3"), duser("user7"), duser("user4")] ,
        "user3" => [duser("user2"), duser("user1"), duser("user4")],
        "user4" => [duser("user2"), duser("user3"), duser("user7")]
    }

    twitter_double = double("Twitter::REST::Client", friends: [], followers: [])

    allow(twitter_double).to receive(:friends) do |user_name|
      double(entries: friends[user_name])
    end

    allow(twitter_double).to receive(:followers) do |user_name|
      double(entries: followers[user_name])
    end

    twitter_double
  end

  let(:github_client) do

    organizations = {
        "user1" => [double(login: "github"), double(login: "linkeddata")],
        "user2" => [double(login: "w3ctag")],
        "user3" => [double(login: "w3ctag")],
        "user4" => [double(login: "w3ctag")]
    }

    github_double = double("Octokit::Client", organizations: [])
    allow(github_double).to receive(:organizations) do |user_name|
      organizations[user_name]
    end

    github_double
  end

  let(:connected_developers) do
    ConnectedDevelopers.new developers: ["user1", "user2", "user3", "user4"],
                            twitter_client: twitter_client,
                            github_client: github_client
  end


  let(:developer_cliques) do
    allow_any_instance_of(DeveloperCliques).to receive(:get_connected_developers).and_return(connected_developers)
    DeveloperCliques.new file: '../fixtures/developers_input.txt'
  end

  context 'get maximal cliques' do
    it 'calculates from developers usernames' do

      expect(developer_cliques.execute).to eq([["user1"],["user2", "user3", "user4"]])

    end
  end

end