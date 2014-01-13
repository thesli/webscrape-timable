express = require "express"
fs = require "fs"
app = new express()

app.use "/img",express.static __dirname + "/img"
app.use express.bodyParser()

app.get "/event/:id?",(req,res)->
	id = req.params.id || req.query.id
	fs.readFile './json/ALL.json','utf-8',(err,data)->		
		events = JSON.parse(data)
		valid = false
		for event in events
			if event.id == id
				res.send event
				break
		res.send error: "event not found with id #{id}" if not valid

app.listen 5050