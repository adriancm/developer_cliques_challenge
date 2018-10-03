
require 'rspec'
require_relative '../../app/connected_developers'

describe ConnectedDevelopers do

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

  let(:connected_developers) do
    ConnectedDevelopers.new developers: ["user1", "user2", "user3", "user4"], twitter_client: twitter_client
  end

  let(:result_graph) do
    {
        "user1" => ["user2"],
        "user2" => ["user1", "user3", "user4"],
        "user3" => ["user2", "user4"],
        "user4" => ["user2", "user3"]
    }
  end

  it 'returns a graph' do
    expect(connected_developers.graph).to eq(result_graph)
  end

end