var date_shown = "dd-M-yy", date_db = "yy-mm-dd", gthsep = ".", gdsep = ",";
Number.prototype.toMoney = function(thsep, dsep, ndeci){
	var n = this, 
		ndeci = isNaN(ndeci = Math.abs(ndeci)) ? 2 : ndeci,
		thsep = thsep == undefined ? gthsep : thsep, 
		dsep = dsep == undefined ? gdsep : dsep,
		i = parseInt(n = Math.abs(+n || 0).toFixed(ndeci)) + "",
		j = (j = i.length) > 3 ? j % 3 : 0;
	return (j ? i.substr(0, j) + thsep : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1"+thsep) + 
		dsep + Math.abs(n - i).toFixed(ndeci).slice(2);
};
Number.prototype.insertThousandSeparator = function(thsep) {
	var i = this + "", j = (j = i.length) > 3 ? j % 3 : 0, thsep = thsep == undefined ? gthsep : thsep;
	return (j ? i.substr(0, j) + thsep : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1"+thsep);
};
String.prototype.toReal = function(){
	var nstr = this;
	if (gdsep != '.') {
		nstr = nstr.replace(/[.]/g,'').replace(/[,]/g,'.');
	}
	return parseFloat(nstr.replace(/[^0-9-.]/g,''));
};
String.prototype.toDateFormat = function (fm) { return  new Date(this).toFormat(fm); };

Date.prototype.toFormat = function (fm) { return $.datepicker.formatDate(fm, this); };
Date.prototype.getCurrentQuarter = function() { return Math.floor(this.getMonth()/3) + 1; };
Date.prototype.getCurrentWeek = function() {
	var passed = this.getDay(), cury = this.getFullYear(), month = this.getMonth(), date = this.getDate();
	return {start: new Date(cury, month, date - passed), end: new Date(cury, month, date + (6 - passed))};
};
Date.getLastMonthDate = function(month, cury) { 
	var d = new Date(), cury = isNaN(cury) ? d.getFullYear() : cury,
		month = isNaN(month = Math.abs(month)) ? d.getMonth() : month;
	return new Date(cury, month+1, 0);
};
Date.getQuarterRange = function(q) {
	var cury = new Date().getFullYear();
	switch(q) {
		case 1: return {start: new Date(cury, 0, 1), end: new Date(cury, 2, 31) };
		case 2: return {start: new Date(cury, 3, 1), end: new Date(cury, 5, 30) };
		case 3: return {start: new Date(cury, 6, 1), end: new Date(cury, 8, 30) };
		case 4: return {start: new Date(cury, 9, 1), end: new Date(cury, 11, 31) };
	};
};

$(document).on('focusout','.select2-container', function (e){
	// console.log('fucking status role');
	$('span.select2-hidden-accessible').hide();
});