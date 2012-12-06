class Media
  class Format < Struct.new(:file_ext, :mime_type)
    Mp3 = self.new("mp3", "audio/mpeg")
    M4a = self.new("m4a", "audio/x-m4a")
  end

  def initialize(file)
    @file = file
    @md5_digest = Digest::MD5.file(@file).hexdigest.force_encoding("UTF-8")
  end

  def length
    media_info["length"].to_i
  end

  def file_size
    @file_size ||= File.size(@file)
  end

  def duration
    return @duration if @duration

    hours = length / (60 * 60)
    minutes = (length - hours * 60 * 60) / 60
    seconds = length % 60

    @duration = "#{"%02i" % hours}:#{"%02i" % minutes}:#{"%02i" % seconds}"
  end

  def aquire_meta_data!
    [:duration, :file_size].each { |m| send(m) }
  end

  private

  def media_info
    @media_info ||= AudioInfo.open(@file) { |info| info.to_h }
  end
end

