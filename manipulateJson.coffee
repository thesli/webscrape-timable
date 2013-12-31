fs = require "fs"
_ = require "underscore"
bigData = []
fileList = [
  "2013-01-02.json",
  "2013-02-01.json",
  "2013-03-01.json",
  "2013-04-02.json",
  "2013-05-01.json",
  "2013-06-01.json",
  "2013-07-02.json",
  "2013-08-01.json",
  "2013-09-01.json",
  "2013-10-01.json",
  "2013-11-01.json",
  "2013-12-01.json"
]
for f in fileList
  fs.readFile(__dirname+"/json/#{f}",'utf-8',(err,data)->
    data = JSON.parse(data)
    tmp = []
    for d in data
      for x in d
        tmp.push x
    for t in tmp
      bigData.push t
    fs.writeFile 'bigData.json',JSON.stringify(bigData,undefined,2)
  )
ids = []
fs.readFile('./bigData.json','utf-8',(err,data)->
  json = JSON.parse(data)
  for j in json
    ids.push j.id
  ids = _.uniq ids
  output = []
  for id in ids
    uniqueRecord = _.find json,(record)->
      return record.id == id
    output.push uniqueRecord
  setTimeout ->
    console.log output.length
    fs.writeFile(__dirname + '/json/ALL.json',JSON.stringify(output,undefined,2))
  ,2000
)