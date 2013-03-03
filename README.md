[![Build Status](https://travis-ci.org/tisba/gst-kitchen.png)](https://travis-ci.org/tisba/gst-kitchen)

# Geekstammtisch's Podcast Kitchen (gst-kitchen)

    Publishing podcats like a nerd!

This gem helps you to publish podcasts using Auphonic. It can fetch a list of Auphonic productions using
their API. You can add episodes and generate seperated feeds per audio format.

The Geekstammtisch website and this gem is inspired by [fanboys-IGOR] [igor].

**Note** that there might be some Geekstammtisch specific behavior left in this gem. If you find something,
drop me a note!



## Installation

Add this line to your application's Gem file:

    gem 'gst-kitchen'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gst-kitchen


## Conventions

gst-kitchen assumes various conventions about (file) naming and URLs.

* feeds: feeds must be located at: `<website_url>/episodes.<format_file_ext>.rss`, e.g. `http://geekstammtisch.de/episodes.m4a.rss`
* episode media files must be located at: `<media_url>/<downcased handle><padded episode_nr>.<format_file_ext>`, e.g. `http://media.geekstammtisch.de/episodes/gst000.m4a`

Meta data from each episodes is read from your Auphonic production. The episode number is read from the `title`,
which must start with `<handle><number>`. The episode name is read from `subtitle`, summary and description is
set to Auphonic's `summary` field. File sizes, playtime etc. are also read from the production.


## Usage

First you need to place your Auphonic credentials as JSON into `~/.auphonic`:

    echo '{"user": "joe@example.com", "pass": "secret"}' > ~/.auphonic

Then you need to create a `podcast.yml` containing your podcast metadata.
You can take a look at https://github.com/tisba/gst-website/blob/master/podcast.yml as an example.
Important fields are

* basic meta data like, `title`, `subtitle`, `author`, `email` and `language`
* `handle` is a short *handle* for your podcast. It can be an abbreviation, acronym, or anything you like. For geekstammtisch it's `GST`.
* base URLs for the website and media location
* list of available audio formats: fileext_encoding, e.g. `m4a_aac` or `mp3_mp3`
* `rss_output_path` specifies where the generated feeds will be located


### CLI Usage

Get a list of all Auphonic productions

    $ gst-kitchen list

Add a production to the podcast

    $ gst-kitchen process --uuid=<PRODUCTION-UUID>

Render all configured feeds based on all episodes in `episodes/`

    $ gst-kitchen feeds
    

### API Usage

**TBD**


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[igor]: https://github.com/m4p/fanboys-IGOR "IGOR"
