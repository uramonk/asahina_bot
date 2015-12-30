# Author:
#   uramonk <https://github.com/uramonk>

module.exports = (robot) ->
	robot.respond /oogami$/, (msg) ->
		msg.send 'さくらちゃん！'