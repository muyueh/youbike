{each} = require "prelude-ls"

w = 1280
h = 700
mapOffset = 4000
styleName = "subtle"
# "paper"

# argegno.json
# bently.json
# monochrome.json
# paper.json
# retro_no_label.json
# retro.json
# subtle.json
# turquoise.json


zoom-level = {
	20 : 1128.497220
	19 : 2256.994440
	18 : 4513.988880
	17 : 9027.977761
	16 : 18055.955520
	15 : 36111.911040
	14 : 72223.822090
	13 : 144447.644200
	12 : 288895.288400
	11 : 577790.576700
	10 : 1155581.153000
	9  : 2311162.307000
	8  : 4622324.614000
	7  : 9244649.227000
	6  : 18489298.450000
	5  : 36978596.910000
	4  : 73957193.820000
	3  : 147914387.600000
	2  : 295828775.300000
	1  : 591657550.500000
}


colorscheme = "RdYlGn" # ["RdPu","PuBu","YlOrRd","YlOrRd","RdYlGn","RdYlBu","YlGn","YlGnBu","GnBu","BuGn","PuBuGn","BuPu","RdPu","PuRd","Paired","Greys","Reds","PiYG","PRGn","BrBG","PuOr"]

# RdYlBu
#YlOrRd
 # RdYlBu


flash = -> 
	d3.selectAll ".vcircle"
		.transition!
		.delay (d, i)-> i * 5
		.style {
			"fill": -> colorbrewer[colorscheme]["3"][~~(Math.random! * 3)]
			# "rgb(255, 120, 0)"
		}


setInterval (-> flash!), 3000

overlayGoog = new google.maps.OverlayView!

err, mapStyle <- d3.json "./mapstyle/" + styleName + ".json"
	
mapStyle = new google.maps.StyledMapType( mapStyle , {name: styleName});


d3.select '#map'	
	.style "width" w + "px"
	.style "height" h + "px"
	.style "margin" "0px"
	.style "padding" "0px"

map = new google.maps.Map(d3.select '#map' .node!, {
	zoom: 13,
	center: new google.maps.LatLng(25.043897602152036, 121.5321110748291),
	mapTypeControlOptions:{
		mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
	}
});


zoom-test = (zoom)-> if zoom >= 15 then 1 else 0

zoom-text = (zoom)->

	d3.select ".gPrints" 
		.selectAll "text"
		.transition!
		.style {
			"opacity": zoom-test zoom 
		}



	

google.maps.event.addListener(map, "bounds_changed", ->
	bounds = this.getBounds!
	northEast = bounds.getNorthEast!
	southWest = bounds.getSouthWest!

	# console.log northEast + " " + southWest

	# lngDim.filterRange([southWest.lng!, northEast.lng!])
	# latDim.filterRange([southWest.lat!, northEast.lat!])

	# updatePhoto!

	# dc.redrawAll!

	# console.log this
	zoom-text this.zoom
	

)

map.mapTypes.set('map_style', mapStyle)
map.setMapTypeId('map_style')


err, stationsTsv <- d3.tsv "./stations.tsv"

stationsTsv.filter (d, i)->
	["lat", "lng", "n_space"].map -> 
		d[it] = +d[it]
	true

# console.log stationsTsv



overlayGoog.onAdd = -> 
	layer = d3.select(this.getPanes!.overlayLayer).append "div" .attr "class" "svgOverlay"
	svg = layer.append "svg"

	gPrints = svg.append "g" .attr "class" "gPrints"

	svg
		.attr "width" mapOffset * 2
		.attr "height" mapOffset * 2
		.style "position" "absolute"
		.style "top" -1 * mapOffset
		.style "left" -1 * mapOffset


	gv = svg.append "g"
		.attr "class" "gv"

	overlayGoog.draw = -> 
		overlayProjection = this.getProjection!

		googleMapProjection = (coordinates)->

			googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
			pixelCoordinates = overlayProjection.fromLatLngToDivPixel googleCoordinates
			[pixelCoordinates.x + mapOffset, pixelCoordinates.y + mapOffset]

		projecting = d3.geo.path!projection googleMapProjection

		stationsTsv.filter -> 
			coor = googleMapProjection [it.lng, it.lat]
			it.coorx = coor[0]			
			it.coory = coor[1]
			true

		current_zoom = this.map.zoom 

		googleMapProjection [10, 11]
		console.log 

		setcircle = ->
			it.attr {
				"cx": -> it.coorx
				"cy": -> it.coory
				"r": -> 3
				# it.n_space / 10
			}
			.style {
				"fill": "orange"
				"opacity": 0.9
			}		

		settext = ->
			it.attr {
				"x": -> it.coorx
				"y": -> it.coory
			}
			.style {
				"opacity": zoom-test current_zoom
			}

		setclipPath = ->
			it.attr {
				"cx": -> it.coorx
				"cy": -> it.coory
				"r": -> zoom-level[20 - current_zoom] / 1000000 * 3
				# * it.n_space / 10
#TODO				
			}


		c = gPrints.selectAll "circle"
			.data stationsTsv

		c
			.transition!
			.call setcircle
		
		c
			.enter!
			.append "circle"
			.call setcircle


		t = gPrints.selectAll "text"
			.data stationsTsv

		t
			.enter!
			.append "text"
			.text -> it["station name"]
			.call settext

		t
			.call settext

		cp = gPrints.selectAll ".clipPath"
			.data stationsTsv

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



		b = (mapOffset / 2) # so that wihtouht screen get calculated as well
		voronoi = d3.geom.voronoi!
			# .clipExtent [[0 + mapOffset, 0 + mapOffset], [w + mapOffset, h + mapOffset]]
			.clipExtent [[mapOffset - b , 0 + mapOffset - b], [w + mapOffset + b, h + mapOffset + b]]
			.x -> it.coorx
			.y -> it.coory

		setvoronoi = ->
			it
				.attr {
					"d": -> "M" + (it.join ",") + "Z"
				}
				.style {
					"stroke": "white"
					"stroke-width": 2
					"fill": "white"
					# "rgb(255, 255, 0)"
					"opacity": 0.6
					# "fill": "rgba(255, 255, 0, 0.34)"
				}


		pv = gv.selectAll "path"
			.data voronoi stationsTsv			

		pv
			.enter!
			.append "path"
			.call setvoronoi
			.attr {
				"id": (it, i)-> "path-" + i
				"class": "vcircle"
				"clip-path": (it, i)-> "url(\#clip-" + i + ")"
			}
			
			

		pv
			.transition!
			.call setvoronoi


overlayGoog.setMap map






