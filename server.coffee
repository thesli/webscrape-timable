express = require "express"
fs = require "fs"
app = new express()

app.use "/img",express.static __dirname + "/img"
app.use express.bodyParser()

app.get "/event/:id?",(req,res)->
	id = req.params.id || req.query.id
	console.log req.params.id
	fs.readFile './json/ALL.json','utf-8',(err,data)->		
		events = JSON.parse(data)
		invalid = true
		for event in events
			if event.id == id
				invalid = false
				res.send event
				break
		res.send error: "event not found with id #{id}" if invalid

app.get "/event_img/:id",(req,res)->	
	res.sendfile __dirname+"/img/#{req.params.id}.jpg"

port = process.env.PORT || 80

app.listen port,->
	console.log "listening on port #{port}"