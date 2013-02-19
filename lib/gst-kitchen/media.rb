# encoding: UTF-8

class Media
  class Format < Struct.new(:format, :file_ext, :mime_type)
    Mp3 = self.new("mp3", "mp3", "audio/mpeg")
    M4a = self.new("aac", "m4a", "audio/x-m4a")
    Opus = self.new("opus", "opus", "audio/opus")
  end

  def self.format(format)
    case format
    when :m4a_aac then Media::Format::M4a
    when :mp3_mp3 then Media::Format::Mp3
    when :opus_opus then Media::Format::Opus
    end
  end

  def initialize(file)
    @file = file
    @md5_digest = Digest::MD5.file(@file).hexdigest.force_encoding("UTF-8")
  end

  def length
    media_info["length"].to_i
  end

  def title
    media_info["title"]
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
    return @media_info if @media_info

    @media_info = TagLib::FileRef.open(@file) do |ref|
      {
        "title" => ref.tag.title,
        "length" => ref.audio_properties.length
      }
    end
  end
end

