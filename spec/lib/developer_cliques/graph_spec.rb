
require 'rspec'
require_relative '../../../lib/developer_cliques/graph'


describe Graph do

  let(:edges) { { 1 => [2, 5], 2 => [1, 3, 5], 3 => [2, 4], 4 => [3, 5, 6], 5 => [1, 2, 4], 6 => [4] } }
  let(:nodes) { [1, 2, 3, 4, 5, 6] }
  let(:graph) { Graph.new edges: edges }
  let(:cliques) { [[1,2,5], [3,2], [3,4], [4,5], [4,6]] }

  it 'returns edges' do
    expect(graph.edges).to eq(edges)
  end

  it 'returns nodes' do
    expect(graph.nodes).to eq(nodes)
  end

  context 'neighbours' do
    it 'returns correct nodes' do
      expect(graph.neighbours(node: nodes.first)).to eq([2,5])
    end

    it 'returns empty set' do
      expect(graph.neighbours(node: nil)).to eq([])
    end
  end


  it 'returns maximal cliques' do
    expect(graph.max_cliques).to eq(cliques)
  end

end