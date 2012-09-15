// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require moment
//= require moment/en-gb
//= require_tree .

$(function() {

  moment.lang('en-gb');

  $("time.ago").each(function(index, time) {
    var human, iso8601, mo;
    iso8601 = $(time).attr("datetime");
    mo = moment(iso8601);
    if (mo.diff(new Date()) < -(1 * 24 * 60 * 60 * 1000) ) {
      //2:55 PM - 8 Sep 12
      human = mo.format("[at] HH:MM — MMM YYYY");
    } else {
      human = mo.fromNow();
    }
    return $(time).html(human);
  });

  $('.timeline select').on('change', function() {
    $(this).parents('form').submit();
  });

  $(".flash").click(function() {
    $(this).slideUp(function() {
      $(this).remove();
    })
  });

});