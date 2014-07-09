{each, lists-to-obj} = require "prelude-ls"

# svg = d3.select ".svgctnr"
# 	.append "svg"
# 	.attr {
# 		"width": 700px
# 		"height": 800px
# 		# "width": 100%
# 		# "height": 100%
# 	}
# 	# .style {
# 	# 	"position": "fixed"
# 	# 	"left": 700
# 	# 	"top": 250
# 	# }
# 	.append "g"


###-- google map


###-- two stations data
stt-hdr = ["district", "stationname", "address", "n_space", "lng", "lat", "goodstationname"]
stt-two = [
	# "文山區	師範大學公館校區	師大公館校區校門口(汀州路側)	42	121.537188	25.007528	師範大學公館校區"
	# "大安區	捷運公館2號	羅斯福路/辛亥路(西北側)	30	121.534538	25.01476	捷運公館站(2號出口)"
	"中正區	臺北市客家文化主題公園	師大路/汀州路交叉口	32	121.525322	25.02043	臺北市客家文化主題公園"
	"大安區	捷運台電大樓站(2號出口)	羅斯福路/辛亥路交叉口(古亭國小前)	40	121.528552	25.020547	捷運台電大樓站(2號出口)"
]


# 591	3	152	-274	16	145	-68	-357	-337	290	-262	264	416	245	73	2	40	-378	-166	-261	-410	-231	-9	510
# 611	117	-39	567	58	-259	-99	351	254	162	-301	-647	-558	-368	226	142	-223	-155	-116	-40	-19	25	383	-45

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

# d3.selectAll '#map'
# 	.append "div"
# 	.attr {
# 		"class": "hello"
# 	}
# 	.html "hello ddmewi diew"
map = new google.maps.Map(d3.select '#map' .node!, {
	zoom: 15,
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
			.attr "width" ggl.mapOffset * 2
			.attr "height" ggl.mapOffset * 2
			.style "position" "absolute"
			.style "top" -1 * ggl.mapOffset
			.style "left" -1 * ggl.mapOffset

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



