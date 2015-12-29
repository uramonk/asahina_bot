require('date-utils');
dateFunc = require('../src/date')

WEEKCOUNT = 'weekcount'
FIRST_DAY = "firstday"

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
			count += this.getCount robot, date.toFormat 'YYYYMMDD'
			date = date.addHours(24)
		return count
	
	getCountYear: (robot, year) ->
		date = new Date(year, 0, 1)
		count = 0
		for month in [1..12]
			count += this.getCountMonth robot, year, month
			date = date.addMonths(1)
		return count
	
	getCountTotal: (robot) ->
		firstday = this.getFirstDay robot
		if firstday == null
			return 0
		ymd = firstday.split '/'
		fromDate = new Date(Number(ymd[0]), Number(ymd[1]) - 1, Number(ymd[2]))
		toDate = new Date()
		count = 0
		while true
			count += this.getCount robot, fromDate.toFormat 'YYYYMMDD'
			fromDate = fromDate.addHours(24)
			if Date.compare(fromDate, toDate) == 1
				break
		return count
		
	clearCount: (robot, key) ->
		robot.brain.set key, 0
		robot.brain.save
		return robot.brain.get key
		
	clearCountToday: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		# 週の数から今日食べた数を引く
		count = this.getCountToday robot
		this.subtractCountWeek robot, count
		return this.clearCount robot, formatted
	
	clearCountWeek: (robot) ->
		return this.clearCount robot, WEEKCOUNT
	
	clearCountMonth: (robot, year, month) ->
		# new Dateの時はmonthを-1する
		date = new Date(year, month - 1, 1)
		daysInMonth = dateFunc.getDaysInMonth year, month
		count = 0
		for i in [1..daysInMonth]
			count += this.clearCount robot, date.toFormat 'YYYYMMDD'
			date = date.addHours(24)
		return count
		
	clearCountYear: (robot, year) ->
		date = new Date(year, 0, 1)
		count = 0
		for month in [1..12]
			count += this.clearCountMonth robot, year, month
			date = date.addMonths(1)
		return count
		
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
		
	setFirstDay: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYY/MM/DD'
		firstday = this.getFirstDay robot
		if firstday == null
			robot.brain.set FIRST_DAY, formatted
			robot.brain.save
			
	getFirstDay: (robot) ->
		return robot.brain.get FIRST_DAY
}