function closeMessage(button) {
  $(button).parent().fadeOut('fast');
};

function loading(boo, title, description, style, autohide) {
  var messages = $('#messages').empty(),
      alert    = $('<div />', { 'class': style });

  if (boo) {
    var message = $('<span />'),
        title   = $('<strong />', { html: title, 'class': 'alert' }),
        close   = $('<input />', { type: 'button', value: '×', 'class': 'close' });

    close.on('click', function() {
      closeMessage(this);
    });

    if (title) {
      message.append(title);
    }

    message.append(description);

    messages.show().append(alert.append(message, close));

    if (autohide) {
      setTimeout(function() {
        alert.fadeOut();
      }, 5000);
    }
  }
};

$(function() {
  $('#messages').find('.close').on('click', function() {
    $(this).parent().fadeOut('fast');
  });
});
