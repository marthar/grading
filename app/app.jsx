var $ = require('jquery');

function loadSuggestions() {
  var val = $(".evaluation__input").val();

  var studentId = $("[data-student-id]").attr('data-student-id');

  console.log(studentId);
  console.log("WTF?");
  if(val && val.length > 3) { 
  $.post("/admin/evaluations", { evaluation: val, student_id: studentId  }, (resp) => {
      $(".evaluation__suggestions").html(resp);
    });
  }
}


$(document).on("keyup",".evaluation__input",() => {
  loadSuggestions();
});

$(function() { loadSuggestions() });

$(document).on("click",".evaluation__link",(e) => {
  var val = $(e.target).data("full")

  $(".evaluation__input").val(val);
});
