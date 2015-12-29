require('date-utils');

module.exports = {
	getDaysInMonth: (year, month) ->
		return new Date(parseInt(year, 10), parseInt(month, 10), 0).getDate();
}