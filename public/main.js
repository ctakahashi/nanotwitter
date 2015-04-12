var main = function() {
	$('.tweet-text').keyup(function() {
		var postLength = $(this).val().length;
		var charactersLeft = 140 - postLength;
		$('.counter').text(charactersLeft);
	});
};
$(document).ready(main);