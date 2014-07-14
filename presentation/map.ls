{lists-to-obj, flatten} = require "prelude-ls"


###-- google map


###-- two stations data
stt-hdr = ["district", "stationname", "address", "n_space", "lng", "lat", "goodstationname"]
stt-two = [
	"文山區	師範大學公館校區	師大公館校區校門口(汀州路側)	42	121.537188	25.007528	師範大學公館校區"
	"大安區	捷運公館2號	羅斯福路/辛亥路(西北側)	30	121.534538	25.01476	捷運公館站(2號出口)"
]


do ## histogram per hour
	stt-perh = [
		{
			"goodstationname": "捷運公館站(2號出口)"
			"data": [591	3	152	-274	16	145	-68	-357	-337	290	-262	264	416	245	73	2	40	-378	-166	-261	-410	-231	-9	510]
		}
		{
			"goodstationname": "師範大學公館校區"
			"data": [611	117	-39	567	58	-259	-99	351	254	162	-301	-647	-558	-368	226	142	-223	-155	-116	-40	-19	25	383	-45	]
		}	
	]


	stt-max = (stt-perh.map (it, i)->  it.data.map -> Math.abs it) |> flatten |> d3.max

	# console.log stt-max

	stt-perh.map (it, i)->
		hs = {}
		hs.mgleft = 20
		hs.mgright = 30
		hs.mgtop = 30
		hs.mgbottom = 30

		hs.w = 280 - hs.mgleft - hs.mgright
		hs.h = 150 - hs.mgtop - hs.mgbottom

		x = d3.scale.linear!
			.domain [0, it.data.length]
			.range [0, hs.w]

		y = d3.scale.linear!
			.domain [-stt-max, stt-max]
			.range [hs.h, 0]

		line = d3.svg.line!
			.interpolate "basis"
			.x (it, i)-> x i
			.y (it, i)-> y it

		area = d3.svg.area!
			# .interpolate "linear"
			.interpolate "basis"
			.x (it, i)-> x i
			.y (it, i)-> y it
			.y0 (hs.h / 2)
				
				

		g = d3.select "\#stn" + (i + 1)
			.select ".stnhis"				
			.attr {
				width: hs.w + hs.mgleft + hs.mgright
				height: hs.h + hs.mgtop + hs.mgbottom
			}
			.append "g"
			.attr {
				"transform": "translate(" + hs.mgleft + "," + hs.mgtop + ")"
			}

		g
			.selectAll ".gridx"
			.data y.ticks 4
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

		# console.log ([6 to 18 by 6].map -> it -1)

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
				"y1": 10
				"y2": hs.h - 8
				"fill": "none"
				"shape-rendering": "crispEdges"
				"stroke": "orange"
				"stroke-width": 1px
			}
		
		xt
			.enter!
			.append "text"
			.text -> it + 1
			.attr {
				"x": -> (x it) - 3
				"y": hs.h + 10
				"stroke": "orange"
			}

		g
			.append "path"
			.attr {
				"d": line it.data
			}
			.style {
				"fill": "none"
				"stroke": "white"
				"stroke-width": 2px
			}





do ## heatmap

	toentry = (array)->
		c_w = 0
		c_h = 0
		
		array.map (it, i)->
			rslt = {
				"week": (c_w - 1 + 7) % 7 ### starting w/ monday as 0
				"hour": c_h
				"value": it 
			}

			if c_h is 23
				c_h := 0
				++c_w
			else 
				++c_h

			rslt

	sttw_h = [
		{
			"goodstationname": "捷運公館站(2號出口)"
			"data": toentry [	67	94	34	99	157	11	9	10	11	103	109	89	0	0	0	0	0	0	0	0	0	5	24	32	2	0	0	0	4	2	0	26	103	178	92	101	87	58	24	0	0	0	0	0	0	0	57	42	15	0	9	0	11	12	0	23	65	95	78	76	8	3	0	0	0	0	0	0	0	0	31	2	17	0	0	0	46	5	0	21	58	125	128	56	24	17	23	0	0	0	0	0	0	0	23	15	3	6	0	0	0	0	14	43	107	160	82	70	40	6	0	0	0	0	22	32	0	16	36	35	14	8	2	3	25	6	19	107	125	63	48	71	18	11	2	0	0	0	0	0	2	0	89	208	35	32	35	85	73	17	21	31	37	111	111	91	5	0	0	0	0	0	0	0	0	0	38	136]
		}
		{
			"goodstationname": "師範大學公館校區"
			"data": toentry [6	4	0	0	0	0	0	0	0	0	0	0	11	75	37	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	7	70	34	24	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	24	26	0	0	0	0	0	36	28	15	0	0	0	39	30	8	13	11	1	0	0	0	0	0	0	14	3	44	2	45	5	28	39	25	5	0	8	44	0	0	0	6	0	0	0	0	0	12	0	0	0	0	6	0	1	52	138	0	0	0	0	0	0	0	0	3	6	0	3	0	0	0	0	0	0	0	0	1	51	5	25	66	0	0	27	47	0	0	0	2	19	0	0	0	0	0	0	0	0	0	0	0	13	6	33	32	0	0	33	21	9	8	0	0]
		}	
	]

	# console.log sttw_h

	sttw_h.map (it, i)->
		hmap = {}
		hmap.mgleft = 20
		hmap.mgright = 30
		hmap.mgtop = 20
		hmap.mgbottom = 0

		hmap.w = 280 - hmap.mgleft - hmap.mgright
		hmap.h = 150 - hmap.mgtop - hmap.mgbottom

		hmap.rctmg = 2
		hmap.rctw = 9.5 - hmap.rctmg

		# console.log hmap.rctw

		g = d3.select "\#stn" + (i + 1)
			.select ".stnheat"
			.attr {
				width: hmap.w + hmap.mgleft + hmap.mgright
				height: hmap.h + hmap.mgtop + hmap.mgbottom
			}
			.append "g"
			.attr {
				"transform": "translate(" + hmap.mgleft + "," + hmap.mgtop + ")"
			}

		g
			.selectAll ".rctheat"
			.data it.data
			.enter!
			.append "rect"
			.attr {
				"x": (it, i)-> (it.hour * (hmap.rctw + hmap.rctmg))
				"y": (it, i)-> (((if it.week > 4 then 0.5 else 0) + it.week) * (hmap.rctw + hmap.rctmg))
				"width": hmap.rctw
				"height": hmap.rctw
			}
			.style {
				"fill": "orange"
				"opacity": (it, i)-> 
					# if it.hour is 11 then return 0
					(it.value / 100) + 0.1
			}









stt-two = stt-two
	.map -> 
		lists-to-obj stt-hdr, (it.split "\t")
	.filter (d, i)->
		["lat", "lng", "n_space"].map -> d[it] = +d[it]


# console.log stt-two

ggl = {}
ggl.mpw = 1300
ggl.mph = 800
ggl.mapOffset = 4000
ggl.styleName = "paper_light"

overlayGoog = new google.maps.OverlayView!

err, mapStyle <- d3.json "../mapstyle/" + ggl.styleName + ".json"

mapStyle = new google.maps.StyledMapType( mapStyle , {name: ggl.styleName})

d3.select '#map'
	.style "width" ggl.mpw + "px"
	.style "height" ggl.mph + "px"
	.style "margin" "0px"
	.style "padding" "0px"





map = new google.maps.Map(d3.select '#map' .node!, {
	zoom: 15,
	scrollwheel: false,
	navigationControl: false,
	mapTypeControl: false,
	scaleControl: false,
	draggable: false,
	center: new google.maps.LatLng(25.012476274167252, 121.53414687147142),
	mapTypeControlOptions:{
		mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
	}
})

google.maps.event.addListener(map, "bounds_changed", ->
	bounds = this.getBounds!
	northEast = bounds.getNorthEast!
	southWest = bounds.getSouthWest!
	console.log([(southWest.lng! + northEast.lng!) / 2, (southWest.lat! + northEast.lat!) / 2])

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
					# "fill": "rgb(252, 78, 42)"
					fill: "white"
					stroke: "rgb(252, 78, 42)"
					stroke-width: "5px"
				}
				.transition!
				.attr {
					"r": -> 50
				}
				.transition!
				.attr {
					"r": -> 10
				}



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
					"r": -> 150
					# zoom-level[20 - current_zoom] / 1000000 * 3
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
				# tmpidx = null
				it
					.attr {
						"d": -> "M" + (it.join ",") + "Z"
					}
					.style {
						"stroke": "white"
						"stroke-width": 2
						# "fill": "none"
						"fill": "orange"
						# "fill": (it,i)-> 
	### # should be the same order for all of it					
							# if tmpidx is null 
	# 							stations[i].nobike.map (st, j)-> 
	# 								if (it.hour is ggl.ch and it.week is cw)
	# 									tmpidx := j

	# 						color stations[i].nobike[tmpidx].value
						# "opacity": 0.6
						"opacity": 0.1
					}


			pv = gv.selectAll "path"
				.data voronoi stations

			pv
				.enter!
				.append "path"
				.call setvoronoi
				.attr {
					"id": (it, i)-> "path-" + i
					"class": "vcircle"
					"clip-path": (it, i)-> "url(\#clip-" + i + ")"
				}
				.on "mouseenter", ->
							d3.select this
								.transition!
								.style {
									"opacity": 0.8
								}
				.on "mouseleave" ->
						d3.select this
							.transition!
							.style {
								"opacity": 0.1
							}

			pv
				.transition!
				.call setvoronoi

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



addOverlay stt-two



