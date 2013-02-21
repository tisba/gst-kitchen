class Podcast
  attr_accessor :title,
                :subtitle,
                :author,
                :email,
                :language,
                :summary,
                :handle,
                :website,
                :cover,
                :media_url,
                :episodes,
                :explicit,
                :rss_output_path,
                :episodes_path

  attr_accessor :formats

  def self.from_yaml(yaml_file="podcast.yml")
    hash = YAML.load_file(yaml_file)

    podcast = self.new
    podcast.title = hash["title"]
    podcast.subtitle = hash["subtitle"]
    podcast.author = hash["author"]
    podcast.email = hash["email"]
    podcast.language = hash["language"]
    podcast.summary = hash["summary"]
    podcast.handle = hash["handle"]
    podcast.website = hash["website"]
    podcast.cover = hash["cover"]
    podcast.media_url = hash["media_url"]
    podcast.explicit = hash["explicit"] || false
    podcast.formats = hash["formats"].map { |format| Media.format(format) }
    podcast.episodes_path = hash["episodes_path"] || "episodes/"
    podcast.rss_output_path = hash["rss_output_path"] || "."

    podcast.load_episodes

    podcast
  end

  def load_episodes
    self.episodes = Dir[File.join(self.episodes_path, "#{handle.downcase}*.yml")].map do |yml|
      Episode.from_yaml(self, yml)
    end
  end

  def create_episode_from_auphonic(production)
    Episode.from_auphonic(self, production)
  end

  def episode_by_handle(handle)
    self.episodes.find do |episode|
      episode.handle.downcase == handle.downcase
    end
  end

  def feed_url(format)
    url = URI(self.website)
    url.path = "/#{rss_file(format)}"
    url.to_s
  end

  def episode_media_url(episode, format)
    url = URI(self.media_url)
    url.path += "/#{episode.handle.downcase}.#{format.file_ext}"
    url.to_s
  end

  def cover_url
    url = URI(self.website)
    url.path = self.cover
    url.to_s
  end

  def deep_link_url(episode)
    url = URI(self.website)
    url.fragment = episode.handle
    url.to_s
  end

  def podcast
    self
  end

  def render_feed(format)
    feed = GstKitchen::Feed.new format: format, template: "episodes"
    File.open(File.join(rss_output_path, rss_file(format)), "w") do |rss|
      rss.write feed.to_xml(podcast: podcast)
    end
  end

  def export_episode(episode)
    destination = File.join(episodes_path, "#{episode.handle.downcase}.yml")
    File.open(destination, "w") { |file| file.write episode.to_yaml}
  end

  def render_all_feeds
    self.formats.each do |format|
      render_feed(format)
    end
  end

  def other_formats(format)
    self.formats - [format]
  end

  private

  def rss_file(format)
    "episodes.#{format.file_ext}.rss"
  end
end
