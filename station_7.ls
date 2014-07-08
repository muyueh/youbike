{each, lists-to-obj} = require "prelude-ls"


### heatmap

ggl = {}
ggl.margin = {top: 20, left: 20, right: 0, bottom: 10}
# ggl.w = 550 - ggl.margin.left - ggl.margin.right


ggl.rect_round = 2
# ggl.rect_width = 20
# ggl.rect_width = 15
ggl.rect_width = 10
# ggl.rect_width = 20
# ggl.rect_margin = 3
ggl.rect_margin = 4

# ggl.w = 460 - ggl.margin.left - ggl.margin.right
ggl.w = 380 - ggl.margin.left - ggl.margin.right
# ggl.h = 200 - ggl.margin.top - ggl.margin.bottom
ggl.h = 150 - ggl.margin.top - ggl.margin.bottom

datalist = ["捷運公館站(2號出口)","捷運信義安和站","捷運台北101_世貿站","捷運大安站","捷運國父紀念館站","台灣科技大學","捷運行天宮站(3號出口)","三張犁","捷運台電大樓站(2號出口)","信義建國路口","龍門廣場","臺大資訊大樓","信義敦化路口","捷運芝山站(2號出口)","捷運科技大樓站","捷運忠孝新生(3號出口)","捷運六張犁站","臺北市立圖書館(總館)","捷運大安森林公園站","捷運忠孝復興站(2號出口)","捷運臺大醫院(4號出口)","捷運象山站","信義廣場(台北101)","辛亥新生路口","臺灣師範大學(圖書館)","基隆長興路口","臺北田徑場","捷運永春站(2號出口)","中強公園","捷運東門站(4號出口)","捷運南港展覽館站(5號出口)","社教館","捷運雙連站(2號出口)","新生和平路口","松山車站","仁愛醫院","世貿二館","捷運市政府站(3號出口)","南昌公園","基隆光復路口","林森公園","民生敦化路口","捷運西門站(3號出口)","臺北醫學大學","捷運後山埤站(1號出口)","永吉松信路口","羅斯福寧波東街口","捷運行天宮站(1號出口)","羅斯福新生南路口","捷運圓山站(2號出口)","信義連雲街口","捷運中山站(2號出口)","捷運善導寺站(1號出口)","台北市災害應變中心","捷運劍南路站(2號出口)","興雅國中","仁愛逸仙路口","吳興公車總站","台北市政府","松山家商","捷運劍潭站(2號出口)","國家圖書館","八德市場","捷運港墘站(2號出口)","中崙高中","民生光復路口","華山文創園區","成功國宅","中山行政中心","國興青年路口","捷運民權西路站(3號出口)","建國長春路口","臺北轉運站","饒河夜市","捷運小南門站(1號出口)","和平重慶路口","南港車站","臺北孔廟","文湖國小","師範大學公館校區","捷運士林站(2號出口)","松德站","捷運景美站","福德公園","國立臺北護理健康大學","蘭雅公園","華江高中","捷運昆陽站(1號出口)","捷運北投站","捷運石牌站(2號出口)","峨嵋停車場","東園國小","市立美術館","捷運新北投站","世貿三館","玉成公園","民生活動中心","松德公園","萬大興寧街口","榮星花園","蘭興公園","敦化基隆路口","汐止火車站","捷運龍山寺站(1號出口)","開封西寧路口","永樂市場","龍江南京路口","百齡國小","台北花木批發市場","士林運動中心","大業大同街口","金山愛國路口","中研公園","民權復興路口","五常公園","老松國小","捷運大坪林站","洲子二號公園","中正基河路口","金山市民路口","振華公園","瑞光港墘路口","國泰綜合醫院","南港世貿公園","考試院","青年公園3號出口","捷運大橋頭站(2號出口)","興豐公園","羅斯福景隆街口","捷運明德站","復華花園新城","臺北市客家文化主題公園","蔣渭水紀念公園","東新國小","福林公園","南港國小","天母運動公園","市民廣場","樹德公園","建國農安街口","捷運文德站(2號出口)","三民公園","新生長安路口","國防大學","民權運動公園","酒泉延平路口","新生長春路口","東湖國小","捷運動物園站(2號出口)","華西公園","東湖國中","林安泰古厝","西園艋舺路口","捷運南港軟體園區站(2號出口)","北投運動中心","國立政治大學","凌雲市場","大鵬華城","文山行政中心","大豐公園","捷運木柵站","裕隆公園","汐止區公所","麗山國小","Y-17青少年育樂中心","仁愛醫院(施工暫停)","Total","捷鋥--投站"]

gglstationsTsv = null

cw = 0
ch = 0

hdata = [1 to 24]
	# flatten ["a", "p"].map (d)-> [1 to 12].map (h)-> h + d
wdata = ["ㄧ" "二" "三" "四" "五" "六" "日"]

data = {}

color = d3.scale.quantize!domain [0, 100] .range colorbrewer["YlOrRd"][9]

# color = d3.scale.quantize!domain [0, 400] .range colorbrewer["GnBu"][9]



pie = d3.layout.pie!
	.sort null
	.value -> it.value

rds = 100
arc = d3.svg.arc!
	.outerRadius  rds - 30
	.innerRadius rds - 34

### for pie chart
svg = d3.select "body"
	.select ".donut"
	.append "svg"
	.attr "width", 400
	# ggl.w + ggl.margin.left + ggl.margin.right
	.attr "height", 200
	# ggl.h + ggl.margin.top + ggl.margin.bottom
	.append "g"
	.attr "transform", "translate(100, 100)"
	# .attr "transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")"

pie-color = (it, i)->
	it
		.style {
			"fill": (it, i)-> 
				if i is 0 
					# "rgb(127, 188, 65)"
					# "white"
					# "grey"
					"rgb(168, 221, 181)"f
				else if i is 1
					"rgb(240, 59, 32)"

				else 
					# "rgb(4, 90, 141)"
					"rgb(67, 162, 202)"
		}

build-pie = (uptime)->

	g = svg
		.selectAll ".arc"
		.data (pie uptime), -> it.data.type
		# .enter!
		# .append "g"
		# .attr {
		# 	"class": "arc"
		# }

	g
		.enter!
		.append "path"
		.attr {
			"d": arc
			"class": "arc"
		}
		.call pie-color

	g.transition!
		.duration 1000
		.attrTween "d", ->
			@._current = @._current or it
			interpolate = d3.interpolate @._current, it
			@._current = interpolate 0
			return (t)->
				arc interpolate t





# uptime = [
# 	{type: "good", "value": 80}
# 	{type: "nobike", "value": 15}
# 	{type: "nospace", "value": 5}
# ]

# uptime2 = [
# 	{type: "good", "value": 80}
# 	{type: "nobike", "value": 15}
# 	{type: "nospace", "value": 5}
# ]

# build-pie uptime

build-heat-map = (data, colorscheme, name)->

	rg = d3.max data, -> it.value
	# rg = if colorscheme is "YlOrRd" then 40000 else 30000
	# rg = if colorscheme is "YlOrRd" then 4000 else 30000
	# 100 else 600
	# rg = 100
	# 350
	color = d3.scale.quantize!domain [0, rg] .range colorbrewer[colorscheme][3]

	svg = d3.select "body"
		.select ".heatmap"
		.append "svg"
		.attr "width", ggl.w + ggl.margin.left + ggl.margin.right
		.attr "height", ggl.h + ggl.margin.top + ggl.margin.bottom
		.append "g"
		.attr "transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")"

	svg.selectAll "heatreact"
		.data data
		.enter!
		.append "rect"
		.attr {
			"x": (it, i)-> it.hour * (ggl.rect_width + ggl.rect_margin) - ggl.rect_margin
			"y": (it, i)-> it.week * (ggl.rect_width + ggl.rect_margin) + (if it.week >= 5 then 5 else 0) - ggl.rect_margin
			"rx": ggl.rect_round
			"ry": ggl.rect_round
			"width": ggl.rect_width + ggl.rect_margin * 2 
			"height": ggl.rect_width + ggl.rect_margin * 2
			"class": -> "high high" + it.week + "_"  + it.hour
		}
		.style {
			"fill": "rgba(0, 0, 0, 0.56)"
			# "fill": (it, i)-> if i is 5 then "black"
			"display": "none"
		}

	svg.selectAll "heatreact"
		.data data
		.enter!
		.append "rect"
		.attr {
			"x": (it, i)-> it.hour * (ggl.rect_width + ggl.rect_margin)
			"y": (it, i)-> it.week * (ggl.rect_width + ggl.rect_margin) + (if it.week >= 5 then 5 else 0)
			"rx": ggl.rect_round
			"ry": ggl.rect_round
			"width": ggl.rect_width
			"height": ggl.rect_width
		}
		.style {
			"fill":-> color it.value
		}
		.on "mouseover" ->
			cw := it.week
			ch := it.hour
			flash!


	svg.selectAll ".xaxis"
		.data hdata
		.enter!
		.append "text"
		.attr {
			"x": (it, i)-> i * (ggl.rect_width + ggl.rect_margin) + (ggl.rect_width / 2)
			"y": 0
		}
		.style {
			"text-anchor": "middle"
		}
		.text (it, i)-> if (i + 1) % 2 is 0 then it else ""

	svg.selectAll ".yaxis"
		.data wdata
		.enter!
		.append "text"
		.attr {
			"x": -18
			"y": (it, i)-> (ggl.rect_width)+ i * (ggl.rect_width + ggl.rect_margin) + (if i >= 5 then 5 else 0)
			 # * 3 / 4
		}
		.text -> it

	d3.selectAll ".heat_station"
		.text name
	# svg
	# 	.append "text"
	# 	.text name
	# 	.attr {
	# 		"x": 100
	# 		"y": 100
	# 	}


parse = (json)-> 
	result = []
	# sunday zero to last

	for itm of json
		result.push {
			"hour": (itm.split "_")[1]			
			"week": ((itm.split "_")[0] - 1  + 7) % 7 #start with monday
			"value": json[itm]
		}

	result

# console.log data.nospace["三張犁"]


run = -> 
	# console.log data.nobike["aggregate_nobike"]
	# stnm = "捷運公館站(2號出口)"
	# # console.log stnm

	l = data.nobike["aggregate_nobike"].length
	agg = []

	nos = data.nospace["aggregate_nospace"]
	nob = data.nobike["aggregate_nobike"]
	for i of [0 to l - 1]
		agg[i] = {}
		agg[i].week = nos[i].week
		agg[i].hour = nos[i].hour
		agg[i].value = nos[i].value + nob[i].value
		

	# console.log agg
	# build-heat-map agg, "YlOrRd", "Total"
	# data.nobike["aggregate_nobike"]

	build-heat-map data.nobike["aggregate_nobike"], "YlOrRd", "Total"
	build-heat-map data.nospace["aggregate_nospace"], "GnBu", "Total"

	# build-heat-map data.nobike[stnm], "YlOrRd", stnm
	# build-heat-map data.nospace[stnm], "GnBu", stnm

	# build-heat-map data.nospace[stnm], "GnBu", stnm

	# datalist.map (stnm)-> 
	# 	build-heat-map data.nobike[stnm], "YlOrRd", stnm
	# 	build-heat-map data.nospace[stnm], "GnBu", stnm



lsfl = ["nobike" "nospace"]

wait = 0
flokay = lsfl.length

lsfl.map (it, j)-> 

	data[it] := {}
	err, temp <- d3.tsv "./week_hour_total/" + it + ".tsv"
	-- flokay
	wait += temp.length

	temp.filter (row, i)->
		--wait
		data[it][row.stations] := []
		for cell of row
			if cell is not "stations"
				row[cell] = +row[cell]

				data[it][row.stations].push {
					"hour": +(cell.split "_")[1]
					"week": +((cell.split "_")[0] - 1  + 7) % 7
					"value": row[cell]
				}

			if wait is 0 and flokay is 0 and cell is "6_23" then run!



### map

w = 1200
h = 700
mapOffset = 4000
styleName = "paper"	
	# "turquoise"
	# "retro_no_label"
	# "bently"
	# "argegno"
	# "paper"
	# "subtle"
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


wtbl = lists-to-obj [0 to 6] wdata

dur = ((new Date "May 09 2014 08:22:54") - (new Date "Nov 27 2013 16:32:13") ) / (1000 * 60)

move = ->
	++ch

	if ch >= 24 
		++cw
		ch := 0
	
	if cw >= 6
		ch := 0
		cw := 0

	flash!

flash = -> 

	# rg = d3.max data, -> it.value
	rg = 10
	color = d3.scale.quantize!domain [0, rg] .range colorbrewer[colorscheme][3]

	d3.selectAll ".heat_weekday"
		.text wtbl[cw]

	d3.selectAll ".heat_hour"
		.text ch

	tmpidx = null

	d3.selectAll ".vcircle"
		.transition!
		.duration 1000
		# .delay (d, i)-> i * 3 # i * 5
		.style {
			"fill": (it,i)-> 
# # should be the same order for all of it					
				if tmpidx is null 
					gglstationsTsv[i].nobike.map (st, j)-> 
						if (st.hour is ch and st.week is cw)
							tmpidx := j
				color gglstationsTsv[i].nobike[tmpidx].value
			# "fill": (it,i)-> 
			# 			v = null
			# 			gglstationsTsv[i].nobike.map -> if (it.hour is ch and it.week is cw) then v := it.value
			# 			color v
			# "fill": -> colorbrewer[colorscheme]["3"][~~(Math.random! * 3)]
		}

	d3.selectAll ".high"
		.style {
			"display": "none"
		}

	d3.selectAll ".high" + cw + "_"  + ch
		.style {
			"display": "inline"
		}

		# "class": -> "high high" + it.week + "_"  + it.hour


	if data.nobike.aggregate_nobike[tmpidx] is not undefined 
		l = data.nobike.aggregate_nobike.length
		nobike = (data.nobike.aggregate_nobike[tmpidx].value)
		nospace = data.nospace.aggregate_nospace[tmpidx].value
		good = (dur * l / (24 * 7)) - nobike - nospace

		ttl = nobike + nospace + good

		nobike_p = nobike / ttl
		nospace_p = nospace / ttl
		good_p = good / ttl


		d3.selectAll ".idx-good"
			.text ~~(good_p * 100) + "%"

		d3.selectAll ".idx-nobike"
			.text (~~(nobike_p * 1000)/ 10) + "%"

		d3.selectAll ".idx-nospace"
			.text ~~(nospace_p * 100) + "%"


#TODO Need to devide by basis?
		up = [
			{"type": "good", "value": good_p}
			{"type": "nobike", "value": nobike_p}
			{"type": "nospace", "value": nospace_p}
		]

		# console.log up
		build-pie up


# setInterval (-> move!), 500
# 1000




overlayGoog = new google.maps.OverlayView!

err, mapStyle <- d3.json "./mapstyle/" + styleName + ".json"
	
mapStyle = new google.maps.StyledMapType( mapStyle , {name: styleName});


d3.select '#map'	
	.style "width" w + "px"
	.style "height" h + "px"
	.style "margin" "0px"
	.style "padding" "0px"

map = new google.maps.Map(d3.select '#map' .node!, {
	# zoom: 13,
	zoom: 12,
	center: new google.maps.LatLng(25.043897602152036, 121.65124407043459 ),
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
	# console.log((southWest.lng! + northEast.lng!) / 2)

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

# console.log data
gglstationsTsv := stationsTsv.filter (d, i)->
	["lat", "lng", "n_space"].map -> 
		d[it] = +d[it]


	["nospace", "nobike"].map -> 
		d[it] = data[it][d.goodstationname]
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
			.text -> it["station_name"]
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
			# tmpidx = null
			it
				.attr {
					"d": -> "M" + (it.join ",") + "Z"
				}
				.style {
					"stroke": "white"
					"stroke-width": 2
					# "fill": (it,i)-> 
### # should be the same order for all of it					
						# if tmpidx is null 
# 							stationsTsv[i].nobike.map (st, j)-> 
# 								if (it.hour is ch and it.week is cw)
# 									tmpidx := j

# 						color stationsTsv[i].nobike[tmpidx].value
					"fill": "black"
					# "opacity": 0.6
					"opacity": 0.7
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


