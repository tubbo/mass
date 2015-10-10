module Mass
  # Represents the pitch of a given note, and calculates its
  # correct MIDI value, leaving the +Note+ class more for
  # calculating the proper duration and actually playing out
  # the note.
  class Pitch
    attr_reader :id
    attr_reader :name
    attr_reader :octave
    attr_reader :value

    # A dictionary of MIDI note values that are substituted
    # for a given String note value.
    #
    # @type [Array<String>]
    VALUES = {
      'C' => 36,
      'C#' => 37,
      'Db' => 37,
      'D' => 38,
      'D#' => 39,
      'Eb' => 39,
      'E' => 40,
      'F' => 41,
      'F#' => 42,
      'Gb' => 42,
      'G' => 43,
      'G#' => 44,
      'Ab' => 44,
      'A' => 45,
      'A#' => 46,
      'Bb' => 46,
      'B' => 47
    }

    # A collection of attributes which are required for
    # this object to be considered a valid pitch.
    #
    # @type [Array<Symbol>]
    REQUIRED = %i(name octave value)

    # @param [String] id - Identifier string of this pitch.
    def initialize(id: '')
      @id = id.to_s
      @name = @id.gsub(/\d/, '').to_s
      @octave = @id.gsub(/#{name}/, '').to_i
      @value = begin
                 VALUES[name]
               rescue
                 nil
               end
    end

    # Find a +Pitch+ by its given +id+.
    #
    # @param [String] by_id
    # @return [Pitch] when the id is valid
    def self.find(by_id = nil)
      return if by_id.nil?
      new id: by_id
    end

    # Make sure the +name+ and +octave+ attributes have
    # been correctly parsed out of the given +id+.
    #
    # @return [Boolean] whether the object is valid
    def valid?
      required_params.all? do |param|
        !param.nil? && (param != '') && (param != 0)
      end
    end

    # The MIDI value of this pitch.
    #
    # @return [Integer]
    def to_i
      value + octave_modifier
    end

    # Use the +id+ parameter to define equivalence.
    #
    # @return [Boolean] whether both pitches have the same ID.
    def ==(other)
      other.id == id
    end

    private

    def required_params
      REQUIRED.map do |param_name|
        send param_name
      end
    end

    # The number by which the given scalar pitch gets modified to
    # produce the correct MIDI note value for playback.
    #
    # @private
    # @return [Integer]
    def octave_modifier
      12 * octave
    end
  end
end
