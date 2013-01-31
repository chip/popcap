module MayflySpecHelper
  class << self
    def raw_tags
      <<-EOF.gsub(/^\s+/,'')
        [FORMAT]
        filename=spec/support/sample.flac
        nb_streams=1
        format_name=flac
        format_long_name=raw FLAC
        start_time=N/A
        duration=1.000000
        size=18291
        bit_rate=146328
        TAG:GENRE=Sample Genre
        TAG:track=01
        TAG:ALBUM=Sample Album
        TAG:DATE=2012
        TAG:TITLE=Sample Title
        TAG:ARTIST=Sample Artist
        [/FORMAT]
      EOF
    end
  end
end
