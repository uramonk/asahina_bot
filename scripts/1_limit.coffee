_ = require 'lodash'
config = require '../src/config'

module.exports = (robot) ->
	robot.respond /.*/, (msg) ->
		unless _.contains [config.getSlackUser()], msg.envelope.user.name
			msg.send 'あんた誰？'
			msg.finish()
			return

		unless _.contains [config.getSlackChannel()], msg.envelope.room
			msg.send 'お家に帰りたい…'
			msg.finish()
			return

		if /bot/.test msg.envelope.user.name
			msg.finish()
			return
