require 'redcarpet'
require 'ruby-debug'

class GstKitchen::Feed

  class ShownotesRenderer < Redcarpet::Render::HTML

    TWITTER_HANDLE_PATTER = /(\W)@(\w+)\b/

    def preprocess(full_document)
      return full_document if full_document.nil?

      # Duplicate the string so we don't alter the original, then call to_str
      # to cast it back to a String instead of a SafeBuffer. This is required
      # for gsub calls to work as we need them to.
      full_document = full_document.dup.to_str

      # Extract pre blocks so they are not altered
      # from http://github.github.com/github-flavored-markdown/
      extractions = {}
      full_document.gsub!(%r{<pre>.*?</pre>|<code>.*?</code>}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        extractions[md5] = match
        "{gfm-extraction-#{md5}}"
      end

      full_document = parse(full_document)

      # Insert pre block extractions
      full_document.gsub!(/\{gfm-extraction-(\h{32})\}/) do
        extractions[$1]
      end

      return full_document
    end

    private

    def parse(document)
      parse_twitter_handle(document)

      return document
    end

    def parse_twitter_handle(document)
      document.gsub!(TWITTER_HANDLE_PATTER, '\1[@\2](https://twitter.com/\2)')
    end

  end

  TEMPLATE_PATH = File.join(File.dirname(__FILE__), "..", "..", "templates")

  attr_reader :format, :template

  def initialize(options = {})
    @format   = options[:format]
    @template = ERB.new(File.read(File.join(TEMPLATE_PATH, "#{options[:template]}.rss.erb")))
  end

  def render_as_markdown(text)
    markdown = Redcarpet::Markdown.new(ShownotesRenderer, autolink: true)
    markdown.render text
  end

  def to_xml(variables = {})
    variables.each { |var, value| instance_variable_set("@#{var}", value) }

    @template.result(binding)
  end

end
