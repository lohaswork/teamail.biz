!function($) {

  App.page.TopicCheckControls = function (){
    this.init();
  }

  App.page.TopicCheckControls.prototype = {

    init: function(){
      $('.timeago').timeago();
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
          $("#archive-submit").attr("disabled",false);
          $("#tagging-dropdown").attr("disabled",false);
        } else {
          $("#archive-submit").attr("disabled","disabled");
          $("#tagging-dropdown").attr("disabled","disabled");
        }
      })
      .on("click", "#tagging-dropdown", function(e){
        $("#dropdown-tags").toggle();
        e.stopPropagation();
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
      .on("refreshed", "#tag-list", function(e) {
        $("#tag-input input[type='text']").val("");
        e.stopPropagation();
      })
      .on('change', '.topic-check-all input[data-all]', function(){
        var selectAll = $(this);
        $("#select-topic").find("input[data-item]").prop('checked', function(){
          var me = $(this),
              checkStatus = selectAll.is(':checked'),
              checkEvent = checkStatus ? 'checked' : 'unchecked';
          //if the checkbox status is not same as the select-all, then change and trigger the event
          if (me.is(':checked') !== checkStatus) {
            me.trigger(checkEvent);
          }
          if (checkStatus) {
            $("#archive-submit").attr("disabled",false);
            $("#tagging-dropdown").attr("disabled",false);
          } else {
            $("#archive-submit").attr("disabled","disabled");
            $("#tagging-dropdown").attr("disabled","disabled");
          }
          return checkStatus;
        });
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
    },
    refreshTopicList: function(){
      $(document).on("refreshed", "#topic-list", function (e) {
        // reload timeago
        $('.timeago').timeago();
        // clear hidden field
        $('#selected_topics_to_tagging').val("");
        $('#selected_tags').val("");
        $('#selected_topics_to_archive').val("");
        // make button status init
        $("#dropdown-tags").hide();
        $("#tagging-dropdown").attr("disabled","disabled");
        if ($("#archive-submit")) {
          $("#archive-submit").attr("disabled","disabled");
        }
        $("#tag-list :checkbox").attr('checked', false);
        $("#topic-list :checkbox").attr('checked', false);
        $('.topic-check-all input[data-all]').attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
        e.stopPropagation();
      });
    }
  }
}(window.jQuery);
