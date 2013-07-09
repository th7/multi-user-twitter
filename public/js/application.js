var drawToast = function(message) {
  var toastHTML = '<div id="toast">' + message + '</div>'

  $('body').prepend(toastHTML);

  setTimeout(hideToast, 2000);
}

var hideToast = function() {
  $toast = $('#toast');
  $('#toast').css('opacity', '0');
  setTimeout(removeToast, 1000);

}

var removeToast = function() {
  $('#toast').remove();
}


var onResult = function(data) {
  drawToast(data);
  $('#submit').removeAttr('disabled');
  $('#wait').toggle();
};

var onSubmit = function(event) {
  event.preventDefault();
  $.post(this.action, $(this).serialize(), onResult);
  $('#submit').attr('disabled', 'disabled');
  $('#wait').toggle();
};

$(document).ready(function() {
  $('form').on('submit', onSubmit);
});
