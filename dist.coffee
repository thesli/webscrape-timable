fs = require "fs"
events = require "events"
eventEmitter = new events.EventEmitter()
startRun = (url)->
  casper = require("casper").create()
  numPage = 0
  _eventList = []
  casper
    .start url , ->
      numPage = @evaluate ->
        txt = $('nobr.fs_L.bold.spec').html()
        count = /\(([^)]+)\)/.exec txt
        return Math.ceil(count[1]/30)
      console.log "#1 Total Page:#{numPage}"
    .then ->
      ct(1,numPage,casper,_eventList,url)
    .run ->
      json = JSON.stringify(_eventList,undefined ,2)
      t = url.substr(url.indexOf('=')+1)
      fs.write("json/#{t}.json",json,'w')
      console.log "startRun(#{url}) finished"
      setTimeout ->
        eventEmitter.emit('cron.done')
      ,2000

ct = (i,numPage,casper,_eventList,url)->
  casper.thenOpen "#{url}&page=#{i}",->
    console.log "#2 Proceeding #{url}&page=#{i}"
    events = @evaluate ->
      eventList = []
      $('#tnb_div0').children().each (index,box)->
        $box = $(box)
        event = {}
        tagloc = $box.find('.tnb_head.tnb_crop.tnb_opac').text()
        idRegexp = /_(.*?)_/
        event.id = idRegexp.exec(box.id)[1]
        event.title = $box.find('.tnb_tip_title').html()
        event.description = $box.find('.tnb_tip_body>p:not(.tnb_tip_title)').html()
        event.image = $box.find('.tnb_bg').attr('style').toString().substr(44,46)
        event.tag = tagloc.substr(0,tagloc.indexOf('@')-1)
        event.location = tagloc.substr(tagloc.indexOf('@')+1)
        event.date = $box.find('.tnb_foot.tnb_opac').text()
        event.isFree = $box.find('img[src="/res/img/box/tnb_acc_free_en.png"]').length
        eventList.push(event)
      return eventList
    for event in events
      imgUrl = "http://timable.com" + event.image
      console.log "Download #{imgUrl} to ./img/#{event.id}"
      @download(imgUrl,'img/'+event.id+'.jpg')
      delete event.image
    _eventList.push events
  casper.then ->
    i++
    ct(i,numPage,casper,_eventList,url) if i<numPage+1

_index = 0
eventEmitter.on 'cron.done',->
  urls = [
    "http://timable.com/time?da=2013-12-01",
    "http://timable.com/time?da=2013-11-01",
    "http://timable.com/time?da=2013-10-01",
    "http://timable.com/time?da=2013-09-01",
    "http://timable.com/time?da=2013-08-01",
    "http://timable.com/time?da=2013-07-02",
    "http://timable.com/time?da=2013-06-01",
    "http://timable.com/time?da=2013-05-01",
    "http://timable.com/time?da=2013-04-02",
    "http://timable.com/time?da=2013-03-01",
    "http://timable.com/time?da=2013-02-01",
    "http://timable.com/time?da=2013-01-02"
  ]
  startRun(urls[_index]) if _index < urls.length
  _index++

eventEmitter.emit('cron.done')