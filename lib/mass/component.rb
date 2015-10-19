module Mass
  # Base class for all nodes of the DSL's abstract syntax tree. Used to
  # quickly define nodes as well as play them immediately, and
  # establishes a very minimal interface by which all classes
  # participate. That interface includes the following tenets:
  #
  # - Keyword arguments passed during instantiation are used to set up
  # the object's attributes.
  # - New objects are always created using +define+, so that the block
  # which yields to the instance of the node can be executed after
  # instantiation.
  # - Attributes are exposed with +attr_reader+ and read from their
  # corresponding instance variable. Any attribute sent in the keyword
  # arguments is saved to the object, even though it may not be
  # public-accessible.
  #
  # Components are typically defined first and played at a later time,
  # but sometimes they are meant to play immediately. Either way, every
  # component needs to "activate" at some point, and so each implementor
  # of the +Component+ interface must define the instance method +play+
  # to achieve the required behavior.
  class Component
    # @param params - Keyword arguments used to set attribute values for
    # this component.
    def initialize(**params)
      params.each do |attribute, value|
        instance_variable_set "@#{attribute}", value
      end
    end

    # Define a new component and execute code within its block scope.
    #
    # @param params - Keyword arguments used to set up the component.
    # @param block - Executed within the context of the new node's instance.
    def self.define(**params, &block)
      node = new(**params)
      node.instance_eval(&block) if block_given?
      node
    end

    # Define a new component and immediately play it.
    #
    # @return [Boolean] +true+ when the component has finished playing.
    def self.play(**params, &block)
      define(**params, &block).play
    end

    # Defined by whatever subclasses +Component+, this defines a
    # standard method called when the component needs to play through
    # the MIDI interface. Although there is no unified standard for what
    # this method returns, typically components tend to return +true+ to
    # indicate that it has finished playing.
    #
    # @raise [NotImplementedError] if the method has not been defined
    # @return [Boolean] +true+ when the component has finished playing.
    def play
      fail NotImplementedError
    end
  end
end
