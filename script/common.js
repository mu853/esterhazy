$(function(){
  if(navigator.userAgent.indexOf("iPhone")  > 0 ||
     navigator.userAgent.indexOf("iPad")    > 0 ||
     navigator.userAgent.indexOf("iPod")    > 0 ||
     navigator.userAgent.indexOf("Android") > 0){
    return;
  }

  $("img[class='small']").hover(
    function(){ $(this).stop().animate({ "width"  : "600px" }, "fast"); },
    function(){ $(this).stop().animate({ "width"  : "180px" }, "fast"); }
  );
  $("img[class='small']").click(
    function(){ $(this).stop().animate({ "width"  : "180px" }, "fast"); }
  );
});
