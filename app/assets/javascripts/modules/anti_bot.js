var AntiBOT = {
  init: function(form) {
    this.form   = $(form);
    this.field  = this.form.find('.not-human input');
    this.bot    = $('#bot');
    this.label  = this.form.find('.not-human label');
    this.submit = this.form.find(':submit');

    this.binds();
    this.lock();
  },

  binds: function() {
    var that = this;

    that.field.on('change', function() {
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

    that.bot.val(true);

    that.submit.on('click', function(evt) {
      evt.preventDefault();
      that.label.text('Hey! Me desmarque.');
      that.field.focus();
    });
  },

  unlock: function() {
    var that = this;

    that.submit.off('click');
    that.bot.removeAttr('value');
    that.label.text('Humanos! <3');
  }
};
