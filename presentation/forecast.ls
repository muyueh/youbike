{lists-to-obj, flatten, slice} = require "prelude-ls"

#TODO: monday as 0 
#DONE: value need to devide by basis; occurance per type

ggl = {}

ggl.mpw = 1280
# ggl.mpw = 800
ggl.mph = 750
ggl.mapOffset = 4000
ggl.styleName = "paper_light"

ggl.hrls = [1 to 24]
ggl.wkls = ["ㄧ" "二" "三" "四" "五" "六" "日"]

ggl.flls = ["neg" "pos" "sum"]
ggl.stationsInfo = {
	# stationname: {}
}
ggl.whdata = {
	# "neg": {
		# "stationname": {}
	# }
}

ggl.crrview = "sum"
# ggl.crrview = "pos"
ggl.crrstation = "捷運公館站(2號出口)"
ggl.crrweek = 1 #start with monday
ggl.crrhour = 0

ggl.colorscl = null

ggl.auto = true

ggl.zoomlevel = {
	20: 1128.497220
	19: 2256.994440
	18: 4513.988880
	17: 9027.977761
	16: 18055.955520
	15: 36111.911040
	14: 72223.822090
	13: 144447.644200
	12: 288895.288400
	11: 577790.576700
	10: 1155581.153000
	9: 2311162.307000
	8: 4622324.614000
	7: 9244649.227000
	6: 18489298.450000
	5: 36978596.910000
	4: 73957193.820000
	3: 147914387.600000
	2: 295828775.300000
	1: 591657550.500000
}


# {
	# w_h: times
	# 0_0: 2
# }


ggl.colorSet = {
	"neg": { schm: "GnBu", dm: [0, -20] }
	"pos": { schm: "YlOrRd", dm: [0, 20] }
	"sum": { schm: "RdYlBu", dm: [10, -10] }
}


ggl.stnBind = {
	".stn0": "捷運公館站(2號出口)"
	".stn1": "師範大學公館校區"
	".stn2": "八德市場"
	".stn3": "中崙高中"
	".stn4": "捷運大安森林公園站"
}



# TODO use linear instead of quantize
setColorScl = ->
	ggl.colorscl := d3.scale.quantize!domain ggl.colorSet[ggl.crrview]["dm"] .range colorbrewer[ggl.colorSet[ggl.crrview]["schm"]][5]

setColorScl!


whtick = ->
	++ggl.crrhour

	if ggl.crrhour >= 24
		ggl.crrhour := 0
		++ggl.crrweek

	if ggl.crrweek >= 7
		ggl.crrweek := 0
		ggl.crrhour := 0

	setVCircleColor!
	setWH!
	setKPI!
	# console.log ggl.crrweek + ":" + ggl.crrhour


setInterval (-> whtick!), 1000
# setTimeout (-> whtick!), 1000

ggl.weekTable = lists-to-obj [0 to 6], ["日" "ㄧ" "二" "三" "四" "五" "六"]

# w = ((it.week - 1) + 7) % 7




setKPI = ->
	wh = ggl.crrweek + "_" + ggl.crrhour

	setHGHM = ->
		d3.selectAll ".hghm"
			.style {
				"display": "none"
			}

		d3.selectAll ".hghm-" + wh
			.style {
				"display": "inline"
			}

	setHGHM!

	d3.selectAll ".stn"
		.each (it, i)->
			that = this
			# if (d3.select this .attr "id") is not null 
			stName = ((d3.select this .attr "id").split "ctn")[1]

			# console.log d3.select this
			# console.log stName
			ggl.flls.map (fl)->

			# 	console.log fl
				d3.select that
					.selectAll(".kpi" + fl)
					.text ~~ggl.whdata[fl][stName][wh]
		

setWH = ->
	d3.selectAll ".ttlweek"
		.text "星期" + ggl.weekTable[ggl.crrweek] + " "

	d3.selectAll ".ttlhour"
		.text (if (ggl.crrhour + 1) < 10 then "0" else "") + (ggl.crrhour + 1) + ":00"

setVCircleColor = ->

	d3.selectAll ".vcircle"
		.transition!
		.duration 1000
		.style {
			"fill": -> 
				nm = it.point.goodstationname
				w_h = ggl.crrweek + "_" + ggl.crrhour
				ggl.colorscl ggl.whdata[ggl.crrview][nm][w_h]
		}


### -- heatmap

hhdr = flatten (
	[0 to 6].map (w)-> 
		[0 to 23].map (h)-> 
			{
				"week": w
				"hour": h
				"wh": w + "_" + h
			}
	)


hmap = {}
hmap.mgleft = 30
hmap.mgright = 5
hmap.mgtop = 10
hmap.mgbottom = 10

hmap.w = 330 - hmap.mgleft - hmap.mgright
hmap.h = 100 - hmap.mgtop - hmap.mgbottom

hmap.rctmg = 3
hmap.rctw = 12 - hmap.rctmg

###---

hs = {}
hs.mgleft = 5
hs.mgright = 5
hs.mgtop = 10
hs.mgbottom = 15

# hs.w = 330 - hs.mgleft - hs.mgright
hs.w = 130 - hs.mgleft - hs.mgright
hs.h = 100 - hs.mgtop - hs.mgbottom



initStInfo = (containerClass, stName)->

	d3.selectAll containerClass
		.attr {
			"id": "ctn" + stName
		}

	initKPI = ->
		ctnkpi = d3.selectAll containerClass
			.selectAll ".kpi"


		ctnkpi.append "div"
			.text stName
			.attr {
				# "class": "inl stName"
			}

		scr = ctnkpi.append "div"

		scr.append "div"
			.text "10" 
			.attr {
				"class": "kpisum"
			}
			.style {
				"font-size": "40px"
				"margin-left": "75px"
				"margin-top": "10px"
			}

		scr.append "div"
			.text "="
			.attr {
				"class": "inl"
			}
			.style {
				"margin-left": "40px"
			}

		scr.append "div"
			.text "+20"
			.attr {
				"class": "inl kpipos"
			}
			.style {
				"margin-left": "10px"
				# "color": "rgb(171, 217, 233)"
			}

		scr.append "div"
			.text "-10"
			.attr {
				"class": "inl kpineg"
			}
			.style {
				"margin-left": "10px"
				# "color": "rgb(215, 25, 28)"
			}

	initHeat = ->
		g = d3.selectAll containerClass
			.selectAll ".heatmap"
			.attr {
				width: hmap.w + hmap.mgleft + hmap.mgright
				height: hmap.h + hmap.mgtop + hmap.mgbottom
			}
			.append "g"
			.attr {
				"transform": "translate(" + hmap.mgleft + "," + hmap.mgtop + ")"
			}

		g
			.selectAll ".hghm"
			.data hhdr
			.enter!
			.append "rect"
			.attr {
				"x": (it, i) -> (it.hour * (hmap.rctw + hmap.rctmg)) - (hmap.rctmg)
				"y": (it, i) -> 
					w = ((it.week - 1) + 7) % 7 # start with monday as 0 sunday as 1
					(((if w > 4 then 0.5 else 0) + w) * (hmap.rctw + hmap.rctmg))  - (hmap.rctmg)
				"class": (it, i) -> "hghm hghm-" + it.wh
				"width": hmap.rctw + hmap.rctmg * 2
				"height": hmap.rctw + hmap.rctmg * 2
				"rx": 2
				"ry": 2
			}
			.style {
				"fill": "white"
				"display": "none"
			}

		g
			.selectAll ".rctheat"
			.data hhdr
			.enter!
			.append "rect"
			.attr {
				"x": (it, i) -> (it.hour * (hmap.rctw + hmap.rctmg))
				"y": (it, i) -> 
					w = ((it.week - 1) + 7) % 7 # start with monday as 0 sunday as 1
					(((if w > 4 then 0.5 else 0) + w) * (hmap.rctw + hmap.rctmg))
				"class": (it, i) -> "rctheat hm-" + it.wh
				"width": hmap.rctw
				"height": hmap.rctw
			}
			.style {
				"fill": (it, i) -> ggl.colorscl ggl.whdata[ggl.crrview][stName][it.wh]
			}

	lsstn = d3.entries ggl.whdata["sum"][stName]
		.filter -> it.key is not "stations"

	cllsstn = slice 23, 45, lsstn

	initHist = ->
		g = d3.selectAll containerClass
			.selectAll ".histchart"
			.attr {
				width: hs.w + hs.mgleft + hs.mgright
				height: hs.h + hs.mgtop + hs.mgbottom
			}
			.append "g"
			.attr {
				"transform": "translate(" + hs.mgleft + "," + hs.mgtop + ")"
			}

		g.append "defs"
			.append "clipPath"
			.attr {
				"id": "clip"
			}
			.append "rect"
			.attr {
				width: hs.w
				height: hs.h
			}

		x = d3.scale.linear!
			.domain [1, cllsstn.length -  2]
			.range [0, hs.w]

		histLimit = 10

		y = d3.scale.linear!
			.domain [-histLimit, histLimit]
			.range [hs.h, 0]

		line = d3.svg.line!
			.interpolate "basis"
			.x (it, i)-> x i
			.y (it, i)-> y it.value

		## horizontal grid line
		g
			.selectAll ".gridx"
			.data y.ticks 3
			.enter!
			.append "line"
			.attr {
				"clas": "gridx"
				"x1": 0
				"x2": hs.w
				"y1": -> y it
				"y2": -> y it
				"fill": "none"
				"shape-rendering": "crispEdges"
				"stroke": "orange"
				"stroke-width": 1px
			}

		## vertical grid line

		xt = g
			.selectAll ".gridy"
			.data ([6 to 18 by 6].map -> (it - 1))

		xt
			.enter!
			.append "line"
			.attr {
				"clas": "gridy"
				"x1": -> x it
				"x2": -> x it
				"y1": 0
				"y2": hs.h
				"fill": "none"
				"shape-rendering": "crispEdges"
				"stroke": "orange"
				"stroke-width": 1px
			}
		
		xt
			.enter!
			.append "text"
			.text -> "+" + (it + 1) + "h"
			.attr {
				"x": -> (x it) - 5
				"y": hs.h + 14
				"stroke": "orange"
			}
			.style {
				"font-size": "12px"
			}

		g.append "g"
			.attr {
				"clip-path": "url(\#clip)"
			}
			.selectAll "path"
			.data [cllsstn]
			.enter!
			.append "path"
			.attr {
				"d": -> line it
				"class": "hist"
			}
			.style {
				"fill": "none"
				"stroke": "white"
				"stroke-width": 2px
			}


		idx = 0
		tickHist = ->
			++idx

			cllsstn.push lsstn[45 + idx]

			d3.selectAll containerClass
				.selectAll ".hist"
				.attr {
					"d": -> line it
					"transform": null
				}
				.transition!
				.duration 1000
				.ease "linear"
				.attr {
					"transform": "translate(" + (x 0) + ",0)"
				}
				.each "end", tickHist

			cllsstn.shift!


		tickHist!

	initKPI!
	initHist!
	initHeat!




initDiv = ->
	appndDiv = d3.selectAll ".lsstn"
		.selectAll ".stn"
		.data [0 to 1]
		# .data [0 to 5]
		.enter!
		.append "div"
		.attr {
			"class": (it, i)-> "panel stn stn" + i
		}

	appndDiv
		.append "div"
		.attr {
			"class": "kpi"
		}

	appndDiv
		.append "div"
		.attr {
			"class": "ctnhist"
		}
		.append "svg"
		.attr {
			"class": "histchart"
		}

	appndDiv
		.append "div"
		.attr {
			"class": "ctnheatmap"
		}
		.append "svg"
		.attr {
			"class": "heatmap"
		}


err, startJson <- d3.json "../week_hour_total/station_start.json"

enddate = new Date "Fri May 09 2014 08:22:54 GMT+0800 (CST)"
for at of startJson
	startJson[at] = (enddate - (new Date startJson[at])) / 1000 / 60 / 60 / 7 / 24

# console.log startJson

#how many time w_h occurs 



err, infoTsv <- d3.tsv "../stations.tsv"

infoTsv.filter (d, i)->
	["lat" "lng" "n_space"].map -> d[it] = +d[it]
	ggl.stationsInfo[d.goodstationname] := d
	true

# console.log ggl.stationsInfo

flwait = ggl.flls.length
ggl.flls.map (flname)->
	err, whdata <- d3.tsv "../move_week _hour/" + flname + ".tsv"
	--flwait
	whwait = whdata.length

	ggl.whdata[flname] := {}
	whdata.map (stdata)->
		--whwait
		for dt of stdata
			if dt is not "stations" then stdata[dt] = +stdata[dt] / startJson[stdata.stations]
		ggl.whdata[flname][stdata.stations] := stdata

		if flwait is 0 and whwait is 0 
				#console.log ggl.whdata[ggl.crrview][ggl.crrstation]

				initDiv!
				initStInfo ".stn0", "捷運公館站(2號出口)"
				initStInfo ".stn1", "師範大學公館校區"
				# initStInfo ".stn2", "八德市場"
				# initStInfo ".stn3", "中崙高中"
				# initStInfo ".stn4", "捷運大安森林公園站"

# console.log ggl.whdata


# ##--- map

overlayGoog = new google.maps.OverlayView!

map = null

err, mapStyle <- d3.json "../mapstyle/" + ggl.styleName + ".json"

mapStyle = new google.maps.StyledMapType( mapStyle , {name: ggl.styleName})

d3.select '#map'
	.style "width" ggl.mpw + "px"
	.style "height" ggl.mph + "px"
	.style "margin" "0px"
	.style "padding" "0px"



map := new google.maps.Map(d3.select '#map' .node!, {
	zoom: 15,
	# scrollwheel: false,
	# navigationControl: false,
	# mapTypeControl: false,
	# scaleControl: false,
	# draggable: false,
	disableDefaultUI: true,
	center: new google.maps.LatLng(25.009985401778902, 121.53998335828783),
	mapTypeControlOptions:{
		mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
	}
})

google.maps.event.addListener(map, "bounds_changed", ->
	bounds = this.getBounds!
	northEast = bounds.getNorthEast!
	southWest = bounds.getSouthWest!
	# console.log([(southWest.lng! + northEast.lng!) / 2, (southWest.lat! + northEast.lat!) / 2])
	setVCircleColor!
)


map.mapTypes.set('map_style', mapStyle)
map.setMapTypeId('map_style')


addOverlay = (stations)->
	overlayGoog.onAdd = -> 

		layer = d3.select(this.getPanes!.overlayMouseTarget).append "div"

		svg = layer.append "svg"

		gv = svg.append "g" .attr "class" "gv"

		gPrints = svg.append "g" .attr "class" "gPrints"


		svg
			.attr {
				"width": ggl.mapOffset * 2
				"height": ggl.mapOffset * 2
			}
			.style {
				"position": "absolute"
				"top": -1 * ggl.mapOffset
				"left": -1 * ggl.mapOffset
			}

		overlayGoog.draw = -> 
			overlayProjection = this.getProjection!

			googleMapProjection = (coordinates)->

				googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
				pixelCoordinates = overlayProjection.fromLatLngToDivPixel googleCoordinates
				[pixelCoordinates.x + ggl.mapOffset, pixelCoordinates.y + ggl.mapOffset]

			projecting = d3.geo.path!projection googleMapProjection

			stations.filter -> 
				coor = googleMapProjection [it.lng, it.lat]
				it.coorx = coor[0]			
				it.coory = coor[1]
				true

			current_zoom = this.map.zoom

			setcircle = ->
				it.attr {
					"cx": -> it.coorx
					"cy": -> it.coory
					"r": -> 0
					"class": "stationdots"
				}
				.style {
					fill: "white"
					stroke: "rgb(252, 78, 42)"
					stroke-width: "5px"
				}
				# .transition!
				# .attr {
				# 	"r": -> 50
				# }
				# .transition!
				# .attr {
				# 	"r": -> 10
				# }



			settext = ->
				it.attr {
					"x": (it,i)-> it.coorx  + (if i is 0 then -400 else 50)
					"y": -> it.coory - 100
				}
				.style {
					# "opacity": 1
					# zoom-test current_zoom
					"font-size": "30px"
				}

			setclipPath = ->
				it.attr {
					"cx": -> it.coorx
					"cy": -> it.coory
					"r": ggl.zoomlevel[20 - current_zoom] / 1000000 * 3
				}


			# t = gPrints.selectAll ".stname"
			# 	.data stations
			# 	.enter!
			# 	.append "g"

			# t				
			# 	.attr {
			# 		"class": "stname"
			# 	}
			# 	.text -> it.goodstationname
			# 	.call settext



			# 	# .append "rect"
			# 	# .attr {
			# 	# 	"height": 200px
			# 	# 	"width": 100px
			# 	# }
			# 	# .style {
			# 	# 	"fill": "white"
			# 	# }
			# 	.append "text"
			# 	.attr {
			# 		"class": "stname"
			# 	}
			# 	.text -> it.goodstationname
			# 	# ~~(Math.random! * 10)
			# 	# 
			# 	.call settext

			# t
			# 	.call settext

			cp = gPrints.selectAll ".clipPath"
				.data stations

			cp
				.selectAll "circle"
				.call setclipPath
			
			cp
				.enter!
				.append "clipPath"
				.attr {
					"id": (it, i)-> "clip-" + i
					"class": "clipPath"
				}
				.append "circle"
				.call setclipPath

			b = (ggl.mapOffset / 2) # so that wihtouht screen get calculated as well
			voronoi = d3.geom.voronoi!
				.clipExtent [[ggl.mapOffset - b , 0 + ggl.mapOffset - b], [ggl.mpw + ggl.mapOffset + b, ggl.mph + ggl.mapOffset + b]]
				.x -> it.coorx
				.y -> it.coory

			setvoronoi = ->
				it
					.attr {
						"d": -> "M" + (it.join ",") + "Z"
						# if it.length > 0 then "M" + (it.join ",") + "Z" else null
							# 
					}
					.style {
						"stroke": "white"
						"stroke-width": 2
						"fill": "none"
						# "fill": "orange"
						# "opacity": 0.6
						# "opacity": 0.1
						"opacity": 0.8
					}


			pv = gv.selectAll "path"
				.data voronoi stations

			pv
				.enter!
				.append "path"
				.call setvoronoi
				.attr {
					"id": (it, i)-> "path-" + i
					"class": (it, i)-> "vcircle" + " pathnm-" + it.goodstationname
					"clip-path": (it, i)-> "url(\#clip-" + i + ")"
				}
				# .on "mouseenter", ->
				# 			d3.select this
				# 				.transition!
				# 				.style {
				# 					"opacity": 0.8
				# 				}
				# .on "mouseleave" ->
				# 		d3.select this
				# 			.transition!
				# 			.style {
				# 				"opacity": 0.1
				# 			}

			pv
				# .transition!
				.call setvoronoi

			pv
				.exit!
				.remove!

			c = gPrints.selectAll ".stationdots"
				.data stations

			c
				.transition!
				.call setcircle
			
			c
				.enter!
				.append "circle"
				.call setcircle

	overlayGoog.setMap map

addOverlay infoTsv