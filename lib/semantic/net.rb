require 'set'
require 'semantic/node'
module Semantic
  class Net < Set

    #TODO: put back in custom initializer that ensures
    # any passed in sets are actually semantic nets
    
    def define( head, link, tail )
      fact = factize( head, link, tail )
      self.add( fact )
    end

    def undefine( head, link, tail )
      fact = factize( head, link, tail )
      self.delete( fact )
    end

    def defined?( head_node, link, tail_node )
      fact = factize( head_node, link, tail_node )
      return self.include?( fact )
    end

    def to_graph
      nodes_by_value = {}
      links_by_label = {}
      self.each do |fact|
        (hv,ll,tv) = fact.split('|')
        hn = nil
        tn = nil
        unless(nodes_by_value.has_key?( hv ))
          hn = Semantic::Node.new( hv )
          nodes_by_value[hv] = hn
        else
          hn = nodes_by_value[hv]
        end
        unless(nodes_by_value.has_key?( tv ))
          tn = Semantic::Node.new( tv )
          nodes_by_value[tv] = tn
        else
          tn = nodes_by_value[tv]
        end
        unless(links_by_label.has_key?( ll ))
          links_by_label[ll] = []
        end
        l = Semantic::Link.new( ll, hn, tn )
        links_by_label[ll].push( l )
      end
      return nodes_by_value.values
    end
    
    private
    def factize( head_node, link, tail_node )
      [head_node, link, tail_node].join('|')
    end
    
  end
end
