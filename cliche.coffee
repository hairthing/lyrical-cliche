Lyrics = require './lyrics.coffee'
Ngram  = require './ngram.coffee'
Promise = require('bluebird')


class Cliche
  constructor: (@artist, @song)->
    @scores = []
  score: ->
    lyrics = new Lyrics(@artist, @song).getLyrics()
    if lyrics
      for lyric in lyrics
        score = new Ngram(lyric).score()
        console.log "__ ", lyric, score
        @scores.push score
      @total = @scores.reduce((a, b)-> return a + b ) 
      @average = @total / @scores.length
      return @
    else
      console.log "song not found"
      return false

cliche = new Cliche("Radiohead", "Karma Police").score()
# console.log cliche.artist, cliche.song, cliche.total, cliche.average
# cliche = new Cliche("Madvillain", "Curls").score()
console.log cliche.artist, cliche.song, cliche.total, cliche.average
module.exports = Cliche
