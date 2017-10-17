// JavaScript Document
$(function() {

	var menu = $("#menu");
	var menuclose = $(".menubj");
	var headc = $(".headc");
	var boxer = $(".boxer");

	$(".heada1").on('click', function() {
		menu.addClass("push");
		headc.addClass("push");
		boxer.addClass("push");

	});
	$(menuclose).on('click', function() {

		menu.removeClass("push");
		headc.removeClass("push");
		boxer.removeClass("push");

	});
	var map_w = $(document.body).width(),

		map_h = $(window).height();

	$("#allmap").css("width", map_w);

	$("#allmap").css("height", map_h);

	$("#bdmap").css("height", map_h);

});