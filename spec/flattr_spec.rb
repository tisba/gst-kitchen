require "spec_helper"

describe Flattr do
  it "creates a valid flattr auto submit url" do
    podcast = double("podcast")
    podcast.stub(:flattr).and_return({"user_id" => "gst-podcast", "language" => "de_DE", "tags" => %w(geek stammtisch podcast), "category" => "audio"})
    expected_url = "https://flattr.com/submit/auto?user_id=gst-podcast&amp;url=http%3A%2F%2Fwww.test.de&amp;title=Some+random+Title&amp;description=Some+very+random+description&amp;language=de_DE&amp;tags=geek,stammtisch,podcast&amp;category=audio"

    Flattr.auto_submit_link(podcast, "http://www.test.de", "Some random Title", "Some very random description").should == expected_url
  end
end
