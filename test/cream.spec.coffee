require '../cream.coffee'

describe 'Cream', ->
  it 'Object.delete(a: 1, "a") == 1', ->
    expect(Object.delete(a: 1, "a")).toEqual 1
