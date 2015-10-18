module Mass
  # DSL methods.
  module DSL
    def sequence(**kws, &block)
      Sequence.play(**kws, &block)
    end
  end
end
