module Mass
  # Base class for all nodes of the DSL's AST.
  class Component
    def initialize(**params)
      params.each do |attribute, value|
        instance_variable_set "@#{attribute}", value
      end
    end

    def self.define(**params, &block)
      node = new(**params)
      node.instance_eval(&block)
      node
    end

    def play
      raise NotImplementedError
    end
  end
end
