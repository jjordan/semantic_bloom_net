require 'semantic/node'

describe Semantic::Node do
  it 'has a value' do
    apple_node = described_class.new('apple')
    expect(apple_node.value).to eq('apple')
    expect { described_class.new }.to raise_error(ArgumentError)
  end
  
  it 'can have links away from it' do
    apple_node = described_class.new('apple')
    expect(apple_node).to respond_to(:links_away)
    expect(apple_node.links_away).to respond_to(:push)
  end

  it 'can have links to it' do
    apple_node = described_class.new('apple')
    expect(apple_node).to respond_to(:links_to)
    expect(apple_node.links_to).to respond_to(:push)
  end

  it 'can have links attached' do
    apple_node = described_class.new('apple')
    expect(apple_node).to respond_to(:add_to_link)
    expect(apple_node).to respond_to(:add_away_link)
    link = double('link')
    apple_node.add_to_link( link )
    apple_node.add_away_link( link )
    expect(apple_node.links_to).to eq([link])
    expect(apple_node.links_away).to eq([link])
  end

  it 'can be converted into a semantic net (set)' do
    apple = Semantic::Node.new('apple')
    fruit = Semantic::Node.new('fruit')
    core = Semantic::Node.new('core')
    peel = Semantic::Node.new('peel')
    Semantic::Link.new('is a', apple, fruit)
    Semantic::Link.new('has a', apple, core)
    Semantic::Link.new('has a', apple, peel)
    set = apple.to_set
    expect(set.defined?('apple', 'is a', 'fruit')).to eq(true)
    expect(set.defined?('apple', 'has a', 'peel')).to eq(true)
    expect(set.defined?('apple', 'has a', 'core')).to eq(true)
  end

  it 'can convert any node to a semantic net (set) not just root node' do
    apple = Semantic::Node.new('apple')
    fruit = Semantic::Node.new('fruit')
    core = Semantic::Node.new('core')
    peel = Semantic::Node.new('peel')
    Semantic::Link.new('is a', apple, fruit)
    Semantic::Link.new('has a', apple, core)
    Semantic::Link.new('has a', apple, peel)
    set = core.to_set
    expect(set.defined?('apple', 'is a', 'fruit')).to eq(true)
    expect(set.defined?('apple', 'has a', 'peel')).to eq(true)
    expect(set.defined?('apple', 'has a', 'core')).to eq(true)
  end

  it 'can merge two separate trees into the same net-set' do
    apple = Semantic::Node.new('apple')
    fruit = Semantic::Node.new('fruit')
    core = Semantic::Node.new('core')
    peel = Semantic::Node.new('peel')
    Semantic::Link.new('is a', apple, fruit)
    Semantic::Link.new('has a', apple, core)
    Semantic::Link.new('has a', apple, peel)
    set = fruit.to_set
    
    apple2 = Semantic::Node.new('apple')
    comp = Semantic::Node.new('computer')
    core2 = Semantic::Node.new('core')
    Semantic::Link.new('is a', apple2, comp)
    Semantic::Link.new('has a', apple2, core2)

    net = comp.to_set( set )
    expect(set.defined?('apple', 'is a', 'fruit')).to eq(true)
    expect(set.defined?('apple', 'has a', 'peel')).to eq(true)
    expect(set.defined?('apple', 'has a', 'core')).to eq(true)
    expect(set.defined?('apple', 'is a', 'computer')).to eq(true)
    
  end
 
end

