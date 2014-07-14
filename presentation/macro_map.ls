{each, lists-to-obj, take, drop, reverse, first, flatten} = require "prelude-ls"






err, startJson <- d3.json "../week_hour_total/station_start.json"

enddate = new Date "Fri May 09 2014 08:22:54 GMT+0800 (CST)"
for at of startJson
	startJson[at] = (enddate - (new Date startJson[at])) / 1000 / 60 

console.log startJson


# ggl = {}

# ggl.mpw = 800
# ggl.mph = 750
# ggl.mapOffset = 4000
# ggl.styleName = "paper_light"

# overlayGoog = new google.maps.OverlayView!

# err, mapStyle <- d3.json "../mapstyle/" + ggl.styleName + ".json"

# # console.log "helllo"

# mapStyle = new google.maps.StyledMapType( mapStyle , {name: ggl.styleName})

# d3.select '#macmap'
# 	.style "width" ggl.mpw + "px"
# 	.style "height" ggl.mph + "px"
# 	.style "margin" "0px"
# 	.style "padding" "0px"


# map = new google.maps.Map(d3.select '#macmap' .node!, {
# 	zoom: 12,
# 	# scrollwheel: false,
# 	navigationControl: false,
# 	# mapTypeControl: false,
# 	# scaleControl: false,
# 	# draggable: false,
# 	# disableDefaultUI: true,
# 	center: new google.maps.LatLng(25.009985401778902, 121.53998335828783),
# 	mapTypeControlOptions:{
# 		mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
# 	}
# })

# google.maps.event.addListener(map, "bounds_changed", ->
# 	bounds = this.getBounds!
# 	northEast = bounds.getNorthEast!
# 	southWest = bounds.getSouthWest!
# 	console.log([(southWest.lng! + northEast.lng!) / 2, (southWest.lat! + northEast.lat!) / 2])

# )


# map.mapTypes.set('map_style', mapStyle)
# map.setMapTypeId('map_style')


# # addOverlay = (stations)->
# # 	overlayGoog.onAdd = -> 

# # 		layer = d3.select(this.getPanes!.overlayMouseTarget).append "div"

# # 		svg = layer.append "svg"

# # 		gv = svg.append "g" .attr "class" "gv"

# # 		gPrints = svg.append "g" .attr "class" "gPrints"


# # 		svg
# # 			.attr {
# # 				"width": ggl.mapOffset * 2
# # 				"height": ggl.mapOffset * 2
# # 			}
# # 			.style {
# # 				"position": "absolute"
# # 				"top": -1 * ggl.mapOffset
# # 				"left": -1 * ggl.mapOffset
# # 			}

# # 		overlayGoog.draw = -> 
# # 			overlayProjection = this.getProjection!

# # 			googleMapProjection = (coordinates)->

# # 				googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
# # 				pixelCoordinates = overlayProjection.fromLatLngToDivPixel googleCoordinates
# # 				[pixelCoordinates.x + ggl.mapOffset, pixelCoordinates.y + ggl.mapOffset]

# # 			projecting = d3.geo.path!projection googleMapProjection

# # 			stations.filter -> 
# # 				coor = googleMapProjection [it.lng, it.lat]
# # 				it.coorx = coor[0]			
# # 				it.coory = coor[1]
# # 				true

# # 			current_zoom = this.map.zoom

# # 			setcircle = ->
# # 				it.attr {
# # 					"cx": -> it.coorx
# # 					"cy": -> it.coory
# # 					"r": -> 0
# # 					"class": "stationdots"
# # 				}
# # 				.style {
# # 					fill: "white"
# # 					stroke: "rgb(252, 78, 42)"
# # 					stroke-width: "5px"
# # 				}
# # 				.transition!
# # 				.attr {
# # 					"r": -> 50
# # 				}
# # 				.transition!
# # 				.attr {
# # 					"r": -> 10
# # 				}



# # 			settext = ->
# # 				it.attr {
# # 					"x": (it,i)-> it.coorx  + (if i is 0 then -400 else 50)
# # 					"y": -> it.coory - 100
# # 				}
# # 				.style {
# # 					# "opacity": 1
# # 					# zoom-test current_zoom
# # 					"font-size": "30px"
# # 				}

# # 			setclipPath = ->
# # 				it.attr {
# # 					"cx": -> it.coorx
# # 					"cy": -> it.coory
# # 					"r": -> 150
# # 					# zoom-level[20 - current_zoom] / 1000000 * 3
# # 				}


# # 			# t = gPrints.selectAll ".stname"
# # 			# 	.data stations
# # 			# 	.enter!
# # 			# 	.append "g"

# # 			# t				
# # 			# 	.attr {
# # 			# 		"class": "stname"
# # 			# 	}
# # 			# 	.text -> it.goodstationname
# # 			# 	.call settext



# # 			# 	# .append "rect"
# # 			# 	# .attr {
# # 			# 	# 	"height": 200px
# # 			# 	# 	"width": 100px
# # 			# 	# }
# # 			# 	# .style {
# # 			# 	# 	"fill": "white"
# # 			# 	# }
# # 			# 	.append "text"
# # 			# 	.attr {
# # 			# 		"class": "stname"
# # 			# 	}
# # 			# 	.text -> it.goodstationname
# # 			# 	# ~~(Math.random! * 10)
# # 			# 	# 
# # 			# 	.call settext

# # 			# t
# # 			# 	.call settext

# # 			cp = gPrints.selectAll ".clipPath"
# # 				.data stations

# # 			cp
# # 				.selectAll "circle"
# # 				.call setclipPath
			
# # 			cp
# # 				.enter!
# # 				.append "clipPath"
# # 				.attr {
# # 					"id": (it, i)-> "clip-" + i
# # 					"class": "clipPath"
# # 				}
# # 				.append "circle"
# # 				.call setclipPath

# # 			b = (ggl.mapOffset / 2) # so that wihtouht screen get calculated as well
# # 			voronoi = d3.geom.voronoi!
# # 				.clipExtent [[ggl.mapOffset - b , 0 + ggl.mapOffset - b], [ggl.mpw + ggl.mapOffset + b, ggl.mph + ggl.mapOffset + b]]
# # 				.x -> it.coorx
# # 				.y -> it.coory

# # 			setvoronoi = ->
# # 				# tmpidx = null
# # 				it
# # 					.attr {
# # 						"d": -> "M" + (it.join ",") + "Z"
# # 					}
# # 					.style {
# # 						"stroke": "white"
# # 						"stroke-width": 2
# # 						# "fill": "none"
# # 						"fill": "orange"
# # 						# "fill": (it,i)-> 
# # 	### # should be the same order for all of it					
# # 							# if tmpidx is null 
# # 	# 							stations[i].nobike.map (st, j)-> 
# # 	# 								if (it.hour is ggl.ch and it.week is cw)
# # 	# 									tmpidx := j

# # 	# 						color stations[i].nobike[tmpidx].value
# # 						# "opacity": 0.6
# # 						"opacity": 0.1
# # 					}


# # 			pv = gv.selectAll "path"
# # 				.data voronoi stations

# # 			pv
# # 				.enter!
# # 				.append "path"
# # 				.call setvoronoi
# # 				.attr {
# # 					"id": (it, i)-> "path-" + i
# # 					"class": "vcircle"
# # 					"clip-path": (it, i)-> "url(\#clip-" + i + ")"
# # 				}
# # 				.on "mouseenter", ->
# # 							d3.select this
# # 								.transition!
# # 								.style {
# # 									"opacity": 0.8
# # 								}
# # 				.on "mouseleave" ->
# # 						d3.select this
# # 							.transition!
# # 							.style {
# # 								"opacity": 0.1
# # 							}

# # 			pv
# # 				.transition!
# # 				.call setvoronoi

# # 			c = gPrints.selectAll ".stationdots"
# # 				.data stations

# # 			c
# # 				.transition!
# # 				.call setcircle
			
# # 			c
# # 				.enter!
# # 				.append "circle"
# # 				.call setcircle

# # 	overlayGoog.setMap map



# # addOverlay stt-two



