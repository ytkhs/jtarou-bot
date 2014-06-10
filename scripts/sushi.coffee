# description
# get 🍣

module.exports = (robot) ->
	robot.hear /すし/i, (msg) ->
		msg.send "🍣"
