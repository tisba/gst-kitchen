require "open-uri"

class Auphonic::Production
  attr_accessor :meta

  def initialize(account, uuid=nil)
    @account = account
    fetch uuid if uuid
  end


  private

  def fetch(uuid)
    @meta = request("https://auphonic.com/api/production/#{uuid}.json")
  end

  def request(url)
    json = open(url, http_basic_authentication: [@account.username, @account.password])
    Yajl::Parser.parse(json.read)
  end
end
