
require 'rspec'
require_relative '../../lib/graph'

describe Graph do

  let(:edges) { { 1 => [2, 5], 2 => [1, 3, 5], 3 => [2, 4], 4 => [3, 5, 6], 5 => [1, 2, 4], 6 => [4] } }
  let(:nodes) { [1, 2, 3, 4, 5, 6] }
  let(:graph) { Graph.new edges: edges }

  it 'returns edges' do
    expect(graph.edges).to eq(edges)
  end

  it 'returns nodes' do
    expect(graph.nodes).to eq(nodes)
  end


end