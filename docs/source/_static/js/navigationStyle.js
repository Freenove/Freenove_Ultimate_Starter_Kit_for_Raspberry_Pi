// JavaScript Document
$(document).ready(function () {
	loadReady();

});
$(window).resize(function () {
	// console.log('resize ... ');
	NaviResize();
});

function loadReady() {
	// console.log('ready ... ');
	NaviResize();
	var autoPlay2 = setInterval("test()", 1000);
	$(".dropBtn").click(function () {
		// $(this).css("background-color", "#FFF");
		$("#txt").text("click:");
	});
}

function NaviResize() {
	// var wy_nav_side = document.getElementsByClassName('wy-nav-side')[0];
	// var wy_nav_content = document.getElementsByClassName('wy-nav-content')[0];
	// // var nav_fn = document.getElementsByClassName('nav_fn')[0];
	// var rect_wy_nav_side = wy_nav_side.getBoundingClientRect();
	// // var rect_wy_nav_content = wy_nav_content.getBoundingClientRect();
	// // var rect_nav_fn = nav_fn.getBoundingClientRect();
	// console.log('rect_wy_nav_side :', rect_wy_nav_side.width);
	// console.log('wy_nav_content:', wy_nav_content.width);
	// $('.wy-nav-content').on
	// // var winWidth = $(window).width();
	// console.log("wy-nav-side " + $('.wy-nav-side').width() + ' wy-nav-content: ' + $('.wy-nav-content').outerWidth(true) + " " + $('.wy-nav-side').offset().left + "");
	var navWidth = $('.wy-nav-side').width() + $('.wy-nav-content').outerWidth(true) + $('.wy-nav-side').offset().left;
	var navHeight = $(".extrabody-content").height();
	var navItemWidth = navWidth / 7;
	navItemWidth = navItemWidth < 60 ? 60 : navItemWidth;
	var navItemHeight = navItemWidth / 5;
	console.log("navWidth " + navWidth + ' navItemWidth: ' + navItemWidth + " " + $('.wy-nav-side').offset().left + "");
	// $(".extrabody-content").height(navItemWidth);
	// $(".nav_fn").height(navItemHeight);
	// $(".nav_fn>ul").css("line-height", navItemHeight + "px");
	$(".nav_fn>ul>li").width(navItemWidth);
	// console.log('.extrabody-content.height: ' + $(".extrabody-content").height());
	$(".nav_fn>ul>li").height($(".extrabody-content").height);
	$(".nav_fn>ul a").css("font-size", navItemWidth * 0.15 + "px");
	
}
function test() {
	//var today=new Date()
	//var h=today.getHours()
	//var m=today.getMinutes()
	//var s=today.getSeconds()
	$("#txt").fadeToggle(1000);
	//$("#txt").text(bannerCount+":"+winWidth);
}