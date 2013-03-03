require "spec_helper"
require "date"

describe Episode do
  describe ".extract_episode_number" do
    it "should extract the episode number from the full handle" do
      Episode.extract_episode_number("GST", "GST000").should == 0
      Episode.extract_episode_number("meh!", "meh!042").should == 42
    end
  end

  it "should have a handle" do
    podcast = double("podcast")
    podcast.stub(:handle).and_return("GST")
    subject.podcast = podcast

    subject.number = 42

    subject.handle.should == "GST042"
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

  it "should be sortable (by episode number)" do
    subject.number = 23

    other = double("other episode")

    [1, 23, 46].each do |other_number|
      other.should_receive(:number).and_return(other_number)
      (subject <=> other).should == (subject.number <=> other_number)
    end
  end
end
