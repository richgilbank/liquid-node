toNumber = (input) ->
  Number input

toObjectString = Object::toString
  
isString = (input) ->
  toObjectString.call(input) is "[object String]"

toString = (input) ->
  unless input?
    ""
  else if isString input
    input
  else if typeof input.toString is "function"
    input.toString()
  else
    toObjectString.call input

# TODO: iterable -> array
toArray = (input) ->
  if Array.isArray input
    input
  else
    [input]

HTML_ESCAPE = (chr) ->
  switch chr
    when "&" then '&amp;'
    when ">" then '&gt;'
    when "<" then '&lt;'
    when '"' then '&quot;'
    when "'" then '&#39;'

HTML_ESCAPE_ONCE_REGEXP = /["><']|&(?!([a-zA-Z]+|(#\d+));)/g

HTML_ESCAPE_REGEXP = /([&><"'])/g


module.exports =

  size: (input) ->
    input?.length ? 0

  downcase: (input) ->
    toString(input).toLowerCase()

  upcase: (input) ->
    toString(input).toUpperCase()

  append: (input, other) ->
    [toString(input), toString(other)].join("")

  prepend: (input, other) ->
    [toString(other), toString(input)].join("")

  empty: (input) ->
    return true unless input
    return false unless input.length?
    true

  capitalize: (input) ->
    toString(input).replace /^([a-z])/, (m, chr) ->
      chr.toUpperCase()

  sort: (input, property) ->
    if property?
      toArray(input).sort (a, b) ->
        aValue = a[property] 
        bValue = b[property] 

        aValue > bValue ? 1 : (aValue == bValue ? 0 : -1)
    else
      toArray(input).sort()

  map: (input, property) ->
    toArray(input).map (e) ->
      if property? 
        e[property]
      else
        e

  escape: (input) ->
    toString(input).replace HTML_ESCAPE_REGEXP, HTML_ESCAPE

  escape_once: (input) ->
    toString(input).replace HTML_ESCAPE_ONCE_REGEXP, HTML_ESCAPE

  # References:
  # - http://www.sitepoint.com/forums/showthread.php?218218-Javascript-Regex-making-Dot-match-new-lines 
  strip_html: (input) ->
    toString(input)
      .replace(/<script[\s\S]*?<\/script>/g, "")
      .replace(/<!--[\s\S]*?-->/g, "")
      .replace(/<style[\s\S]*?<\/style>/g, "")
      .replace(/<[^>]*?>/g, "")

  strip_newlines: (input) ->
    toString(input).replace(/\r?\n/g, "")

  newline_to_br: (input) ->
    toString(input).replace(/\n/g, "<br />\n")

  # To be accurate, we might need to escape special chars in the string
  # 
  # References:
  # - http://stackoverflow.com/a/1144788/179691
  replace: (input, string, replacement = "") ->
    toString(input).replace(new RegExp(string, 'g'), replacement)

  replace_first: (input, string, replacement = "") ->
    toString(input).replace(string, replacement)

  remove: (input, string) ->
    @replace(input, string)

  remove_first: (input, string) ->
    @replace_first(input, string)

  truncate: (input, length = 50, truncateString = '...') ->
    input = toString(input)
    truncateString = toString(truncateString)

    return unless input?
    return unless input.slice

    length = toNumber(length)
    l = length - truncateString.length
    l = 0 if l < 0

    if input.length > length then input[..l] + truncateString else input

  truncatewords: (input, words = 15, truncateString = '...') ->
    input = toString(input)

    return unless input?
    return unless input.slice

    wordlist = input.split(" ")
    words = toNumber(words)
    l = words - 1
    l = 0 if l < 0

    if wordlist.length > l
      wordlist[..l].join(" ") + truncateString
    else
      input

  split: (input, pattern) ->
    input = toString(input)
    return unless input
    input.split(pattern)

  ## TODO!!!

  flatten: (input) ->
    Liquid.Helpers.flatten toArray(input)

  join: (input, glue=' ') ->
    @flatten(input).join(glue)

  ## TODO!!!


  # Get the first element of the passed in array
  #
  # Example:
  #    {{ product.images | first | to_img }}
  #
  first: (array) ->
    if array?.length > 0
      array[0]
    else
      null

  # Get the last element of the passed in array
  #
  # Example:
  #    {{ product.images | last | to_img }}
  #
  last: (array) ->
    if array?.length > 0
      array[array.length-1]
    else
      null

  plus: (input, operand) ->
    toNumber(input) + toNumber(operand)

  minus: (input, operand) ->
    toNumber(input) - toNumber(operand)

  times: (input, operand) ->
    toNumber(input) * toNumber(operand)

  dividedBy: (input, operand) ->
    toNumber(input) / toNumber(operand)

  divided_by: (input, operand) ->
    @dividedBy(input, operand)

  modulo: (input, operand) ->
    toNumber(input) % toNumber(operand)
