# Description
#   This bot is doughnut management bot.
#
# Dependencies:
#   "date-utils": "^1.2.17"
#   "../src/counter"
#
# Configuration:
#   HUBOT_SLACK_CHANNEL: required
#	HUBOT_SLACK_USER_NAME: required
#
# Commands:
#	asabina_bot :doughnut: - add a doughnut
#
# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils');
counter = require('../src/counter')

respond_flag = false

module.exports = (robot) ->		
	robot.respond /:doughnut:/, (msg) ->
		respond_flag = true
		counter.setFirstDay robot
		dc = msg.message.text.split(/:doughnut:/).length - 1;
		count = counter.addCountToday robot, dc
		msg.send 'ドーナツ' + dc + '個食べたんだね'	
	
	robot.respond /add day (\d{4}\/\d{2}\/\d{2}) (\d+)$/, (msg) ->
		counter.setFirstSpecificDay robot, msg.match[1]
		date = new Date(msg.match[1])
		formatted = date.toFormat 'YYYYMMDD'
		count = counter.addCount robot, formatted, Number(msg.match[2])
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'にドーナツ' + msg.match[2] + '個食べたんだね'
	
	robot.hear /:doughnut:/, (msg) ->
		if respond_flag
			respond_flag = false
			return
		num = Math.floor(Math.random() * 3) + 1
		switch num
			when 1
				msg.send 'ドーナツ！'
			when 2
				count = counter.getCountToday robot
				if count == 0
					msg.send '今日ドーナツ食べてない…'
				else 
					msg.send '今日ドーナツ食べた！'
			when 3
				msg.send ':doughnut:'

				
	