function blurLabel() {
	var field = $(this);

	if (field.val() == '') {
		field.val(field.attr('title')).css('color', '#BBB');
	}
};

function focusLabel() {
	var field = $(this);

	if (field.val() == field.attr('title')) {
		field.val('').css('color', '#444');
	}
};

$(function() {

  $('#social img').on('mouseover', function() {
    $(this).animate({ 'opacity': 1 }, { duration: 100, queue: false });
  }).on('mouseout', function() {
    $(this).animate({ 'opacity': .6 }, { duration: 100, queue: false });
  });

});
