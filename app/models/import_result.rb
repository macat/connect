class ImportResult
  include Enumerable

  delegate :[], :[]=, to: :results

  def initialize(attribute_mapper)
    @attribute_mapper = attribute_mapper
    @results = {}
  end

  def to_s(format = "%{candidate}: %{result}\n")
    results.map do |candidate, result|
      format % {
        candidate: attribute_mapper.readable_name(candidate),
        result: result,
      }
    end.join
  end

  def each(&block)
    results.each do |candidate, result|
      block.call(candidate: candidate, result: result)
    end
  end

  def error
    nil
  end

  private

  attr_reader :attribute_mapper, :results
end
