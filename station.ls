{each} = require "prelude-ls"

w = 1280
h = 500
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

		setcircle = ->
			it.attr {
				"cx": -> it.coorx
				"cy": -> it.coory
				"r": -> it.n_space / 10
			}
			.style {
				"fill": "orange"
				"opacity": 0.9
			}

		current_zoom = this.map.zoom 
		settext = ->
			it.attr {
				"x": -> it.coorx
				"y": -> it.coory
			}
			.style {
				"opacity": zoom-test current_zoom
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


		# console.log `onoi stationsTsv


		voronoi = d3.geom.voronoi!
			# .clipExtent [[0 + mapOffset, 0 + mapOffset], [w + mapOffset, h + mapOffset]]
			.clipExtent [[300 + mapOffset, 0 + mapOffset], [w + mapOffset - 300, h + mapOffset]]
			.x -> it.coorx
			.y -> it.coory

		setvoronoi = ->
			it
				.attr {
					"d": -> "M" + (it.join ",") + "Z"
				}
				.style {
					"stroke": "red"
					"fill": "none"
				}


		pv = gv.selectAll "path"
			.data voronoi stationsTsv			

		# pv
		# 	.enter!
		# 	.append "path"
		# 	.call setvoronoi
			

		# pv
		# 	.transition!
		# 	.call setvoronoi


overlayGoog.setMap map






