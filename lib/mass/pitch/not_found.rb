module Mass
  class Pitch
    # Thrown when a +Pitch+ cannot be found, e.g. it is not valid.
    class NotFound < RuntimeError
      def initialize(name)
        super "Invalid pitch '#{name}'"
      end
    end
  end
end
