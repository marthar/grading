var $ = require('jquery');

function loadSuggestions() {
  var val = $(".evaluation__input").val();

  if(val && val.length > 3) { 
  $.post("/admin/evaluations", { evaluation: val }, (resp) => {
      $(".evaluation__suggestions").html(resp);
    });
  }
}


$(document).on("keyup",".evaluation__input",() => {
  loadSuggestions();
});

$(function() { loadSuggestions() });

$(document).on("click",".evaluation__link",(e) => {
  var val = $(e.target).text()
  $(".evaluation__input").val(val);
});
