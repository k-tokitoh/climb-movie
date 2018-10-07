# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 画面がロードされたら、以下を実行せよ
$(document).on 'turbolinks:load', ->

  # 
  $('#refine_search_body').hide()

  # 
  $('#refine_search_title').on 'click', ->
    $('#refine_search_body').toggle 250, ->
      if $('#refine_search_body').css('display') is 'none'
        $('#refine_search_title').html('<i class="fas fa-plus-square"></i> 絞りこみ検索')
      else
        $('#refine_search_title').html('<i class="fas fa-minus-square"></i> 絞りこみ検索')

  # 
  $('#current_region').on 'click', ->
    $('#refine_search_body').show()

  # 
  $('#current_area').on 'click', ->
    $('#refine_search_body').show()

  # 再生回数のカウント
  $('.thumbnail').on 'click', ->
    _post_id = $(this).closest('.post').attr('id')
    
    $.ajax
      async:        true,
      type:         "GET",
      url:          "/increment_hits",
      data:         {post_id: _post_id},
      dataType:     'text',
      context:      this,
      success:      (event) ->
        # debugger
        $('#hit_'+_post_id).text(String(event)+' views')

  # 承認状況の更新
  $('.request_ajax_update')                                 # request_ajax_updateクラスの要素に対し
    .on 'ajax:complete', (event, data, status, xhr) ->      # ajax:completeを受け取った時の動作(コールバック)を登録
      $(this).children('.upproval_state').html(data.responseText)       # この要素の下のupproval_stateクラスの要素の中身htmlを
                                                                        # 受け取ったdataのresponseTextで置き換える
                                                                        # これはposts_controlのrender :plainで入れている