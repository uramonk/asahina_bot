module.exports = {
	getSlackChannel: () ->
		unless process.env.HUBOT_SLACK_CHANNEL
			console.log("undefined HUBOT_SLACK_CHANNEL")
			return null
		return process.env.HUBOT_SLACK_CHANNEL
	
	getSlackUser: () ->
		unless process.env.HUBOT_SLACK_USER_NAME
			console.log("undefined HUBOT_SLACK_USER_NAME")
			return null
		return process.env.HUBOT_SLACK_USER_NAME
}