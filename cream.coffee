# Copyright (C) 2012 Mark Huetsch
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Object.delete = (obj, k) ->
  v = obj[k]
  delete obj[k]
  v

Object.clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = Object.clone obj[key]

  return newInstance

Object.merge = (o1, o2) ->
  o1 = Object.clone o1
  for own k, v of o2
    o1[k] = v
  o1

Object.update = (o1, o2) ->
  for own k, v of o2
    o1[k] = v
  o1

Object.toArray = (obj) ->
  [k, v] for own k, v of obj

# ported from https://github.com/medikoo/es5-ext/blob/master/lib/Object/is-plain-object.js
Object.isPlainObject = (obj) ->
   (obj and (typeof obj is 'object') and (Object.getPrototypeOf(obj) is Object.prototype) and (Object.prototype.toString.call(obj) is {}.toString())) or false

Object.fromArray = (array) ->
  o = new Object()
  for v in array
    o[v[0]] = v[1]
  o

Object.invert = (obj) ->
  Object.fromArray([v, k] for own k, v of obj)

#Object::map = (fn) ->
#  if arguments.length is 0
#    for own k, v of @

Array.wrap = (obj) ->
  if obj instanceof Array
    obj
  else if obj is null or obj is undefined
    []
  else
    [obj]

Array::sum = ->
  if this.length > 0
    this.reduce (x, y) -> x + y
  else
    0

Array::first = ->
  if this.length > 0
    this[0]
  else
    undefined

Array::last = ->
  if this.length > 0
    this[this.length - 1]

Array::butLast = ->
  if this.length > 0
    this[0...-1]

Array::max = ->
  Math.max.apply(Math, @)

Array::min = ->
  Math.min.apply(Math, @)

Array::zip = (arrs...) ->
  arrs = [Object.clone(@)].concat arrs
  max_len = arrs.map((arr) -> arr.length).max()
  ret = []
  for i in [0...max_len]
    group = []
    for arr in arrs
      group.push arr[i]
    ret.push group
  ret

Array::flatten = ->
  this.reduce ((xs, el) ->
    if Array.isArray el
      xs.concat el.flatten()
    else
      xs.concat [el]), []

Array::select = Array::filter

Array::reject = (fn) ->
  @.select (x) -> not fn(x)

Array::compact = ->
  @reject (x) -> x is undefined or x is null

Array::extract_options = ->
  if Object.isPlainObject(@.last())
    @pop()
  else
    {}

Array::group_by = (fn) ->
  assoc = {}
  for elem in this
    key = fn(elem)
    if assoc[key]
      assoc[key].push elem
    else
      assoc[key] = [elem]
  assoc


String::capitalize = ->
  if @.trim().length is 0
    @.valueOf()
  else
    (this.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')

String::humanize = () ->
  result = @.valueOf()
  #inflections.humans.each { |(rule, replacement)| break if result.gsub!(rule, replacement) }
  result = result.replace(/_id$/g, "")
  result = result.replace(/_/g, ' ')
  splits = result.split(' ')
  if splits.length > 1
    result = splits[0].capitalize() + ' ' + splits[1..-1].join(' ')
  else
    result = splits[0].capitalize()
  # XXX not fully implemented
  #result = result.replace(/([a-z\d]*)/gi) { |match|
  #  "#{inflections.acronyms[match] || match.downcase}"
  #}.gsub(/^\w/) { $&.upcase }

String::beginsWith = (str) -> if @match(new RegExp "^#{str}") then true else false
String::endsWith = (str) -> if @match(new RegExp "#{str}$") then true else false
String::dasherize = (reg = /_/g) ->
  if typeof reg is 'string'
    reg = new RegExp(reg, 'g')
  this.replace(reg, '-')
String::strip = String::trim

# XXX this function is a quick hack to translate TagHelper more easily. i'm pretty sure it doesn't actually ensure safety because it
# doesn't protect against unsafe string methods or concatenation (and we can't overload the + operator), but it's probably good
# enough for now
#
# Nota bene: this is a kluge of the worst kind and should be eliminated
String::html_safe = ->
  this.is_html_safe = 1
  this


Number::seconds = ->
  @ * 1000

Number::minutes = ->
  @seconds() * 60

Number::minute = Number::minutes

Number::hours = ->
  @minutes() * 60

Number::hour = Number::hours

Number::ago = ->
  new Date(new Date().valueOf() - @)

Number::from_now = ->
  new Date(new Date().valueOf() + @)

Date.COMMON_YEAR_DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

# TODO we could use some tests here
Date.is_gregorian_leap_year = (y) ->
  y % 4 is 0 and y % 100 isnt 0 or y % 400 is 0

Date::days_in_month = ->
  if @.getMonth() is 1 and Date.is_gregorian_leap_year (@.getFullYear())
    29
  else
    Date.COMMON_YEAR_DAYS_IN_MONTH[@.getMonth()]

Date::tomorrow = ->
  #new Date(@.valueOf() + 24.hours())
  new Date(@.valueOf() + 24 * 60 * 60 * 1000)

Date::yesterday = ->
  #new Date(@.valueOf() - 24.hours())
  new Date(@.valueOf() - 24 * 60 * 60 * 1000)

Date::beginning_of_day = ->
  new Date(new Date(@).setHours(0, 0, 0, 0))

Date::end_of_day = ->
  new Date(new Date(@).setHours(23, 59, 59, 999))

# incrementing and decrementing by 1 works in setMonth(-1) and setMonth(12)
Date::prev_month = ->
  d = new Date(@)
  d2 = d.beginning_of_month()
  d2.setMonth(@.getMonth() - 1)
  num_days_in_prev_month = d2.days_in_month()
  if num_days_in_prev_month < d.getDate()
    d.setDate(num_days_in_prev_month)
  d.setMonth(@.getMonth() - 1)
  d

Date::next_month = ->
  d = new Date(@)
  d2 = d.beginning_of_month()
  d2.setMonth(@.getMonth() + 1)
  num_days_in_next_month = d2.days_in_month()
  if num_days_in_next_month < d.getDate()
    d.setDate(num_days_in_next_month)
  d.setMonth(@.getMonth() + 1)
  d

Date::beginning_of_month = ->
  new Date(new Date(@).setDate(1)).beginning_of_day()

Date::end_of_month = ->
  last_date = @days_in_month()
  new Date(new Date(@).setDate(last_date)).end_of_day()

blues_strftime = require('prettydate').strftime
Date::strftime = (str) ->
  blues_strftime(@, str)
