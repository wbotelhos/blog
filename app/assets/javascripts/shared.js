$(function() {
  var donations = $('#donations');

  $('.i-heart').on('click', function() {
    donations.slideToggle('fast');
  });
});
