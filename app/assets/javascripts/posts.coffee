# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->                        # 画面が表示されたら、以下を実行せよ
  $('.request_ajax_update')                                 # request_ajax_updateクラスの要素に対し
    .on 'ajax:complete', (event, data, status, xhr) ->      # ajax:completeを受け取った時の動作(コールバック)を登録
      $(this).children('.upproval_state').html(data.responseText)       # この要素の下のupproval_stateクラスの要素の中身htmlを
                                                                        # 受け取ったdataのresponseTextで置き換える
                                                                        # これはposts_controlのrender :plainで入れている
  
  $('.rs-query').change ->                        # クエリタグの中身変更したら、
    text = ($(this).text().trim())                # まずテキストを取り出し
    $(this).siblings('.rs-input').val(text)       # 自動でinputタグのval(クエリ)も変更する
    if text != ""                                 # さらに、何かしら空白以外が入った時は、
      $(this).closest('.refine-search').find('.collapse').collapse('hide')                          # そこの一覧も閉じる
      $(this).closest('.refine-search').next('.refine-search').find('.collapse').collapse('show')   # さらにその下の単語リストを開く
    $(this).closest('.refine-search').next('.refine-search').find('.rs-query').text('').change()    # さらにそれ以下のクエリを消して
  
  $('.rs-card')                                         # <div id="rs-card-<%= id%>" class="collapse rs-card">
    .on 'show.bs.collapse', (e)->                       # 一覧が表示された時, bs=bootstrap, e=event
      id = $(this).prop('id').split('-')[-1..][0]       # idとは、region, area, problemなど
      if id == 'region'                                 # regionタグの時
        to_show = gon.names[id]                         # そのままとってこれる
      else                                              # areas, problemsの時は直上のクエリから選択
        upper_query  = $(this).closest('.refine-search').prev('.refine-search').find('.rs-query').text().trim()
        if upper_query == ''    # 直上のクエリに何もない時(regionは例外S)
          e.preventDefault()
          return
        to_show = gon.names[id].filter((x) -> x[0]==upper_query).map((x) -> x[1])
      # 以下、実際に表示する場合まず、他のcollapseを全部閉じる
      $(this).closest('.refine-search').siblings('.refine-search').find('.collapse').collapse('hide')
      if to_show.length == 0
        $(this).find('.card-body').empty().text('まだサイトに動画がありません(>_<)')
      else
        $(this).find('.card-body').empty().append(get_table(id, to_show))   # 中身をからにしてから、新規に入れる
    
get_table = (id, items) ->
  table = document.createElement('table')     # テーブル作成
  table.setAttribute('class','table')         # クラス指定
  
  tbody = document.createElement('tbody')     # テーブルの中身
  table.appendChild(tbody)                    # くっつける
  
  column_num = 4
  items = items.map((x,i) -> i)
              .filter((i) -> i%column_num==0)
              .map((i)-> items.slice(i, i+column_num))    # 表示項目を4つづつに区切る
  for row in items                            # 4つ単位で
    tr = document.createElement('tr')         # 行を作る
    tbody.appendChild(tr)                     # 行を表に追加
    for item in row                           # 行の中身を作成していく
      td = document.createElement('td')       # 項目作成
      tr.appendChild(td)                      # 追加

      a = document.createElement('a')
      a.setAttribute('class',"rs-word")
      a.setAttribute('data-toggle', 'collapse')
      a.setAttribute('data-target', "#rs-card-#{id}")
      a.text = item
      td.appendChild(a)
      
      $(a).on 'click', ->
        name = $(this).text()
        $(this).closest('.refine-search')
          .find('.rs-query').text(name).change()    # 上に設定
  return table

        

        