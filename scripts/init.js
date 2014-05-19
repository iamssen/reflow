$(document).ready(function () {
	$('#contents table').addClass('table table-striped table-bordered');
	$('#contents img').click(function (event) {
		if ($(this).parent().prop('tagName').toLowerCase() !== "a") {
			var args = {href: $(this).attr('src')};

			if ($(this).attr('alt')) {
				args['title'] = $(this).attr('alt');
			}

			$.fancybox.open(args);
		}
	});
});