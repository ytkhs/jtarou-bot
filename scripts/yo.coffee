# Description:
#   Utility commands yo
#   export HUBOT_YO_API_TOKEN=YOURTOKEN

module.exports = (robot) ->
  robot.hear /yo$/i, (msg) ->
    msg.send 'YO'
