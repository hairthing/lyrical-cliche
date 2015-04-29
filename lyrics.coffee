request = require('sync-request')
cheerio = require 'cheerio'

class Lyrics
  constructor: (@artist, @song)->
    @songUrl = false
  getArtist: ->
    $ = cheerio.load request('GET', "http://songmeanings.com/query/?query=#{@artist.replace(' ', '+')}&type=artists").getBody().toString()
    $("a[title='#{@artist}']")
  getSong: ->
    $ = cheerio.load request('GET', "http://songmeanings.com/query/?query=#{@artist.replace(' ', '+')}+#{@song.replace(' ','+')}&type=all").getBody().toString()
    # console.log $.html()
    href = $("a[title='#{@song}']").attr('href')
    @songUrl = href || false
  getLyrics: ->
    @getSong()
    if @songUrl
      $ = cheerio.load request('GET', @songUrl).getBody().toString()
      $(".editbutton").remove()
      lyrics = $(".lyric-box").text().trim().split("\r\n")
      lyrics = lyrics.filter (l, pos)->
        lyrics.indexOf(l) == pos and l != ""
      return lyrics
    else
      return false

# new Lyrics("Radiohead", "Karma Police").getLyrics()

module.exports = Lyrics
