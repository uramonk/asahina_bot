require('date-utils');
dateFunc = require('../src/date')

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
		date = new Date()
		count = 0
		while true
			count += this.getCount robot, date.toFormat 'YYYYMMDD'
			date = date.addHours(-24)
			daynum = date.getDay()
			# 土曜日なら終了
			if daynum == 6
				break
		return count
	
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
		# new Dateの時はmonthを-1する
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
		return this.clearCount robot, formatted
	
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
		
	clearCountAll: (robot) ->
		firstday = this.getFirstDay robot
		if firstday == null
			return 0
		ymd = firstday.split '/'
		# new Dateの時はmonthを-1する
		fromDate = new Date(Number(ymd[0]), Number(ymd[1]) - 1, Number(ymd[2]))
		toDate = new Date()
		count = 0
		while true
			count += this.clearCount robot, fromDate.toFormat 'YYYYMMDD'
			fromDate = fromDate.addHours(24)
			if Date.compare(fromDate, toDate) == 1
				break
		return count
	
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
		return this.addCount robot, formatted, addcount
	
	setFirstDay: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYY/MM/DD'
		firstday = this.getFirstDay robot
		if firstday == null
			robot.brain.set FIRST_DAY, formatted
			robot.brain.save
			
	getFirstDay: (robot) ->
		return robot.brain.get FIRST_DAY
	
	setFirstSpecificDay: (robot, ymdString) ->
		date = new Date(ymdString)
		formatted = date.toFormat 'YYYY/MM/DD'
		firstday = this.getFirstDay robot
		firstDate = new Date(firstday)
		console.log Date.compare(date, firstDate) 
		if firstday == null or Date.compare(date, firstDate) == -1
			robot.brain.set FIRST_DAY, formatted
			robot.brain.save
}