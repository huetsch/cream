fs = require 'fs'

bump_version_number = (pkg) ->
  version_nums = pkg['version'].split('.').map((x) -> Number x)
  last_num = version_nums[version_nums.length - 1]
  bumped_last_num = last_num + 1
  new_version_nums = version_nums[0...-1].concat([bumped_last_num])
  new_version_str = new_version_nums.join('.')
  pkg['version'] = new_version_str

write_package = (pkg) ->
  str = JSON.stringify pkg, null, 4
  fs.writeFileSync 'package.json', str

pkg = JSON.parse(new String(fs.readFileSync 'package.json').valueOf())

bump_version_number pkg
write_package pkg
