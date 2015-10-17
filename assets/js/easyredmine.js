$(document).ready(function () {

	$(".saveissue").click(function () {
  	
		console.log($(this));
  	//var issue = $(this).attr("#data-issue");
  	var issue = $(this).attr('data-id');

  	console.log( issue );


  	//alert("Handler for .click() called." + issue);

  });

});