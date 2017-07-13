var CommentResponder = {
  init: function() {
    this.body     = $('#comment_body');
    this.comments = $('.comments');
    this.parent   = $('#comment_parent_id');
    this.cancel   = $('.commenter__cancel');
    this.replying = $('.commenter__replying');

    this.binds();
  },

  binds: function() {
    var that = this;

    that.comments.on('click', '.comments__reply', function() {
      var
        self  = $(this),
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
    this.body.trigger('blur').trigger('focus');
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
