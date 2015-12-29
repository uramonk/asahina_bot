require('date-utils');
counter = require('../src/counter')

module.exports = (robot) ->
	robot.respond /clear today$/, (msg) ->
		count = counter.clearCountToday robot
		msg.send '今日食べたドーナツ、' + count + '個にしたよ'
		
	robot.respond /clear day (\d{4}\/\d{2}\/\d{2})$/, (msg) ->
		date = new Date(msg.match[1])
		count = counter.clearCount robot, msg.match[1].replace /\//g, ''
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear month (\d{4}\/\d{2})$/, (msg) ->
		yearMonthString = msg.match[1].split '/'
		count = counter.clearCountMonth robot, Number(yearMonthString[0]), Number(yearMonthString[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年MM月'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear year (\d{4})$/, (msg) ->
		count = counter.clearCountYear robot, Number(msg.match[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear all/, (msg) ->
		count = counter.clearCountAll robot
		firstday = counter.getFirstDay robot
		date = new Date(firstday)
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'から今日まで食べたドーナツ、' + count + '個にしたよ'