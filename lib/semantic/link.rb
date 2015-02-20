module Semantic
  class Link
    attr_reader :label, :head, :tail
    def initialize( *args )
      label = ''
      if( args.first.is_a?( String ) )
        label = args.shift
      end
      @label = label
      @head = args.shift
      @tail = args.shift
      raise ArgumentError, 'a head and tail node are required' unless @head && @tail
      @head.add_away_link( self )
      @tail.add_to_link( self )
    end
  end
end
