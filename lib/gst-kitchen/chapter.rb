class Chapter < Struct.new(:start, :title)
  include Comparable

  def initialize(*args)
    super
  end

  def self.from_auphonic(production)
    chapters = production.meta
  end

  def <=>(other)
    self.start <=> other.start
  end
end
