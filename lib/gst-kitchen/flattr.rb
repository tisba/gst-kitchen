module Flattr
  def Flattr.auto_submit_link(podcast, url, title, description)
    "https://flattr.com/submit/auto" +
    "?user_id=#{podcast.flattr["user_id"]}" +
    "&url=#{CGI.escape url}" +
    "&title=#{CGI.escape title}" +
    "&description=#{CGI.escape description}" +
    "&language=#{podcast.flattr["language"]}" +
    "&tags=#{podcast.flattr["tags"].join(',')}" +
    "&category=#{podcast.flattr["category"]}"
  end
end
