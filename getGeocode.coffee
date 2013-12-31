fs = require 'fs'
events = require 'events'
eventEmitter = new events.EventEmitter()
geocoder = require 'geocoder'
js = []
fs.readFile('./json/ALL.json','utf-8',(err,data)->
  js = JSON.parse(data)
  setTimeout ->
    eventEmitter.emit 'nextGeocode'
  ,2000
)
_index = 0

eventEmitter.on 'nextGeocode',->
  geocoder.geocode js[_index].location,(err,data)->
    console.log js[_index].location
    if err
      eventEmitter.emit 'nextGeocode'
      return 0
    if data.status == "OK"
      js[_index].lat = data.results[0].geometry.location.lat
      js[_index].lng = data.results[0].geometry.location.lng
      console.log js[_index].lat
      console.log js[_index].lng
    _index++
    setTimeout ->
      eventEmitter.emit 'nextGeocode' if _index < js.length
      fs.writeFile("json/ALL_geocoded.json",JSON.stringify(js,undefined,2)) if _index == js.length
    ,2000
