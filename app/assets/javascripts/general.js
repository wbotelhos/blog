AntiBot = {
  init: function(selector) {
    this.form   = $(selector).find('form');
    this.field  = this.form.find('.not-human input');
    this.bot    = $('#bot');
    this.label  = this.form.find('.not-human label');
    this.submit = this.form.find(':submit');

    this.binds();
    this.lock();
  },

  binds: function() {
    var that = this;

    that.field.on('change.antibot', function() {
      if (that.field.is(':checked')) {
        that.label.text('Sério?');
        that.lock();
      } else {
        that.unlock();
      }
    });
  },

  lock: function() {
    var that = this;

    that.submit.on('click.antibot', function(evt) {
      evt.preventDefault();
      that.bot.val(true);
      that.label.text('Hey! Me desmarque.');
      that.field.focus();
    });
  },

  unlock: function() {
    var that = this;

    that.submit.off('.antibot');
    that.bot.removeAttr('value');
    that.label.text('Humanos! <3');
  }
};

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
