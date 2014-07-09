{each, lists-to-obj, take, drop, reverse, first} = require "prelude-ls"

## not all stations have same time

### heatmap

ggl = {}
ggl.margin = {top: 20, left: 20, right: 0, bottom: 10}

ggl.rect_round = 2
ggl.rect_width = 10
# ggl.rect_margin = 3
ggl.rect_margin = 4

ggl.w = 380 - ggl.margin.left - ggl.margin.right
ggl.h = 150 - ggl.margin.top - ggl.margin.bottom

ggl.stationsTsv = null
# datalist = ["捷運公館站(2號出口)","捷運信義安和站","捷運台北101_世貿站","捷運大安站","捷運國父紀念館站","台灣科技大學","捷運行天宮站(3號出口)","三張犁","捷運台電大樓站(2號出口)","信義建國路口","龍門廣場","臺大資訊大樓","信義敦化路口","捷運芝山站(2號出口)","捷運科技大樓站","捷運忠孝新生(3號出口)","捷運六張犁站","臺北市立圖書館(總館)","捷運大安森林公園站","捷運忠孝復興站(2號出口)","捷運臺大醫院(4號出口)","捷運象山站","信義廣場(台北101)","辛亥新生路口","臺灣師範大學(圖書館)","基隆長興路口","臺北田徑場","捷運永春站(2號出口)","中強公園","捷運東門站(4號出口)","捷運南港展覽館站(5號出口)","社教館","捷運雙連站(2號出口)","新生和平路口","松山車站","仁愛醫院","世貿二館","捷運市政府站(3號出口)","南昌公園","基隆光復路口","林森公園","民生敦化路口","捷運西門站(3號出口)","臺北醫學大學","捷運後山埤站(1號出口)","永吉松信路口","羅斯福寧波東街口","捷運行天宮站(1號出口)","羅斯福新生南路口","捷運圓山站(2號出口)","信義連雲街口","捷運中山站(2號出口)","捷運善導寺站(1號出口)","台北市災害應變中心","捷運劍南路站(2號出口)","興雅國中","仁愛逸仙路口","吳興公車總站","台北市政府","松山家商","捷運劍潭站(2號出口)","國家圖書館","八德市場","捷運港墘站(2號出口)","中崙高中","民生光復路口","華山文創園區","成功國宅","中山行政中心","國興青年路口","捷運民權西路站(3號出口)","建國長春路口","臺北轉運站","饒河夜市","捷運小南門站(1號出口)","和平重慶路口","南港車站","臺北孔廟","文湖國小","師範大學公館校區","捷運士林站(2號出口)","松德站","捷運景美站","福德公園","國立臺北護理健康大學","蘭雅公園","華江高中","捷運昆陽站(1號出口)","捷運北投站","捷運石牌站(2號出口)","峨嵋停車場","東園國小","市立美術館","捷運新北投站","世貿三館","玉成公園","民生活動中心","松德公園","萬大興寧街口","榮星花園","蘭興公園","敦化基隆路口","汐止火車站","捷運龍山寺站(1號出口)","開封西寧路口","永樂市場","龍江南京路口","百齡國小","台北花木批發市場","士林運動中心","大業大同街口","金山愛國路口","中研公園","民權復興路口","五常公園","老松國小","捷運大坪林站","洲子二號公園","中正基河路口","金山市民路口","振華公園","瑞光港墘路口","國泰綜合醫院","南港世貿公園","考試院","青年公園3號出口","捷運大橋頭站(2號出口)","興豐公園","羅斯福景隆街口","捷運明德站","復華花園新城","臺北市客家文化主題公園","蔣渭水紀念公園","東新國小","福林公園","南港國小","天母運動公園","市民廣場","樹德公園","建國農安街口","捷運文德站(2號出口)","三民公園","新生長安路口","國防大學","民權運動公園","酒泉延平路口","新生長春路口","東湖國小","捷運動物園站(2號出口)","華西公園","東湖國中","林安泰古厝","西園艋舺路口","捷運南港軟體園區站(2號出口)","北投運動中心","國立政治大學","凌雲市場","大鵬華城","文山行政中心","大豐公園","捷運木柵站","裕隆公園","汐止區公所","麗山國小","Y-17青少年育樂中心","仁愛醫院(施工暫停)","Total","捷鋥--投站"]

ggl.cw = 0
ggl.ch = 0

# ggl.crg = 600
ggl.crg = 180

ggl.hdata = [1 to 24]
ggl.wdata = ["ㄧ" "二" "三" "四" "五" "六" "日"]

ggl.data = {}

ggl.autoplay = false

ggl.clrschm = "RdYlBu" # ["RdPu","PuBu","YlOrRd","YlOrRd","RdYlGn","RdYlBu","YlGn","YlGnBu","GnBu","BuGn","PuBuGn","BuPu","RdPu","PuRd","Paired","Greys","Reds","PiYG","PRGn","BrBG","PuOr"]

ggl.nclr = 9
ggl.lsclrrd = reverse(take (~~(ggl.nclr / 2) + 1), colorbrewer[ggl.clrschm][ggl.nclr])
ggl.lsclrbl = drop ~~(ggl.nclr / 2), colorbrewer[ggl.clrschm][ggl.nclr]

ggl.cstnm = null # current station name

### map

ggl.mpw = 1200
ggl.mph = 700
ggl.mapOffset = 4000
styleName = "paper"
# styleName = "subtle"
# styleName = "argegno"
# styleName = "paper"
# styleName = "paper"
# styleName = "paper"
	# "monochrome"
	# "paper"	
	# "turquoise"
	# "retro_no_label"
	# "bently"
	# "argegno"
	# "subtle"

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


wtbl = lists-to-obj [0 to 6] ggl.wdata

dur = ((new Date "May 09 2014 08:22:54") - (new Date "Nov 27 2013 16:32:13") ) / (1000 * 60)




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

build-heat-svg = -> 
	d3.select "body"
		.select ".heatmap"
		.append "svg"
		.attr "width", ggl.w + ggl.margin.left + ggl.margin.right
		.attr "height", ggl.h + ggl.margin.top + ggl.margin.bottom
		.append "g"
		.attr "transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")"

svg_heatred = build-heat-svg!
svg_heatblue = build-heat-svg!

pie-color = (it, i)->
	it
		.style {
			"fill": (it, i)-> 
				if i is 0 
					# "rgb(127, 188, 65)"
					# "rgb(168, 221, 181)" ##green
					"rgb(255, 255, 191)" ##yellow
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

build-heat-map = (_data, colorlist, name, svg)->

	rg = d3.max _data, -> it.value
	c = d3.scale.quantize!domain [0, rg] .range colorlist
	color = ->
		if rg is 0
			return first colorlist 
		else			
			return c it

	
	hhrc = svg.selectAll ".high"
		.data _data
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
			"display": "none"
		}

	hrc = svg.selectAll ".heatreact"
		.data _data

	hrc
		.enter!
		.append "rect"
		.attr {
			"x": (it, i)-> it.hour * (ggl.rect_width + ggl.rect_margin)
			"y": (it, i)-> it.week * (ggl.rect_width + ggl.rect_margin) + (if it.week >= 5 then 5 else 0)
			"rx": ggl.rect_round
			"ry": ggl.rect_round
			"width": ggl.rect_width
			"height": ggl.rect_width
			"class": "heatreact"
		}
		.style {
			"fill":-> color it.value
		}
		.on "mouseover" ->
			ggl.cw := it.week
			ggl.ch := it.hour
			flash!

	hrc
		.transition!
		.style {
			"fill":-> color it.value
		}


	svg.selectAll ".xaxis"
		.data ggl.hdata
		.enter!
		.append "text"
		.attr {
			"x": (it, i)-> i * (ggl.rect_width + ggl.rect_margin) + (ggl.rect_width / 2)
			"y": 0
			"class": "xaxis"
		}
		.style {
			"text-anchor": "middle"
		}
		.text (it, i)-> if (i + 1) % 2 is 0 then it else ""

	svg.selectAll ".yaxis"
		.data ggl.wdata
		.enter!
		.append "text"
		.attr {
			"x": -18
			"y": (it, i)-> (ggl.rect_width)+ i * (ggl.rect_width + ggl.rect_margin) + (if i >= 5 then 5 else 0)
			"class": "yaxis"
		}
		.text -> it

	d3.selectAll ".heat_station"
		.text name

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

	# stnm = "捷運公館站(2號出口)"

	if ggl.cstnm is null

		build-heat-map ggl.data.nobike["aggregate_nobike"], ggl.lsclrrd, "Total", svg_heatred
		build-heat-map ggl.data.nospace["aggregate_nospace"], ggl.lsclrbl, "Total", svg_heatblue

	else
		build-heat-map ggl.data.nobike[ggl.cstnm], ggl.lsclrrd, ggl.cstnm, svg_heatred
		build-heat-map ggl.data.nospace[ggl.cstnm], ggl.lsclrbl, ggl.cstnm, svg_heatblue



lsfl = ["nobike" "nospace"]

wait = 0
flokay = lsfl.length

lsfl.map (it, j)-> 

	ggl.data[it] := {}
	err, temp <- d3.tsv "./week_hour_total/" + it + ".tsv"
	-- flokay
	wait += temp.length

	temp.filter (row, i)->
		--wait
		ggl.data[it][row.stations] := []
		for cell of row
			if cell is not "stations"
				row[cell] = +row[cell]

				ggl.data[it][row.stations].push {
					"hour": +(cell.split "_")[1]
					"week": +((cell.split "_")[0] - 1  + 7) % 7
					"value": row[cell]
				}

			if wait is 0 and flokay is 0 and cell is "6_23" then run!


## map

move = ->
	++ggl.ch

	if ggl.ch >= 24 
		++ggl.cw
		ggl.ch := 0
	
	if ggl.cw >= 6
		ggl.ch := 0
		ggl.cw := 0

	flash!

# color = d3.scale.quantize!domain [-100, 100] .range colorbrewer[ggl.clrschm][9]
# color = d3.scale.quantize!domain [-180, 180] .range colorbrewer[ggl.clrschm][9]
color = d3.scale.quantize!domain [-ggl.crg, ggl.crg] .range colorbrewer[ggl.clrschm][ggl.nclr]

flash = -> 

	
	# rg = d3.max data, -> it.value
	# rg = 10
	# color = d3.scale.quantize!domain [0, rg] .range colorbrewer[ggl.clrschm][5]

	d3.selectAll ".heat_weekday"
		.text wtbl[ggl.cw]

	d3.selectAll ".heat_hour"
		.text ggl.ch

	tmpidx = null

	d3.selectAll ".vcircle"
		.transition!
		.duration 1000
		# .delay (d, i)-> i * 3 # i * 5
		.style {

			"fill": (it,i)-> 
				if tmpidx is null 
					ggl.stationsTsv[i].nono.map (st, j)-> 
						if (st.hour is ggl.ch and st.week is ggl.cw)
							tmpidx := j
				color ggl.stationsTsv[i].nono[tmpidx].value


# 			"fill": (it,i)-> 
# # # should be the same order for all of it					
# 				if tmpidx is null 
# 					ggl.stationsTsv[i].nobike.map (st, j)-> 
# 						if (st.hour is ggl.ch and st.week is ggl.cw)
# 							tmpidx := j
# 				color ggl.stationsTsv[i].nobike[tmpidx].value
			# "fill": (it,i)-> 
			# 			v = null
			# 			ggl.stationsTsv[i].nobike.map -> if (it.hour is ggl.ch and it.week is ggl.cw) then v := it.value
			# 			color v
			# "fill": -> colorbrewer[ggl.clrschm]["3"][~~(Math.random! * 3)]
		}

	d3.selectAll ".high"
		.style {
			"display": "none"
		}

	d3.selectAll ".high" + ggl.cw + "_"  + ggl.ch
		.style {
			"display": "inline"
		}

		# "class": -> "high high" + it.week + "_"  + it.hour


	if ggl.data.nobike.aggregate_nobike[tmpidx] is not undefined 
		l = ggl.data.nobike.aggregate_nobike.length
		nobike = (ggl.data.nobike.aggregate_nobike[tmpidx].value)
		nospace = ggl.data.nospace.aggregate_nospace[tmpidx].value
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
	.style "width" ggl.mpw + "px"
	.style "height" ggl.mph + "px"
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

# google.maps.event.addListener(map, "click", ->
# 	console.log @
# )

map.mapTypes.set('map_style', mapStyle)
map.setMapTypeId('map_style')


err, stationsTsv <- d3.tsv "./stations.tsv"

ggl.stationsTsv := stationsTsv.filter (d, i)->
	["lat", "lng", "n_space"].map -> 
		d[it] = +d[it]

	["nospace", "nobike"].map -> 
		d[it] = ggl.data[it][d.goodstationname]

	d.nono = []

	for i in [0 to d.nospace.length - 1]
		# console.log i
		d.nono[i] = {}
		d.nono[i].week = d.nospace[i].week
		d.nono[i].hour = d.nospace[i].hour
		d.nono[i].value = if (d.nospace[i].value > d.nobike[i].value) then d.nospace[i].value else -d.nobike[i].value

	# console.log d.nospace



	true



overlayGoog.onAdd = -> 

	layer = d3.select(this.getPanes!.overlayMouseTarget).append "div"

	svg = layer.append "svg"

	gPrints = svg.append "g" .attr "class" "gPrints"

	svg
		.attr "width" ggl.mapOffset * 2
		.attr "height" ggl.mapOffset * 2
		.style "position" "absolute"
		.style "top" -1 * ggl.mapOffset
		.style "left" -1 * ggl.mapOffset


	gv = svg.append "g"
		.attr "class" "gv"


	overlayGoog.draw = -> 
		overlayProjection = this.getProjection!

		googleMapProjection = (coordinates)->

			googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0])
			pixelCoordinates = overlayProjection.fromLatLngToDivPixel googleCoordinates
			[pixelCoordinates.x + ggl.mapOffset, pixelCoordinates.y + ggl.mapOffset]

		projecting = d3.geo.path!projection googleMapProjection

		ggl.stationsTsv.filter -> 
			coor = googleMapProjection [it.lng, it.lat]
			it.coorx = coor[0]			
			it.coory = coor[1]
			true

		current_zoom = this.map.zoom

		setcircle = ->
			it.attr {
				"cx": -> it.coorx
				"cy": -> it.coory
				"r": -> 3
				# it.n_space / 10
				"class": "stationdots"
			}
			.style {
				"fill": "red"
				# "fill": "orange"
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


		t = gPrints.selectAll "text"
			.data ggl.stationsTsv

		t
			.enter!
			.append "text"
			.text -> it["station_name"]
			.call settext

		t
			.call settext

		cp = gPrints.selectAll ".clipPath"
			.data ggl.stationsTsv

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
			# .clipExtent [[0 + ggl.mapOffset, 0 + ggl.mapOffset], [w + ggl.mapOffset, h + ggl.mapOffset]]
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
					# "fill": (it,i)-> 
### # should be the same order for all of it					
						# if tmpidx is null 
# 							ggl.stationsTsv[i].nobike.map (st, j)-> 
# 								if (it.hour is ggl.ch and it.week is cw)
# 									tmpidx := j

# 						color ggl.stationsTsv[i].nobike[tmpidx].value
					# "opacity": 0.6
					"opacity": 0.7
				}



		pv = gv.selectAll "path"
			.data voronoi ggl.stationsTsv

		pv
			.enter!
			.append "path"
			.call setvoronoi
			.attr {
				"id": (it, i)-> "path-" + i
				"class": "vcircle"
				"clip-path": (it, i)-> "url(\#clip-" + i + ")"
			}
			.on "mousedown", (it, i)->
				ggl.cstnm := ggl.stationsTsv[i].goodstationname
				run!

		pv
			.transition!
			.call setvoronoi

		c = gPrints.selectAll ".stationdots"
			.data ggl.stationsTsv

		c
			.transition!
			.call setcircle
		
		c
			.enter!
			.append "circle"
			.call setcircle


overlayGoog.setMap map

# flash!
