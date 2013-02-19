class Chapter < Struct.new(:start, :title)
  def initialize(*args)
    super
  end

  def self.from_auphonic(production)
    chapters = production.meta
  end
end
