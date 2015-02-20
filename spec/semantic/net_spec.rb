require 'semantic/net'

describe Semantic::Net do

  it 'can define facts which are node-link-node triplets' do
    apple_net = described_class.new
    expect(apple_net).to respond_to(:define)
    apple_net.define('apple', 'is a', 'fruit')
  end

  context 'with it''s query interface' do

    it 'can reply whether a given node-link-node exists' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      expect(apple_net).to respond_to(:defined?)
      expect(apple_net.defined?('apple', 'is a', 'fruit')).to eq(true)
      expect(apple_net.defined?('apple', 'is a', 'computer')).to eq(false)
    end

  end

  it 'can forget facts' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      apple_net.define('apple', 'is a', 'computer')
      expect(apple_net.defined?('apple', 'is a', 'computer')).to eq(true)
      expect(apple_net).to respond_to(:undefine)
      apple_net.undefine('apple', 'is a', 'computer')
      expect(apple_net.defined?('apple', 'is a', 'computer')).to eq(false)
      expect(apple_net.defined?('apple', 'is a', 'fruit')).to eq(true)
  end

  context 'compared to another Semantic::Net' do

    it 'can tell if it is a subset' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      red_delicious = described_class.new
      red_delicious.define('apple', 'is a', 'fruit')
      red_delicious.define('red delicious', 'is a', 'apple')
      expect(apple_net).to respond_to(:subset?)
      expect(apple_net.subset?( red_delicious )).to eq(true)
      
    end
    
    it 'can tell if it is a superset' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      red_delicious = described_class.new
      red_delicious.define('apple', 'is a', 'fruit')
      red_delicious.define('red delicious', 'is a', 'apple')
      expect(red_delicious).to respond_to(:superset?)
      expect(red_delicious.superset?( apple_net )).to eq(true)
    end
    
    it 'can tell if they intersect' do
      apple_fruit = described_class.new
      apple_fruit.define('apple', 'is a', 'fruit')
      apple_fruit.define('apple', 'has a', 'core')
      apple_comp = described_class.new
      apple_comp.define('apple', 'is a', 'computer')
      apple_comp.define('apple', 'has a', 'core')
      expect(apple_fruit.intersect?( apple_comp )).to eq(true)
    end

    it 'can return the intersection' do
      apple_fruit = described_class.new
      apple_fruit.define('apple', 'is a', 'fruit')
      apple_fruit.define('apple', 'has a', 'core')
      apple_comp = described_class.new
      apple_comp.define('apple', 'is a', 'computer')
      apple_comp.define('apple', 'has a', 'core')
      apple_core = described_class.new
      apple_core.define('apple', 'has a', 'core')
      expect(apple_fruit.intersection(apple_comp)).to eq(apple_core)
    end

    it 'can create a union' do
      apple_core = described_class.new
      apple_core.define('apple', 'has a', 'core')
      apple_peel = described_class.new
      apple_peel.define('apple', 'has a', 'peel')
      apple_core.union( apple_peel )
      apple_both = described_class.new
      apple_both.define('apple', 'has a', 'core')
      apple_both.define('apple', 'has a', 'peel')
      expect( apple_core.union( apple_peel ) ).to eq( apple_both )
    end
    
    it 'can merge with another net' do
      apple_core = described_class.new
      apple_core.define('apple', 'has a', 'core')
      apple_peel = described_class.new
      apple_peel.define('apple', 'has a', 'peel')
      apple_core.merge( apple_peel )
      apple_both = described_class.new
      apple_both.define('apple', 'has a', 'core')
      apple_both.define('apple', 'has a', 'peel')
      expect( apple_core ).to eq( apple_both )
    end
    
    it 'can return the difference to another net' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      red_delicious = described_class.new
      red_delicious.define('apple', 'is a', 'fruit')
      red_delicious.define('red delicious', 'is a', 'apple')
      delicious = described_class.new
      delicious.define('red delicious', 'is a', 'apple')
      expect( red_delicious.difference( apple_net ) ).to eq( delicious )
    end
    
    it 'can tell if another net is included in this one' do
      apple_net = described_class.new
      apple_net.define('apple', 'is a', 'fruit')
      apple_net.define('apple', 'is a', 'computer')
      expect(apple_net.include?('apple|is a|fruit')).to eq(true)
    end
    
  end
  
  context 'implements the Enumerable interface'
  context 'implements set arithmetic operators'
  
  it 'can be converted into a semantic net (tree)' do
    apple_net = described_class.new
    apple_net.define('apple', 'is a', 'fruit')
    apple_net.define('apple', 'is a', 'computer')
    expect(apple_net).to respond_to( :to_graph )
    graph = apple_net.to_graph
    expect(graph.length).to eq(3)
    node_values = graph.map { |n| n.value }
    expect(node_values).to include('apple')
    expect(node_values).to include('fruit')
    expect(node_values).to include('computer')
    apple_node = graph.find {|n| n.value == 'apple'}
    expect(apple_node.links_away.length).to eq(2)
  end

end
