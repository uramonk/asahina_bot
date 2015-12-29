require('date-utils');
dateFunc = require('../src/date')

WEEKCOUNT = 'weekcount'
TOTALCOUNT = 'totalcount'

module.exports = {
	getCount: (robot, key) -> 
		count = robot.brain.get key or 0
		if count == null
			count = 0
		return count
		
	getCountToday: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		return this.getCount robot, formatted
	
	getCountYesterday: (robot) ->
		date = Date.yesterday()
		formatted = date.toFormat 'YYYYMMDD'
		return this.getCount robot, formatted
	
	getCountWeek: (robot) ->
		return this.getCount robot, WEEKCOUNT
	
	getCountMonth: (robot, year, month) ->
		# new Dateの時はmonthを-1する
		date = new Date(year, month - 1, 1)
		daysInMonth = dateFunc.getDaysInMonth year, month
		count = 0
		for i in [1..daysInMonth]
			console.log(date)
			count += this.getCount robot, date.toFormat 'YYYYMMDD'
			date = date.addHours(24)
		return count
	
	getCountYear: (robot, year) ->
		console.log(year)
		date = new Date(year, 0, 1)
		count = 0
		for month in [1..12]
			console.log("????????????" + date)
			count += this.getCountMonth robot, year, month
			console.log("!!!!!!!!!!!!" + date)
			date = date.addMonths(1)
		return count
	
	getCountTotal: (robot) ->
		return this.getCount robot, TOTALCOUNT
		
	clearCount: (robot, key) ->
		robot.brain.set key, 0
		robot.brain.save
		return robot.brain.get key
		
	clearCountToday: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		# トータル数から今日食べた数を引く
		count = this.getCountToday robot
		this.subtractCountTotal robot, count
		# 週の数から今日食べた数を引く
		this.subtractCountWeek robot, count
		return this.clearCount robot, formatted
	
	clearCountWeek: (robot) ->
		return this.clearCount robot, WEEKCOUNT
		
	clearCountTotal: (robot) ->
		return this.clearCount robot, TOTALCOUNT
	
	addCount: (robot, key, addcount) ->
		count = robot.brain.get key or 0
		if count == null
			count = 0
		addnum = count + addcount
		if addnum < 0
			addnum = 0
		robot.brain.set key, addnum
		robot.brain.save
		return robot.brain.get key
	
	addCountToday: (robot, addcount) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		# トータル数も増加させる
		this.addCountTotal robot, addcount
		# 週の数も増加させる
		this.addCountWeek robot, addcount
		return this.addCount robot, formatted, addcount
	
	addCountWeek: (robot, addcount) ->
		return this.addCount robot, WEEKCOUNT, addcount
	
	addCountTotal: (robot, addcount) ->
		return this.addCount robot, TOTALCOUNT, addcount
	
	subtractCountWeek: (robot, subcount) ->
		return this.addCount robot, WEEKCOUNT, subcount * -1
		
	subtractCountTotal: (robot, subcount) ->
		return this.addCount robot, TOTALCOUNT, subcount * -1
}