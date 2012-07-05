var Rabble = (function() {
  function init() {
    $('#go').click(function(evt) {
      evt.preventDefault();
      var paragraphs = $('#paragraphs').val();
      var order = $('#order').val();
      window.location = '/' + paragraphs + '?order=' + order;
    });
  }

  return {
    init: init
  };
})();

$(Rabble.init);
