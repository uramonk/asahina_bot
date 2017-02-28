# Description
#   This file defines `list` commands.
#
# Dependencies:
#   "date-utils": "^1.2.17"
#   "../src/counter"
#   "../src/message"
#
# Commands:
#	asabina_bot list - list all doughnuts
#	asabina_bot list month YYYY/MM - list specified month's doughnuts
#	asabina_bot list year YYYY - list specified year's doughnuts
#
# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils')
counter = require('../src/counter')
msgFunc = require('../src/message')

module.exports = (robot) ->
  robot.respond /list$/, (msg) ->
    firstday = counter.getFirstDay robot
    if firstday == null
      return
    year = firstday.split('/')[0]
    today = new Date()
    date = new Date(year, 0, 1)
    sendMessage = ''
    while true
      count = counter.getCountYear robot, date.toFormat('YYYY')
      dateString = date.toFormat 'YYYY年'
      sendMessage = msgFunc.addDoughnutToMessageWithPrefixAndSuffix sendMessage, count, dateString + ': ', '\n'
      date.addYears(1)
      if Date.compare(date, today) == 1
        break
    msg.send '```\n' + sendMessage + '```\n'

  robot.respond /list month (\d{4}\/\d{2})$/, (msg) ->
    ym = msg.match[1].split('/')
    year = ym[0]
    month = ym[1]
    date = new Date(Number(year), Number(month) - 1, 1)
    sendMessage = ''
    while true
      key = counter.getKey date
      count = counter.getCount robot, key
      dateString = date.toFormat 'YYYY年MM月DD日'
      sendMessage = msgFunc.addDoughnutToMessageWithPrefixAndSuffix sendMessage, count, dateString + ': ', '\n'
      date.addHours(24)
      if date.getMonth() > Number(month) - 1 or date.getFullYear() > Number(year)
        break
    msg.send '```\n' + sendMessage + '```\n'

  robot.respond /list year (\d{4})$/, (msg) ->
    year = msg.match[1]
    date = new Date(Number(year), 0, 1)
    sendMessage = ''
    while true
      # getMonthは0-11なので1加える
      count = counter.getCountMonth robot, Number(year), date.getMonth() + 1
      dateString = date.toFormat 'YYYY年MM月'
      sendMessage = msgFunc.addDoughnutToMessageWithPrefixAndSuffix sendMessage, count, dateString + ': ', '\n'
      date.addMonths(1)
      if date.getFullYear() > Number(year)
        break
    msg.send '```\n' + sendMessage + '```\n'
