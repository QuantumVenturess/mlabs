$(document).ready(function() {
	$('.account').live('click', function() {
		$('.accountMenu').toggle();
		return false;
	});
	$(document).live('click', function() {
		$('.accountMenu').hide();
	});
});