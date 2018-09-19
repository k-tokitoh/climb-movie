# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->                                                        # 画面が表示されたら、以下を実行せよ
  $('.request_ajax_update')                                 # request_ajax_updateクラスの要素に対し
    .on 'ajax:complete', (event, data, status, xhr) ->      # ajax:completeを受け取った時の動作(コールバック)を登録
      $(this).children('.upproval_state').html(data.responseText)       # この要素の下のupproval_stateクラスの要素の中身htmlを
                                                                        # 受け取ったdataのresponseTextで置き換える
                                                                        # これはposts_controlのrender :plainで入れている
  
  
  $('.post_title')
    .on 'click',  ->
      $(this).siblings('.collapse').collapse('toggle')
  
