{each} = require "prelude-ls"

projection = null # placeholder
padding = 5

w = 1280
h = 500

topGraph = null
lngDim = 0
latDim = 0

styledMap = new google.maps.StyledMapType(
	[
	{
		"featureType": "road",
		"stylers": [
			{ "visibility": "off" }
		]
	},{
		"featureType": "transit",
		"stylers": [
			{ "visibility": "simplified" }
		]
	},{
	}
	],
	{name: "Styled Map"});


d3.select '#map'	
	.style "width" w + "px"
	.style "height" h + "px"
	.style "margin" "0px"
	.style "padding" "0px"

map = new google.maps.Map(d3.select '#map' .node!, {
	zoom: 14,
	center: new google.maps.LatLng(25.03772442361298, 121.51742362976074 ),
	mapTypeControlOptions:{
		mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
	}
});



google.maps.event.addListener(map, "bounds_changed", ->
	bounds = this.getBounds!
	northEast = bounds.getNorthEast!			
	southWest = bounds.getSouthWest!

	# lngDim.filterRange([southWest.lng!, northEast.lng!])
	# latDim.filterRange([southWest.lat!, northEast.lat!])

	# updatePhoto!

	dc.redrawAll!

	# console.log ((southWest.lng! + northEast.lng!) / 2 )
	# console.log ((southWest.lat! + northEast.lat!) / 2 )
)

map.mapTypes.set('map_style', styledMap)
map.setMapTypeId('map_style')



parsing = (csvString)->
	result = []

	d3.csv
		.parseRows csvString
		.map -> 
			t = new Date it["1"]
			w = t.getDay!

			r = {
				"value": it["0"]
				"date": t
				"weekday": w
				"isWeekend": w is 0 or w is 6 # ["Sun, Mon, Tue, Wed, Thu, Fri, Sat, Sun"]
			}

			result.push r

	result
			
datalist = ["八德市場","三民公園","三張犁","士林運動中心","大業大同街口","大豐公園","大鵬華城","中山行政中心","中正基河路口","中研公園","中崙高中","中強公園","五常公園","仁愛逸仙路口","仁愛醫院","仁愛醫院(施工暫停)","天母運動公園","文山行政中心","文湖國小","世貿二館","世貿三館","北投運動中心","台北市災害應變中心","台北市政府","台北花木批發市場","台灣科技大學","市民廣場","市立美術館","民生光復路口","民生活動中心","民生敦化路口","民權復興路口","民權運動公園","永吉松信路口","永樂市場","玉成公園","成功國宅","汐止火車站","汐止區公所","百齡國小","老松國小","考試院","西園艋舺路口","吳興公車總站","辛亥新生路口","和平重慶路口","東湖國小","東湖國中","東園國小","東新國小","松山車站","松山家商","松德公園","松德站","林安泰古厝","林森公園","社教館","金山市民路口","金山愛國路口","青年公園3號出口","信義建國路口","信義連雲街口","信義敦化路口","信義廣場(台北101)","南昌公園","南港世貿公園","南港車站","南港國小","建國長春路口","建國農安街口","洲子二號公園","凌雲市場","峨嵋停車場","師範大學公館校區","振華公園","酒泉延平路口","國立政治大學","國立臺北護理健康大學","國防大學","國家圖書館","國泰綜合醫院","國興青年路口","基隆光復路口","基隆長興路口","捷運士林站(2號出口)","捷運大安站","捷運大安森林公園站","捷運大坪林站","捷運大橋頭站(2號出口)","捷運小南門站(1號出口)","捷運中山站(2號出口)","捷運公館站(2號出口)","捷運六張犁站","捷運文德站(2號出口)","捷運木柵站","捷運北投站","捷運台北101_世貿站","捷運台電大樓站(2號出口)","捷運市政府站(3號出口)","捷運民權西路站(3號出口)","捷運永春站(2號出口)","捷運石牌站(2號出口)","捷運行天宮站(1號出口)","捷運行天宮站(3號出口)","捷運西門站(3號出口)","捷運忠孝復興站(2號出口)","捷運忠孝新生(3號出口)","捷運昆陽站(1號出口)","捷運明德站","捷運東門站(4號出口)","捷運芝山站(2號出口)","捷運信義安和站","捷運南港展覽館站(5號出口)","捷運南港軟體園區站(2號出口)","捷運後山埤站(1號出口)","捷運科技大樓站","捷運動物園站(2號出口)","捷運國父紀念館站","捷運善導寺站(1號出口)","捷運景美站","捷運港墘站(2號出口)","捷運象山站","捷運圓山站(2號出口)","捷運新北投站","捷運臺大醫院(4號出口)","捷運劍南路站(2號出口)","捷運劍潭站(2號出口)","捷運龍山寺站(1號出口)","捷運雙連站(2號出口)","捷鋥--投站","復華花園新城","敦化基隆路口","華山文創園區","華江高中","華西公園","開封西寧路口","新生和平路口","新生長安路口","新生長春路口","瑞光港墘路口","萬大興寧街口","裕隆公園","榮星花園","福林公園","福德公園","臺大資訊大樓","臺北孔廟","臺北市立圖書館(總館)","臺北市客家文化主題公園","臺北田徑場","臺北轉運站","臺北醫學大學","臺灣師範大學(圖書館)","蔣渭水紀念公園","樹德公園","興雅國中","興豐公園","龍江南京路口","龍門廣場","羅斯福景隆街口","羅斯福新生南路口","羅斯福寧波東街口","麗山國小","饒河夜市","蘭雅公園","蘭興公園","Total","Y-17青少年育樂中心"]


err, csvData <- d3.text "./data/信義廣場(台北101).csv"

parseddata = parsing csvData
# console.log parseddata



weekDayTable = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]

# dc.js

barPerMonth = dc.barChart('#BikeMonth');
# barPerDay = dc.barChart('#BikeDay');
barPerWeekDay = dc.barChart('#BikeWeekDay');
barPerHour = dc.barChart('#BikeHour');
# barAcciMonth = dc.barChart('#AcciMonth');
# barAcciDay = dc.barChart('#AcciDay');
# barAcciWeekDay = dc.barChart('#AcciWeekDay');
# barAcciHour = dc.barChart('#AcciHour');


ndx = crossfilter(parseddata);
all = ndx.groupAll!;

# topGraph := ndx.dimension -> it.thumb

# # don't know why it's negative 
monthDim = ndx.dimension -> it.date.getMonth!
dayDim = ndx.dimension -> it.date.getDate!
weekdayDim = ndx.dimension -> weekDayTable[it.date.getDay!]
hourDim = ndx.dimension -> it.date.getHours!
# lngDim := ndx.dimension -> it.lon
# latDim := ndx.dimension -> it.lat

acciMonth = monthDim.group!.reduceCount!;
acciDay = dayDim.group!.reduceCount!;
acciWeekDay = weekdayDim.group!.reduceCount!;
acciHour = hourDim.group!.reduceCount!;

deathMonth = monthDim.group!.reduceSum -> it.value
deathDay = dayDim.group!.reduceSum -> it.value
deathWeekDay = weekdayDim.group!.reduceSum -> it.value
deathHour = hourDim.group!.reduceSum -> it.value

barWidth = 250
# barWidth = 150
# barHeight = 100
barHeight = 150
marginJson =	{
	"top": 10
	"right": 10
	"left": 50
	"bottom": 20
}



colorBike = "rgb(255, 127, 14)"
# '#de2d26'

	

barPerMonth.width barWidth + 60
	.height barHeight
	.margins marginJson
	.dimension monthDim
	.group deathMonth
	.x(d3.scale.linear!.domain([0, 12]))
	# .x(d3.scale.ordinal!.domain(d3.range(1,13)))
	# .xUnits dc.units.ordinal
	.elasticY true
	.colors -> colorBike
	# .on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

# barPerDay.width barWidth
# 	.height barHeight
# 	.margins marginJson
# 	.dimension dayDim
# 	.group deathDay
# 	.x(d3.scale.linear!.domain([1,31]))
# 	.elasticY true
# 	.colors colorBike
# 	# .on("filtered", -> updateGraph!)
# 	.yAxis!
# 	.ticks 3

barPerWeekDay.width barWidth 
	.height barHeight
	.margins marginJson
	.dimension weekdayDim
	.group deathWeekDay
	.x(d3.scale.ordinal!.domain(weekDayTable))
	.xUnits dc.units.ordinal
	.gap 4
	.elasticY true
	.colors colorBike
	# .on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barPerHour.width (barWidth * 2 + 100)
	.height barHeight
	.margins marginJson
	.dimension hourDim
	.group deathHour
	.x(d3.scale.linear!.domain([0, 24]))
	.elasticY true
	.colors colorBike
	# .on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

dc.renderAll!


d3.selectAll ".notice"
	.text "警告：這裡很快就會沒車了"
	.style {
		"position": "absolute"
		"left": "450px"
		"top": "50px"
		"z-index": 10
		"box-shadow": "rgb(215, 48, 39) 0px 0px 35px 13px inset"
		"width": "250px"
		"height": "80px"
		"box-corner": "10px"
		"border-radius": "20px"
		"text-align": "center"
		"vertical-align": "middle"
		"line-height": "85px"
	}

