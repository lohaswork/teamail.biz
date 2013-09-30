!function($) {

  App.page.TaggingControls = function (){
    this.init();
  }

  App.page.TaggingControls.prototype = {
    init: function(){
      $(document).bind('click',function(e){
          var e = e || window.event; //浏览器兼容性
          var elem = e.target || e.srcElement;
          while (elem) { //循环判断至跟节点，防止点击的是div子元素
              if (elem.id && elem.id=="tagging-controls") {
                  return;
              }
              elem = elem.parentNode;
          }
          $('#dropdown-tags').hide(); //点击的不是div或其子元素
      });
      $(document).on("click", "#select-topic input[data-item]", function(){
        if (sumCheckStatus("#select-topic") > 0) {
          $("#tagging-dropdown").attr("disabled",false);
        } else {
          $("#tagging-dropdown").attr("disabled","disabled");
        }
      })// Enable #tagging-dropdown button
      .on("click", "#tagging-dropdown", function(){
        $("#dropdown-tags").toggle();
        return false;
      })
      .on('keyup', '#tag_name', function(){
        if ($('#tag_name').val() != "") {
          $("#tag-submit").attr("disabled",false);
        } else {
          $("#tag-submit").attr("disabled","disabled");
        }
      })// Enable tags create button
      .on("click", "#tag-list input[data-item]", function(){
        if (sumCheckStatus("#tag-list") > 0) {
          $("#tagging-submit").show();
          $("#tag-input").hide();
        } else {
          $("#tagging-submit").hide();
          $("#tag-input").show();
        }
      })// Enable tags submit button
      .on("refreshed", "#topic-list", function () {
        $("#dropdown-tags").hide();
        $("#tagging-dropdown").attr("disabled","disabled");
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
      })
      .on("refreshed", "#tag-list", function () {
        $("#tag-input input[type='text']").val("");
      });

      var sumCheckStatus = function(check_element) {
        var check_status = 0;
        var checkbox_group = $(check_element).find(':checkbox');
        checkbox_group.each(function(index,element) {
          if($(element).prop('checked')){
            check_status += 1;
          }
        });
        return check_status;
      };
    }
  }
}(window.jQuery);