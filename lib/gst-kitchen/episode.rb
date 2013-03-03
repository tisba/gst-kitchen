class Episode < Struct.new(:number, :name, :length, :media, :auphonic_uuid, :published_at, :summary, :chapters)
  include Comparable

  attr_accessor :podcast

  def self.from_auphonic(podcast, production)
    data = production.meta
    /#{podcast.handle}(?<number>\d{3})/ =~ data["data"]["metadata"]["title"]

    metadata = {
      auphonic_uuid: data["data"]["uuid"],
      number: number.to_i,
      length: data["data"]["length"],
      name: data["data"]["metadata"]["subtitle"].strip,
      summary: data["data"]["metadata"]["summary"].strip,
    }

    media = data["data"]["output_files"].each_with_object({}) do |item, obj|
      obj[item["format"]] = {
        "size" => item["size"],
        "file_ext" => item["ending"]
      }
    end

    episode = self.new podcast

    episode.number = metadata[:number]
    episode.name   = metadata[:name]
    episode.length = metadata[:length].round
    episode.auphonic_uuid = metadata[:auphonic_uuid]
    episode.published_at = Time.now
    episode.summary = metadata[:summary]
    episode.media = media

    episode.chapters = data["data"]["chapters"].map do |chapter|
      Chapter.new(chapter["start"], chapter["title"])
    end

    episode.chapters.sort!

    episode
  end

  def self.from_yaml(podcast, yaml_file)
    episode = YAML.load_file(yaml_file)
    episode.podcast = podcast
    episode
  end

  def initialize(podcast=nil, *args)
    @podcast = podcast
    super(*args)
  end

  def <=>(other)
    self.number <=> other.number
  end

  def title
    "#{handle} - #{name}"
  end

  def handle
    "#{podcast.handle}#{"%03i" % self.number}"
  end

  def rfc_2822_date
    self.published_at.rfc2822
  end

  def duration
    hours = length / (60 * 60)
    minutes = (length - hours * 60 * 60) / 60
    seconds = length % 60

    "#{"%02i" % hours}:#{"%02i" % minutes}:#{"%02i" % seconds}"
  end

  def to_s
    "#{title} (#{duration}) https://auphonic.com/engine/status/#{auphonic_uuid}"
  end
end

