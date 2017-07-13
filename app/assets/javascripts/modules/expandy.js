var Expandy = {
  init: function(selector) {
    this.selector = selector;

    this.binds();
  },

  binds: function() {
    $(document)

    .one('focus.expandy', this.selector, function(){
      var savedValue = this.value;

      this.baseScrollHeight = this.scrollHeight;
      this.value            = '';
      this.value            = savedValue;
    })

    .on('input.expandy', this.selector, function() {
      var minRows = parseInt(this.getAttribute('data-spandy-rows'), 10) || 0, rows;

      this.rows = minRows;
      rows      = Math.ceil((this.scrollHeight - this.baseScrollHeight) / 17);
      this.rows = minRows + rows;
    });
  }
};
