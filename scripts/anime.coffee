# description
# get today anime TV program

module.exports = (robot) ->
  robot.respond /anime/i, (msg) ->
    request = msg.http('http://animemap.net/api/table/tokyo.json').get()
    request (err, res, body) ->
      json = JSON.parse body
      result = ""
      for anime, i in json.response.item
        if anime.today is "1"
          obj = [anime.time, "『" + anime.title + "』", anime.next, anime.station]
          result += obj.join(" ") 
          result += "\n"
      
      msg.send result