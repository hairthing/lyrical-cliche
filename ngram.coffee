request = require('request')
Promise = require('bluebird')

class Ngram
  constructor: (@phrase)->
    @year(2000)
    @subPhraseIndex = 0
    @baseURL = "https://books.google.com/ngrams/graph?"
    @corpus = 15
    @smoothing = 0
    @share = ""
  length: ->
    @phrase.split(" ").length
  updateUrl: ->
    if @length() <= 5
      @subPhrase = @phrase
    else
      @subPhrase = @phrase.split(" ").slice(@subPhraseIndex, @subPhraseIndex+5).join(' ')
      @subPhraseIndex++
    @content = encodeURIComponent(@subPhrase).replace(/%20/g, "+").replace(/\'/g, '+%27+')
    @directURL = encodeURIComponent("t1;,"+@subPhrase+";,c0").replace(/\'/g, '%20%27%20')
    @url = "#{@baseURL}content=#{@content}&case_insensitive=on&year_start=#{@yearStart}&year_end=#{@yearEnd}&corpus=#{@corpus}&smoothing=#{@smoothing}&share=#{@share}"
    # https://books.google.com/ngrams/graph?content=It%27s+not+enough&year_start=2000&year_end=2001&corpus=15&smoothing=3&share=
  year:(y)->
    @yearStart = y
    @yearEnd = y+1
    @
  score: ()->
    if @length() > 5
      lowest = 1
      while @subPhraseIndex < (@length() - 4)
        console.log "."
        q = @query()
        score = q  if score > q
        if q == 0
          score = q
          break
    else
      score = @query()
    @scale(score)
  query: ()->
    @updateUrl()
    value = false
    console.log @url
    body = request('GET', @url).getBody().toString()
    console.log "/"
    lines = body.split("\n")
    for line in lines
      if line.indexOf('var data = [];') > -1
        value = 0
        break
      else if line.indexOf('var data =') > -1
        data = JSON.parse line.replace('  var data = ', '').replace("}];","}]")
        value = data[0].timeseries[0]
        break
    value
  scale: (value)->
    value * 1000000000000000


# console.log "score = ", new Ngram("it is").year(1995).score()
# console.log "score = ", new Ngram("you do it to yourself").year(1995).score()
# console.log "score = ", new Ngram("and they all lived happily ever after").year(1995).score()

module.exports = Ngram

# https://books.google.com/ngrams/graph?
# content=you+do+it+to+yourself%2C+i+love+you
# year_start=1995&year_end=1996&corpus=15&smoothing=3&share=&
# direct_url=t1%3B%2Cyou%20do%20it%20to%20yourself%3B%2Cc0%3B.t1%3B%2Ci%20love%20you%3B%2Cc0
# direct_url=t1%3B%2Cyou%20do%20it%20to%20yourself%3B%2Cc0