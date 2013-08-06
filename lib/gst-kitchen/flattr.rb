module Flattr
  def Flattr.auto_submit_link(podcast, url, title, description)
    "https://flattr.com/submit/auto" +
    "?user_id=#{podcast.flattr["user_id"]}" +
    "&amp;url=#{CGI.escape url}" +
    "&amp;title=#{CGI.escape title}" +
    "&amp;description=#{CGI.escape description}" +
    "&amp;language=#{podcast.flattr["language"]}" +
    "&amp;tags=#{podcast.flattr["tags"].join(',')}" +
    "&amp;category=#{podcast.flattr["category"]}"
  end
end
