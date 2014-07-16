require "spec_helper"
require "date"

describe Episode do
  it "should extract the episode number from the full handle" do
    Episode.extract_episode_number("GST", "GST000").should == 0
    Episode.extract_episode_number("meh!", "meh!042").should == 42
  end


  describe "Auphonic" do
    it "should be build on metadata provided by auphonic production" do
      podcast = double("podcast")
      podcast.stub(:handle).and_return("GST")

      now = Time.now
      Time.stub(:now).and_return(now)

      production = double("auphonic production")
      production.should_receive(:meta).and_return({
        "data" => {
          "uuid" => "id",
          "length" => 1234,
          "metadata" => {
            "title" => "GST023 - Rikeripsum",
            "subtitle" => "Talk about going nowhere fast. Mr. Worf, you sound like a man who's asking his friend if he can start dating his sister.",
            "summary" => "summary"
          },
          "output_files" => [
            {
              "format" => "mp3",
              "size" => 1234,
              "ending" => "mp3"
            }
          ]
        }
      })

      episode = Episode.from_auphonic podcast, production
      episode.number.should == 23
      episode.name.should == "Rikeripsum"
      episode.subtitle.should == "Talk about going nowhere fast. Mr. Worf, you sound like a man who's asking his friend if he can start dating his sister."
      episode.length.should == 1234
      episode.auphonic_uuid.should == "id"
      episode.published_at.should == now
      episode.summary.should == "summary"

      # episode.media
      # episode.chapters
    end
  end

  it "should have a handle" do
    podcast = double("podcast")
    podcast.stub(:handle).and_return("GST")
    subject.podcast = podcast

    subject.number = 42

    subject.handle.should == "GST042"
  end

  it "should generate flattr urls" do
    podcast = double("podcast")
    podcast.stub(:flattr).and_return({"user_id" => "gst-podcast", "language" => "de_DE", "tags" => %w(geek stammtisch podcast), "category" => "audio"})
    podcast.stub(:deep_link_url) { "http://geekstammtisch.de/#GST001" }

    subject.podcast = podcast
    subject.name = "GST001 - Meine Tolle Folge"
    subject.subtitle = "Eine tolle Folge mit viel Blafasel"

    Flattr.should_receive(:auto_submit_link).with(podcast, "http://geekstammtisch.de/#GST001", "GST001 - Meine Tolle Folge", "Eine tolle Folge mit viel Blafasel")

    subject.flattr_auto_submit_link
  end

  it "should have a title" do
    podcast = double("podcast")
    podcast.stub(:handle).and_return("GST")
    subject.podcast = podcast

    subject.number = 1
    subject.name = "Episodename"

    subject.title.should == "GST001 - Episodename"
  end

  it "should have a RFC2822 date" do
    published_at = DateTime.strptime('2001-02-03T04:05:06+07:00', '%Y-%m-%dT%H:%M:%S%z').to_time

    subject.published_at = published_at
    subject.rfc_2822_date.should == published_at.rfc2822
  end

  it "should have a duration in HH:MM:SS" do
    subject.length = 12301
    subject.duration.should == "03:25:01"

    subject.length = 1231
    subject.duration.should == "00:20:31"

    subject.length = 0
    subject.duration.should == "00:00:00"
  end

  it "should be comparable" do
    Episode.ancestors.should include Comparable
  end

  it "should be sortable (by episode number)" do
    subject.number = 23

    other = double("other episode")

    [1, 23, 46].each do |other_number|
      other.should_receive(:number).and_return(other_number)
      (subject <=> other).should == (subject.number <=> other_number)
    end
  end
end
