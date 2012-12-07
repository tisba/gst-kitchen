class Auphonic::Account
  attr_reader :username, :password

  def self.init_from_system
    auphonic_credentials = Yajl::Parser.parse(File.read(File.expand_path("~/.auphonic")))
    self.new(auphonic_credentials)
  end

  def initialize(options={})
    @username = options["user"]
    @password = options["pass"]
  end

  def production(uuid)
    Auphonic::Production.new(self, uuid)
  end

  def productions
    request("https://auphonic.com/api/productions.json")["data"].map do |meta|
      production = Auphonic::Production.new(self)
      production.meta = meta
      production
    end
  end


  private

  def request(url)
    json = open(url, http_basic_authentication: [username, password])
    Yajl::Parser.parse(json.read)
  end
end
