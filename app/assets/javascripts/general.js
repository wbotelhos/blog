var AntiBot = {
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

var CommentResponder = {
  init: function() {
    this.body     = $('#comment_body');
    this.comments = $('.comments');
    this.parent   = $('#comment_parent_id');
    this.cancel   = $('#replying-cancel');
    this.replying = $('#replying-to');

    this.binds();
  },

  binds: function() {
    var that = this;

    that.comments.on('click', '.reply', function() {
      var self  = $(this),
          id    = self.data('id'),
          name  = self.data('name');

      that.setParent(id);
      that.write(name + ',\n\n');
      that.showReplying(id, name);
      that.showCancel();
      that.focuz();
    });

    that.cancel.on('click', function() {
      that.replying.css('visibility', 'hidden');
      that.body.val('');
      that.cancel.css('visibility', 'hidden');
      that.parent.removeAttr('value');

      that.focuz();
    });
  },

  focuz: function() {
    this.body.blur().focus();
  },

  setParent: function(id) {
    this.parent.val(id);
  },

  showCancel: function(id, name) {
    this.cancel.css('visibility', 'visible');
  },

  showReplying: function(id, name) {
    var anchor = '#comment-' + id,
        text   = '#' + id;

    this.replying.css('visibility', 'visible').children('strong').html('<a href="' + anchor + '">' + text + '</a> ' + name);
  },

  write: function(text) {
    this.body.val(text);
  }
};

$(function() {
  var heart = $('.i-heart');

  $('#logo').on('mouseover', function() {
    heart.css('color', '#FF9BC3');
  }).on('mouseout', function() {
    heart.removeAttr('style');
  });
});
