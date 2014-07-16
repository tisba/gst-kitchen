class Episode < Struct.new(:number, :name, :subtitle, :length, :media, :auphonic_uuid, :published_at, :summary, :chapters)
  include Comparable

  attr_accessor :podcast

  class << self
    def from_auphonic(podcast, production)
      metadata = extract_episode_data_from_auphonic(podcast, production)

      episode = self.new podcast
      episode.number = metadata[:number]
      episode.name   = metadata[:name]
      episode.subtitle = metadata[:subtitle]
      episode.length = metadata[:length].round
      episode.auphonic_uuid = metadata[:auphonic_uuid]
      episode.published_at = Time.now
      episode.summary = metadata[:summary]
      episode.media = metadata[:media]
      episode.chapters = metadata[:chapters]

      episode
    end

    def from_yaml(podcast, yaml_file)
      episode = YAML.load_file(yaml_file)
      episode.podcast = podcast
      episode
    end

    def extract_episode_number(handle, title)
      title.match(/#{handle}(\d{3})/) { |match| match[1].to_i }
    end

    def extract_name(handle, title)
      title.match(/#{handle}\d{3} ?- ?(.*)$/) { |match| match[1] }
    end

    def extract_episode_data_from_auphonic(podcast, production)
      data = production.meta

      metadata = {
        auphonic_uuid: data["data"]["uuid"],
        number: extract_episode_number(podcast.handle, data["data"]["metadata"]["title"]),
        length: data["data"]["length"],
        name: extract_name(podcast.handle, data["data"]["metadata"]["title"]),
        subtitle: data["data"]["metadata"]["subtitle"].strip,
        summary: data["data"]["metadata"]["summary"].strip,
      }

      metadata[:media] = data["data"]["output_files"].each_with_object({}) do |item, obj|
        obj[item["format"]] = {
          "size" => item["size"],
          "file_ext" => item["ending"]
        }
      end

      metadata[:chapters] = if data["data"]["chapters"]
        metadata[:chapters] = data["data"]["chapters"].map do |chapter|
          Chapter.new(chapter["start"], chapter["title"])
        end.sort
      end

      metadata
    end
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

  def flattr_auto_submit_link
    Flattr.auto_submit_link(podcast, podcast.deep_link_url(self), self.name, self.subtitle)
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

  def to_yaml_properties
    super - [:@podcast]
  end
end

