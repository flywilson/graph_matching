# encoding: utf-8

require 'spec_helper'

RSpec.describe GraphMatching::Algorithm::MWMGeneral do
  let(:graph_class) { GraphMatching::Graph::WeightedGraph }

  describe '.new' do
    it 'requires a WeightedGraph' do
      expect { described_class.new("banana") }.to raise_error(TypeError)
    end
  end

  describe '#blossom_leaves' do
    context 'five vertexes, one blossom' do
      it 'returns array of leaves' do
        g = graph_class[
          [1, 2, 0],
          [2, 3, 0],
          [2, 4, 0],
          [3, 4, 0],
          [4, 5, 0]
        ]
        a = described_class.new(g)
        allow(a).to receive(:blossom_children).and_return([
          nil,
          nil,
          nil,
          nil,
          nil,
          [2, 3, 4]
        ])
        expect(a.blossom_leaves(0)).to eq([0])
        expect(a.blossom_leaves(4)).to eq([4])
        expect(a.blossom_leaves(5)).to eq([2, 3, 4])
      end
    end
  end

  describe '#match' do
    context 'empty graph' do
      it 'returns empty matching' do
        g = graph_class.new
        m = described_class.new(g).match
        expect(m).to be_empty
      end
    end

    context 'single vertex' do
      it 'returns empty matching' do
        g = graph_class.new
        g.add_vertex(1)
        m = described_class.new(g).match
        expect(m).to be_empty
      end
    end

    context 'two vertexes' do
      it 'returns matching of size 1' do
        skip('not yet implemented')
        g = graph_class[[1, 2, 1]]
        m = described_class.new(g).match
        expect(m.vertexes).to match_array([1, 2])
        expect(m.weight(g)).to eq(1)
      end
    end

    context 'three vertexes' do
      it 'matches the edge with greater weight' do
        skip('not yet implemented')
        g = graph_class[
          [1, 2, 1],
          [2, 3, 2],
          [3, 1, 3]
        ]
        m = described_class.new(g).match
        expect(m.vertexes).to match_array([3, 1])
        expect(m.weight(g)).to eq(3)
      end
    end

    context 'five vertexes, one blossom, three complete matchings with diff. weights' do
      it 'returns the matching with max. weight' do
        skip('not yet implemented')
        g = graph_class[
          [1, 2, 2],
          [2, 3, 0],
          [2, 4, 6], # highest weight edge, but cannot be used in a complete matching
          [3, 4, 4],
          [4, 5, 2]
        ]
        m = described_class.new(g).match
        expect(m.vertexes).to match_array([1, 2, 3, 4])
        expect(m.has_edge?([1, 2])).to eq(true)
        expect(m.has_edge?([3, 4])).to eq(true)
        expect(m.weight(g)).to eq(6)
      end
    end
  end
end
