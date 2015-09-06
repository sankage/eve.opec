jQuery ($) ->
  parse_time = (time) ->
    regExp = /(-?\d+)\sdays,\s(\d+)\shours,\s(\d+)\sminutes/i
    parts = time.match(regExp)
    return (parseInt(parts[1], 10) * 24 * 60) +
           (parseInt(parts[2], 10) * 60) +
            parseInt(parts[3], 10)

  $('thead .sortable').on 'click', (event) ->
    sortable = $(this)
    column_index = sortable.index()
    table = sortable.closest('table')
    rows = $('tbody tr.online', table)
    rows.detach()
    rows.sort (a,b) ->
      side_a = parse_time($('td', a).eq(column_index).text())
      side_b = parse_time($('td', b).eq(column_index).text())
      return side_a - side_b
    $('tbody', table).prepend(rows)

