module Mass
  # DSL methods.
  module DSL
    def sequence(*args, **kws, &block)
      Sequence.define(*args, **kws, &block)
    end
  end
end
