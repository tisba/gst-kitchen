require "bundler/gem_tasks"

require "gst-kitchen"

desc "generate RSS feed for m4a"
task :m4a do
  podcast = YAML.parse(File.read("podcast.yml")).to_ruby
  podcast.episodes = [YAML.parse(File.read("episodes/gst000.yml")).to_ruby]
  podcast.render_rss(Media::Format::M4a)
end

desc "generate RSS feed for mp3"
task :mp3 do
  podcast = YAML.parse(File.read("podcast.yml")).to_ruby
  podcast.episodes = [YAML.parse(File.read("episodes/gst000.yml")).to_ruby]
  podcast.render_rss(Media::Format::Mp3)
end
