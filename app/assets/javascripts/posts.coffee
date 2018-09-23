# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->                                                        # 画面が表示されたら、以下を実行せよ
  $('.request_ajax_update')                                 # request_ajax_updateクラスの要素に対し
    .on 'ajax:complete', (event, data, status, xhr) ->      # ajax:completeを受け取った時の動作(コールバック)を登録
      $(this).children('.upproval_state').html(data.responseText)       # この要素の下のupproval_stateクラスの要素の中身htmlを
                                                                        # 受け取ったdataのresponseTextで置き換える
                                                                        # これはposts_controlのrender :plainで入れている
  
  
  $('.rs-word')
    .on 'click', ->
      area_name = $(this).text()
      $(this).closest('.refine-search')
        .find('.rs-title').text(area_name)    # 上に設定
      $(this).closest('.refine-search')
          .closest('.refine-search').find('.rs-input').val(area_name)
      $(this).closest('.refine-search')
        .nextAll('.refine-search').find('.rs-title').text('')
      $(this).closest('.refine-search')
          .nextAll('.refine-search').find('.rs-input').val('')
      $(this).closest('.refine-search')
        .nextAll('.refine-search').find('table').remove()
      $(this).closest('.refine-search')
        .next('.refine-search').find('.card-body').append(get_table('area', gon.names.find((x) -> x[0]==area_name)[1], 'problem'))
      
get_table = (id, items, next_id) ->
  table = document.createElement('table')     # テーブル作成
  table.setAttribute('class','table')         # クラス指定
  tbody = document.createElement('tbody')     # テーブルの中身
  table.appendChild(tbody)                    # くっつける
  newitems = items.map((x,i) -> i).filter((i) -> i%4==0).map((i)-> items.slice(i, i+4))    # 表示項目を4つづつに区切る
  console.log(newitems)
  for row in newitems                         # 4つ単位で
    tr = document.createElement('tr')         # 行を作る
    tbody.appendChild(tr)                     # 行を追加
    for item in row                           # 行の中身を作成していく
      td = document.createElement('td')       # 項目作成
      tr.appendChild(td)                      # 追加

      a = document.createElement('a')
      a.setAttribute('data-toggle', 'collapse')
      a.setAttribute('data-target', "#rs-#{id}")
      td.appendChild(a)

      h6 = document.createElement('h6')
      h6.setAttribute('class',"rs-word")
      if next_id != null
        h6.innerText = item[0]
      else
        h6.innerText = item
      $(h6).on 'click', ->
        name = $(this).text()
        $(this).closest('.refine-search')
          .find('.rs-title').text(name)    # 上に設定
        $(this).closest('.refine-search')
          .closest('.refine-search').find('.rs-input').val(name)
        if next_id != null
          $(this).closest('.refine-search')
            .nextAll('.refine-search').find('.rs-title').text('')
          $(this).closest('.refine-search')
            .nextAll('.refine-search').find('table').remove()
          $(this).closest('.refine-search')
            .next('.refine-search').find('.card-body').append(get_table(next_id, items.find((x) -> x[0]==name)[1], null))
      a.appendChild(h6)
  return table

        

        