require('date-utils');
counter = require('../src/counter')

module.exports = (robot) ->
	robot.respond /count today$/, (msg) ->
		count = counter.getCountToday robot
		msg.send '今日食べたドーナツは' + count + '個だよ'
	
	robot.respond /count week$/, (msg) ->
		count = counter.getCountWeekFromToday robot
		msg.send '今週食べたドーナツは' + count + '個だよ'
		
	robot.respond /count total$/, (msg) ->
		count = counter.getCountTotal robot
		msg.send '今まで食べたドーナツは' + count + '個だよ'
		
	robot.respond /count day (\d{4}\/\d{2}\/\d{2})$/, (msg) ->
		date = new Date(msg.match[1])
		count = counter.getCount robot, msg.match[1].replace /\//g, ''
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'
	
	robot.respond /count month (\d{4}\/\d{2})$/, (msg) ->
		yearMonthString = msg.match[1].split '/'
		count = counter.getCountMonth robot, Number(yearMonthString[0]), Number(yearMonthString[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年MM月'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'
		
	robot.respond /count year (\d{4})$/, (msg) ->
		count = counter.getCountYear robot, Number(msg.match[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'