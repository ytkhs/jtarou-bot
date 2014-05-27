# Commands:

module.exports = (robot) ->

  robot.respond /帰りたい|かえりたい/i, (msg) ->
    msg.send "かえろう！今すぐかえろう！"
