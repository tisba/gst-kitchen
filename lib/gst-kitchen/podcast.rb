class Podcast < Struct.new(:title, :handle, :website, :cover, :primary_format, :alternative_format, :formats, :media_url, :episodes)
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
    # url = URI(self.website)
    # url.path = self.cover
    # url.to_s
    self.cover
  end

  def deep_link_url(episode)
    url = URI(self.website)
    url.fragment = "#{episode.number}:"
    url.to_s
  end

  def podcast
    self
  end

  def current_format
    @current_format
  end

  def render_rss(format)
    @current_format = format
    template = ERB.new File.read("templates/episodes.rss.erb")
    File.open(rss_file(format), "w") do |rss|
      rss.write template.result(binding)
    end
  end

  def alternative_formats
    self.formats - [self.current_format]
  end


  private
  def rss_file(format)
    "episodes.#{format.file_ext}.rss"
  end
end
