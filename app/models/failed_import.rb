class FailedImport
  attr_reader :error

  def initialize(error:)
    @error = error
  end

  def to_a
    []
  end

  def to_s
    ""
  end
end
