class Episode < Struct.new(:number, :name, :published_at, :summary, :description)
  include Comparable

  def initialize
    super
    @media = {}
  end

  def <=>(other)
    self.number <=> other.number
  end

  def title
    "#{handle} - #{name}"
  end

  def handle
    "GST#{"%03i" % self.number}"
  end

  def rfc_2822_date
    self.published_at.rfc2822
  end

  def media(format)
    @media[format] ||= Media.new("media/#{self.handle.downcase}.#{format.file_ext}")
  end
end

