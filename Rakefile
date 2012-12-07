require "bundler/gem_tasks"

require "gst-kitchen"

namespace :feed do
  desc "generate all feeds"
  task :render do
    Podcast.from_yaml("podcast.yml").render_all_feeds
  end
end
task :feed => "feed:render"

namespace :episode do
  desc "Process episode by Auphonic UUID"
  task :process, :uuid do |task, args|
    uuid = args[:uuid]

    production = Auphonic::Account.init_from_system.production(uuid)

    podcast = Podcast.from_yaml("podcast.yml")
    episode = podcast.create_episode_from_auphonic production

    puts "Episode: #{episode}"
    puts "Writing episode YAML to #{podcast.episodes_path}"
    podcast.export_episode(episode)
  end
end

