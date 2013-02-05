PopCap
======

PopCap is an audio file management library.  It wraps some functionality from FFmpeg for reading & writing metadata tags, converting between audio file formats, and managing an audio file on the file system.

Getting Started
---------------

```
gem install pop_cap
require 'pop_cap'

Song = Class.new(PopCap::AudioFile)
song = Song.new('path/to/sample.flac')
```

Read Tags
---------

Read the metadata tags in an audio file.  With this, you can return & manipulate the raw output of ffprobe -show_format.

```
audio_file = AudioFile.new('sample.flac')

audio_file.raw_tags => Returns a string of the raw output from running ffprobe -show_format.
    [FORMAT]
    filename=sample.flac
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

audio_file.to_hash => Returns a Ruby hash after sanitizing the raw output of #raw_tags.
    { filename: 'sample.flac',
      format_name: 'flac',
      format_long_name: 'raw FLAC',
      nb_streams: '1',
      duration: '1.000000',
      filesize: '18291',
      bit_rate: '146328',
      start_time: 'N/A',
      genre: 'Sample Genre',
      track: '01',
      album: 'Sample Album',
      date: '2012',
      title: 'Sample Title',
      artist: 'Sample Artist' }

audio_file.tags => Returns a Ruby OpenStruct after applying formatters #to_hash.
    .album             =>  'Sample Album'
    .artist            =>  'Sample Artist'
    .bit_rate          =>  '146 kb/s'
    .date              =>  2012
    .duration          =>  '1'
    .filename          =>  'spec/support/sample.flac'
    .filesize          =>  '17.9K'
    .format_long_name  =>  'raw FLAC'
    .format_name       =>  'flac'
    .genre             =>  'Sample Genre'
    .nb_streams        =>  '1'
    .start_time        =>  'N/A'
    .title             =>  'Sample Title'
    .track             =>  '01'
```

Update Tags
-----------

This will update the metadata tags for an audio file.  It will also dynamically add any newly provided tags.  It takes a hash of attributes.

```
audio_file = AudioFile.new('sample.flac')
audio_file.update_tags({artist: 'David Bowie'})

audio_file.update_tags({fancy_new_tag: 'Custom Tag Input'})
```

Convert
-------

This will convert between audio file formats.  It is restricted to basic audio formats.  It also takes an optional bitrate for mp3 formats.  The original file is preserved during the conversion.

Supported formats: aac, flac, m4a, mp3, ogg, wav
Supported mp3 bitrates: 64, 128, 160, 192, 256, 320

```
audio_file = AudioFile.new('sample.flac')

audio_file.convert(:ogg)
audio_file.convert(:mp3) # => default bitrate is 192k
audio_file.convert(:mp3, 256)
```

File Management Options
-----------------------

Various Ruby File & FileUtils methods are wrapped for convenience.

```
audio_file = AudioFile.new('sample.flac')

audio_file.backup # => default directory is '/tmp'
audio_file.backup('some/path')

audio_file.backup_path # => returns backup path

audio_file.destroy # => removes file from filesystem

audio_file.directory # => returns directory, excluding filename

audio_file.filename # => returns filename, excluding directory

audio_file.move('destination') # = > moves file to destination

audio_file.rename('new_name.flac') # => renames file

audio_file.restore # => restores file from backup_path, takes an optional path as well

audio_file.tmppath # => returns the temporary path, e.g. '/tmp/sample.flac'
```

Dependencies
------------

[FFmpeg](http://ffmpeg.org)
