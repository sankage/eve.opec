jQuery ($) ->
  deromanize = (str) ->
    str = str.toUpperCase()
    validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/
    token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g
    key = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1}
    num = 0
    return false if !(str && validator.test(str))
    while m = token.exec(str)
      num += key[m[0]]
    num
  pad = (number, size) ->
    s = "" + number
    while s.length < size
      s = "0" + s
    s

  parse_time = (time) ->
    regExp = /(-?\d+)\sdays,\s(\d+)\shours,\s(\d+)\sminutes/i
    parts = time.match(regExp)
    return (parseInt(parts[1], 10) * 24 * 60) +
           (parseInt(parts[2], 10) * 60) +
            parseInt(parts[3], 10)
  parse_location = (location) ->
    regExp = /(\w+)\s([IVX]+)moon\s(\d+)/i
    parts = location.match(regExp)
    return parts[1] + pad(deromanize(parts[2]), 2) + pad(parts[3], 2)

  $('thead .sortable.time').on 'click', (event) ->
    sortable = $(this)
    column_index = sortable.index()
    table = sortable.closest('table')
    rows = $('tbody tr.online', table)
    rows.detach()
    rows.sort (a, b) ->
      side_a = parse_time($('td', a).eq(column_index).text())
      side_b = parse_time($('td', b).eq(column_index).text())
      return side_a - side_b
    $('tbody', table).prepend(rows)

  $('thead .sortable.location').on 'click', (event) ->
    sortable = $(this)
    column_index = sortable.index()
    table = sortable.closest('table')
    rows = $('tbody tr', table)
    rows.detach()
    rows.sort (a, b) ->
      side_a = parse_location($('td', a).eq(column_index).text())
      side_b = parse_location($('td', b).eq(column_index).text())
      return -1 if side_a < side_b
      return 1 if side_a > side_b
      return 0 if side_a == side_b
    $('tbody', table).append(rows)
