PopCap
======

PopCap is an audio file management library.  It wraps some functionality from FFmpeg for reading & writing metadata tags, converting between audio file formats, and managing an audio file on the file system.

Getting Started
---------------

```
gem install popcap
require 'popcap'

Song = Class.new(PopCap::AudioFile)
song = Song.new('path/to/sample.flac')
```

Read Tags
---------

Read the metadata tags from an audio file.

```
audio_file = PopCap::AudioFile.new('sample.flac')

audio_file.raw_output => Returns JSON for the raw output from 
running "ffprobe -show_format -print_format json."

      { 
        "format": 
          { 
            "filename":"spec/fixtures/sample.flac",
            "nb_streams":1,
            "format_name":"flac",
            "format_long_name":"raw FLAC",
            "duration":"1.000000",
            "size":"18291",
            "bit_rate":"146328",

              "tags": 
              { 
                "GENRE":"Sample Genre",
                "track":"01",
                "ALBUM":"Sample Album",
                "DATE":"2012",
                "TITLE":"Sample Title",
                "ARTIST":"Sample Artist" 
              }
          }
      }

audio_file.unformatted => Returns a Ruby hash after sanitizing 
the raw output of #raw_output.

      {
        filename: '$HOME/spec/fixtures/sample.flac',
        nb_streams: 1,
        format_name: 'flac',
        format_long_name: 'raw FLAC',
        duration: '1.000000',
        filesize: '18291',
        bit_rate: '146328',
        genre: 'Sample Genre',
        track: '01',
        album: 'Sample Album',
        date: '2012',
        title: 'Sample Title',
        artist: 'Sample Artist'
      }

audio_file.formatted => Returns a Ruby hash after sanitizing 
the raw output of #raw_output.  It also applies internal formatters 
on fields such as duration, bit_rate, filesize, & date,
returning human readable output.

      {
        filename: '$HOME/spec/fixtures/sample.flac',
        nb_streams: 1,
        format_name: 'flac',
        format_long_name: 'raw FLAC',
        duration: '1',
        filesize: '17.9K',
        bit_rate: '146 kb/s',
        genre: 'Sample Genre',
        track: '01',
        album: 'Sample Album',
        date: 2012,
        title: 'Sample Title',
        artist: 'Sample Artist'
      }

audio_file.tags => Returns a tag structure using the #formatted values.

    .album             =>  'Sample Album'
    .artist            =>  'Sample Artist'
    .bit_rate          =>  '146 kb/s'
    .date              =>  2012
    .duration          =>  '1'
    .filename          =>  ''$HOME/spec/fixtures/sample.flac'
    .filesize          =>  '17.9K'
    .format_long_name  =>  'raw FLAC'
    .format_name       =>  'flac'
    .genre             =>  'Sample Genre'
    .nb_streams        =>  1
    .start_time        =>  'N/A'
    .title             =>  'Sample Title'
    .track             =>  '01'

audio_file.reload! => Reload an instance of itself, 
useful when updating tags.  This behavior is built in, 
but will need to be called manually in certain situations; 
(such as moving a file on the file system, deleting a file, etc.)
```

Update Tags
-----------

This will update the metadata tags for an audio file.  
It will also dynamically add any newly provided tags.  
It takes a hash of attributes.

```
audio_file = PopCap::AudioFile.new('sample.flac')
audio_file.update(artist: 'David Bowie')

audio_file.update(fancy_new_tag: 'Custom Tag Input')
```

Convert
-------

This will convert between audio file formats.  
It is restricted to basic audio formats.  
It also takes an optional bitrate for mp3 formats.  
The original file is preserved during the conversion.

```
audio_file = PopCap::AudioFile.new('sample.flac')

audio_file.convert(:ogg)
audio_file.convert(:mp3) # => default bitrate is 192k
audio_file.convert(:mp3, 256)
```

File Management Options
-----------------------

Various Ruby File & FileUtils methods are wrapped for convenience.

```
audio_file = PopCap::AudioFile.new('sample.flac')

audio_file.backup # => default directory is '/tmp'
audio_file.backup('some/path')

audio_file.backup_path # => returns backup path

audio_file.destroy # => removes file from filesystem

audio_file.directory # => returns directory, excluding filename

audio_file.filename # => returns filename, excluding directory

audio_file.move('destination') # = > moves file to destination

audio_file.rename('new_name.flac') # => renames file

audio_file.restore # => restores file from backup_path; 
                        takes an optional path

audio_file.tmppath # => returns the temporary path, e.g. '/tmp/sample.flac'
```

Dependencies
------------
Ruby 2.0+

[FFmpeg](http://ffmpeg.org)
