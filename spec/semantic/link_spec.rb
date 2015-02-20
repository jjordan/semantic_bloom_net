require 'semantic/link'

describe Semantic::Link do
  let(:apple_node) { double("apple node") }
  let(:fruit_node) { double("fruit node") }
  before :all do
  end

  it 'has an optional label' do
    allow_link
    isa_link = described_class.new( 'is a', apple_node, fruit_node )
    expect(isa_link).to respond_to(:label)
    expect(isa_link.label).to eq( 'is a' )
    expect {
      isa_link = described_class.new( apple_node, fruit_node )
    }.to_not raise_error
    expect(isa_link.label).to eq( '' )
  end

  it 'can have a head node' do
    allow_link
    isa_link = described_class.new( 'is a', apple_node, fruit_node )
    expect(isa_link).to respond_to( :head )
    expect(isa_link.head).to eq( apple_node )
  end

  it 'can have a tail node' do
    allow_link
    isa_link = described_class.new( 'is a', apple_node, fruit_node )
    expect(isa_link).to respond_to( :tail )
    expect(isa_link.tail).to eq( fruit_node )
  end

  it 'requires both a head and tail node' do
    allow_link
    expect { described_class.new }.to raise_error( ArgumentError )
    expect { described_class.new( 'is a' ) }.to raise_error( ArgumentError )
    expect { described_class.new( apple_node ) }.to raise_error( ArgumentError )
    expect { described_class.new( fruit_node ) }.to raise_error( ArgumentError )
    isa_link = nil
    expect { isa_link = described_class.new( apple_node, fruit_node ) }.not_to raise_error
    expect(isa_link.label).to eq( '' )
  end

  it 'adds the link to both sides' do
    expect(apple_node).to receive(:add_away_link)
    expect(fruit_node).to receive(:add_to_link)
    isa_link = described_class.new( 'is a', apple_node, fruit_node )
  end

  def allow_link
    allow(apple_node).to receive(:add_away_link)
    allow(fruit_node).to receive(:add_to_link)
  end
  
end
