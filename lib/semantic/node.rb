module Semantic
  class Node
    attr_reader :value, :links_away, :links_to

    def initialize( value )
      @value = value
      @links_away = []
      @links_to = []
    end

    def add_to_link( link )
      unless( @links_to.include?( link ) )
        @links_to.push( link )
      end
    end

    def add_away_link( link )
      unless( @links_away.include?( link ) )
        @links_away.push( link )
      end
    end

    def to_set( net=nil )
      net = Semantic::Net.new unless(net)
      @links_away.each do |link|
        unless( net.defined?(link.head.value, link.label, link.tail.value) )
          net.define( link.head.value, link.label, link.tail.value )
          link.tail.to_set( net )
        end
      end
      @links_to.each do |link|
        unless( net.defined?(link.head.value, link.label, link.tail.value) )
          net.define( link.head.value, link.label, link.tail.value )
          link.head.to_set( net )
        end
      end
      return net
    end
    
  end
end
