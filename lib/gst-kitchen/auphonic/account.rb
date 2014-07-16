class Auphonic::Account
  attr_reader :username, :password

  class << self
    def init_from_system
      auphonic_credentials = if File.exist?(local_config)
                               Yajl::Parser.parse File.read(local_config)
                             else
                               Yajl::Parser.parse File.read(user_config)
                             end

      self.new(auphonic_credentials)
    end

    def user_config
      File.expand_path("~/.auphonic")
    end

    def local_config
      File.join(Dir.getwd, '.auphonic')
    end
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
