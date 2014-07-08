// Generated by LiveScript 1.2.0
var ref$, each, listsToObj, take, drop, reverse, ggl, datalist, gglstationsTsv, cw, ch, crg, hdata, wdata, data, autoplay, pie, rds, arc, svg, pieColor, buildPie, buildHeatMap, parse, run, lsfl, wait, flokay, w, h, mapOffset, styleName, zoomLevel, colorscheme, wtbl, dur, move, color, flash, overlayGoog;
ref$ = require("prelude-ls"), each = ref$.each, listsToObj = ref$.listsToObj, take = ref$.take, drop = ref$.drop, reverse = ref$.reverse;
ggl = {};
ggl.margin = {
  top: 20,
  left: 20,
  right: 0,
  bottom: 10
};
ggl.rect_round = 2;
ggl.rect_width = 10;
ggl.rect_margin = 4;
ggl.w = 380 - ggl.margin.left - ggl.margin.right;
ggl.h = 150 - ggl.margin.top - ggl.margin.bottom;
datalist = ["捷運公館站(2號出口)", "捷運信義安和站", "捷運台北101_世貿站", "捷運大安站", "捷運國父紀念館站", "台灣科技大學", "捷運行天宮站(3號出口)", "三張犁", "捷運台電大樓站(2號出口)", "信義建國路口", "龍門廣場", "臺大資訊大樓", "信義敦化路口", "捷運芝山站(2號出口)", "捷運科技大樓站", "捷運忠孝新生(3號出口)", "捷運六張犁站", "臺北市立圖書館(總館)", "捷運大安森林公園站", "捷運忠孝復興站(2號出口)", "捷運臺大醫院(4號出口)", "捷運象山站", "信義廣場(台北101)", "辛亥新生路口", "臺灣師範大學(圖書館)", "基隆長興路口", "臺北田徑場", "捷運永春站(2號出口)", "中強公園", "捷運東門站(4號出口)", "捷運南港展覽館站(5號出口)", "社教館", "捷運雙連站(2號出口)", "新生和平路口", "松山車站", "仁愛醫院", "世貿二館", "捷運市政府站(3號出口)", "南昌公園", "基隆光復路口", "林森公園", "民生敦化路口", "捷運西門站(3號出口)", "臺北醫學大學", "捷運後山埤站(1號出口)", "永吉松信路口", "羅斯福寧波東街口", "捷運行天宮站(1號出口)", "羅斯福新生南路口", "捷運圓山站(2號出口)", "信義連雲街口", "捷運中山站(2號出口)", "捷運善導寺站(1號出口)", "台北市災害應變中心", "捷運劍南路站(2號出口)", "興雅國中", "仁愛逸仙路口", "吳興公車總站", "台北市政府", "松山家商", "捷運劍潭站(2號出口)", "國家圖書館", "八德市場", "捷運港墘站(2號出口)", "中崙高中", "民生光復路口", "華山文創園區", "成功國宅", "中山行政中心", "國興青年路口", "捷運民權西路站(3號出口)", "建國長春路口", "臺北轉運站", "饒河夜市", "捷運小南門站(1號出口)", "和平重慶路口", "南港車站", "臺北孔廟", "文湖國小", "師範大學公館校區", "捷運士林站(2號出口)", "松德站", "捷運景美站", "福德公園", "國立臺北護理健康大學", "蘭雅公園", "華江高中", "捷運昆陽站(1號出口)", "捷運北投站", "捷運石牌站(2號出口)", "峨嵋停車場", "東園國小", "市立美術館", "捷運新北投站", "世貿三館", "玉成公園", "民生活動中心", "松德公園", "萬大興寧街口", "榮星花園", "蘭興公園", "敦化基隆路口", "汐止火車站", "捷運龍山寺站(1號出口)", "開封西寧路口", "永樂市場", "龍江南京路口", "百齡國小", "台北花木批發市場", "士林運動中心", "大業大同街口", "金山愛國路口", "中研公園", "民權復興路口", "五常公園", "老松國小", "捷運大坪林站", "洲子二號公園", "中正基河路口", "金山市民路口", "振華公園", "瑞光港墘路口", "國泰綜合醫院", "南港世貿公園", "考試院", "青年公園3號出口", "捷運大橋頭站(2號出口)", "興豐公園", "羅斯福景隆街口", "捷運明德站", "復華花園新城", "臺北市客家文化主題公園", "蔣渭水紀念公園", "東新國小", "福林公園", "南港國小", "天母運動公園", "市民廣場", "樹德公園", "建國農安街口", "捷運文德站(2號出口)", "三民公園", "新生長安路口", "國防大學", "民權運動公園", "酒泉延平路口", "新生長春路口", "東湖國小", "捷運動物園站(2號出口)", "華西公園", "東湖國中", "林安泰古厝", "西園艋舺路口", "捷運南港軟體園區站(2號出口)", "北投運動中心", "國立政治大學", "凌雲市場", "大鵬華城", "文山行政中心", "大豐公園", "捷運木柵站", "裕隆公園", "汐止區公所", "麗山國小", "Y-17青少年育樂中心", "仁愛醫院(施工暫停)", "Total", "捷鋥--投站"];
gglstationsTsv = null;
cw = 0;
ch = 0;
crg = 180;
hdata = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
wdata = ["ㄧ", "二", "三", "四", "五", "六", "日"];
data = {};
autoplay = false;
pie = d3.layout.pie().sort(null).value(function(it){
  return it.value;
});
rds = 100;
arc = d3.svg.arc().outerRadius(rds - 30).innerRadius(rds - 34);
svg = d3.select("body").select(".donut").append("svg").attr("width", 400).attr("height", 200).append("g").attr("transform", "translate(100, 100)");
pieColor = function(it, i){
  return it.style({
    "fill": function(it, i){
      if (i === 0) {
        return "rgb(168, 221, 181)";
      } else if (i === 1) {
        return "rgb(240, 59, 32)";
      } else {
        return "rgb(67, 162, 202)";
      }
    }
  });
};
buildPie = function(uptime){
  var g;
  g = svg.selectAll(".arc").data(pie(uptime), function(it){
    return it.data.type;
  });
  g.enter().append("path").attr({
    "d": arc,
    "class": "arc"
  }).call(pieColor);
  return g.transition().duration(1000).attrTween("d", function(it){
    var interpolate;
    this._current = this._current || it;
    interpolate = d3.interpolate(this._current, it);
    this._current = interpolate(0);
    return function(t){
      return arc(interpolate(t));
    };
  });
};
buildHeatMap = function(data, colorlist, name){
  var rg, color, svg;
  rg = d3.max(data, function(it){
    return it.value;
  });
  color = d3.scale.quantize().domain([0, rg]).range(colorlist);
  svg = d3.select("body").select(".heatmap").append("svg").attr("width", ggl.w + ggl.margin.left + ggl.margin.right).attr("height", ggl.h + ggl.margin.top + ggl.margin.bottom).append("g").attr("transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")");
  svg.selectAll("heatreact").data(data).enter().append("rect").attr({
    "x": function(it, i){
      return it.hour * (ggl.rect_width + ggl.rect_margin) - ggl.rect_margin;
    },
    "y": function(it, i){
      return it.week * (ggl.rect_width + ggl.rect_margin) + (it.week >= 5 ? 5 : 0) - ggl.rect_margin;
    },
    "rx": ggl.rect_round,
    "ry": ggl.rect_round,
    "width": ggl.rect_width + ggl.rect_margin * 2,
    "height": ggl.rect_width + ggl.rect_margin * 2,
    "class": function(it){
      return "high high" + it.week + "_" + it.hour;
    }
  }).style({
    "fill": "rgba(0, 0, 0, 0.56)",
    "display": "none"
  });
  svg.selectAll("heatreact").data(data).enter().append("rect").attr({
    "x": function(it, i){
      return it.hour * (ggl.rect_width + ggl.rect_margin);
    },
    "y": function(it, i){
      return it.week * (ggl.rect_width + ggl.rect_margin) + (it.week >= 5 ? 5 : 0);
    },
    "rx": ggl.rect_round,
    "ry": ggl.rect_round,
    "width": ggl.rect_width,
    "height": ggl.rect_width
  }).style({
    "fill": function(it){
      return color(it.value);
    }
  }).on("mouseover", function(it){
    cw = it.week;
    ch = it.hour;
    return flash();
  });
  svg.selectAll(".xaxis").data(hdata).enter().append("text").attr({
    "x": function(it, i){
      return i * (ggl.rect_width + ggl.rect_margin) + ggl.rect_width / 2;
    },
    "y": 0
  }).style({
    "text-anchor": "middle"
  }).text(function(it, i){
    if ((i + 1) % 2 === 0) {
      return it;
    } else {
      return "";
    }
  });
  svg.selectAll(".yaxis").data(wdata).enter().append("text").attr({
    "x": -18,
    "y": function(it, i){
      return ggl.rect_width + i * (ggl.rect_width + ggl.rect_margin) + (i >= 5 ? 5 : 0);
    }
  }).text(function(it){
    return it;
  });
  return d3.selectAll(".heat_station").text(name);
};
parse = function(json){
  var result, itm;
  result = [];
  for (itm in json) {
    result.push({
      "hour": itm.split("_")[1],
      "week": (itm.split("_")[0] - 1 + 7) % 7,
      "value": json[itm]
    });
  }
  return result;
};
run = function(){
  var l, agg, nos, nob, i;
  l = data.nobike["aggregate_nobike"].length;
  agg = [];
  nos = data.nospace["aggregate_nospace"];
  nob = data.nobike["aggregate_nobike"];
  for (i in (fn$())) {
    agg[i] = {};
    agg[i].week = nos[i].week;
    agg[i].hour = nos[i].hour;
    agg[i].value = nos[i].value + nob[i].value;
  }
  buildHeatMap(data.nobike["aggregate_nobike"], reverse(take(5, colorbrewer[colorscheme][9])), "Total");
  return buildHeatMap(data.nospace["aggregate_nospace"], drop(4, colorbrewer[colorscheme][9], "Total"));
  function fn$(){
    var i$, to$, results$ = [];
    for (i$ = 0, to$ = l - 1; i$ <= to$; ++i$) {
      results$.push(i$);
    }
    return results$;
  }
};
lsfl = ["nobike", "nospace"];
wait = 0;
flokay = lsfl.length;
lsfl.map(function(it, j){
  data[it] = {};
  return d3.tsv("./week_hour_total/" + it + ".tsv", function(err, temp){
    --flokay;
    wait += temp.length;
    return temp.filter(function(row, i){
      var cell, results$ = [];
      --wait;
      data[it][row.stations] = [];
      for (cell in row) {
        if (cell !== "stations") {
          row[cell] = +row[cell];
          data[it][row.stations].push({
            "hour": +cell.split("_")[1],
            "week": +(cell.split("_")[0] - 1 + 7) % 7,
            "value": row[cell]
          });
        }
        if (wait === 0 && flokay === 0 && cell === "6_23") {
          results$.push(run());
        }
      }
      return results$;
    });
  });
});
w = 1200;
h = 700;
mapOffset = 4000;
styleName = "paper";
zoomLevel = {
  20: 1128.497220,
  19: 2256.994440,
  18: 4513.988880,
  17: 9027.977761,
  16: 18055.955520,
  15: 36111.911040,
  14: 72223.822090,
  13: 144447.644200,
  12: 288895.288400,
  11: 577790.576700,
  10: 1155581.153000,
  9: 2311162.307000,
  8: 4622324.614000,
  7: 9244649.227000,
  6: 18489298.450000,
  5: 36978596.910000,
  4: 73957193.820000,
  3: 147914387.600000,
  2: 295828775.300000,
  1: 591657550.500000
};
colorscheme = "RdYlBu";
wtbl = listsToObj([0, 1, 2, 3, 4, 5, 6], wdata);
dur = (new Date("May 09 2014 08:22:54") - new Date("Nov 27 2013 16:32:13")) / (1000 * 60);
move = function(){
  ++ch;
  if (ch >= 24) {
    ++cw;
    ch = 0;
  }
  if (cw >= 6) {
    ch = 0;
    cw = 0;
  }
  return flash();
};
color = d3.scale.quantize().domain([-crg, crg]).range(colorbrewer[colorscheme][9]);
flash = function(){
  var tmpidx, l, nobike, nospace, good, ttl, nobike_p, nospace_p, good_p, up;
  d3.selectAll(".heat_weekday").text(wtbl[cw]);
  d3.selectAll(".heat_hour").text(ch);
  tmpidx = null;
  d3.selectAll(".vcircle").transition().duration(1000).style({
    "fill": function(it, i){
      if (tmpidx === null) {
        gglstationsTsv[i].nono.map(function(st, j){
          if (st.hour === ch && st.week === cw) {
            return tmpidx = j;
          }
        });
      }
      return color(gglstationsTsv[i].nono[tmpidx].value);
    }
  });
  d3.selectAll(".high").style({
    "display": "none"
  });
  d3.selectAll(".high" + cw + "_" + ch).style({
    "display": "inline"
  });
  if (data.nobike.aggregate_nobike[tmpidx] !== undefined) {
    l = data.nobike.aggregate_nobike.length;
    nobike = data.nobike.aggregate_nobike[tmpidx].value;
    nospace = data.nospace.aggregate_nospace[tmpidx].value;
    good = dur * l / (24 * 7) - nobike - nospace;
    ttl = nobike + nospace + good;
    nobike_p = nobike / ttl;
    nospace_p = nospace / ttl;
    good_p = good / ttl;
    d3.selectAll(".idx-good").text(~~(good_p * 100) + "%");
    d3.selectAll(".idx-nobike").text(~~(nobike_p * 1000) / 10 + "%");
    d3.selectAll(".idx-nospace").text(~~(nospace_p * 100) + "%");
    up = [
      {
        "type": "good",
        "value": good_p
      }, {
        "type": "nobike",
        "value": nobike_p
      }, {
        "type": "nospace",
        "value": nospace_p
      }
    ];
    return buildPie(up);
  }
};
overlayGoog = new google.maps.OverlayView();
d3.json("./mapstyle/" + styleName + ".json", function(err, mapStyle){
  var map, zoomTest, zoomText;
  mapStyle = new google.maps.StyledMapType(mapStyle, {
    name: styleName
  });
  d3.select('#map').style("width", w + "px").style("height", h + "px").style("margin", "0px").style("padding", "0px");
  map = new google.maps.Map(d3.select('#map').node(), {
    zoom: 12,
    center: new google.maps.LatLng(25.043897602152036, 121.65124407043459),
    mapTypeControlOptions: {
      mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
    }
  });
  zoomTest = function(zoom){
    if (zoom >= 15) {
      return 1;
    } else {
      return 0;
    }
  };
  zoomText = function(zoom){
    return d3.select(".gPrints").selectAll("text").transition().style({
      "opacity": zoomTest(zoom)
    });
  };
  google.maps.event.addListener(map, "bounds_changed", function(){
    var bounds, northEast, southWest;
    bounds = this.getBounds();
    northEast = bounds.getNorthEast();
    southWest = bounds.getSouthWest();
    return zoomText(this.zoom);
  });
  map.mapTypes.set('map_style', mapStyle);
  map.setMapTypeId('map_style');
  return d3.tsv("./stations.tsv", function(err, stationsTsv){
    var me;
    gglstationsTsv = stationsTsv.filter(function(d, i){
      var i$, ref$, len$;
      ["lat", "lng", "n_space"].map(function(it){
        return d[it] = +d[it];
      });
      ["nospace", "nobike"].map(function(it){
        return d[it] = data[it][d.goodstationname];
      });
      d.nono = [];
      for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
        i = ref$[i$];
        d.nono[i] = {};
        d.nono[i].week = d.nospace[i].week;
        d.nono[i].hour = d.nospace[i].hour;
        d.nono[i].value = d.nospace[i].value > d.nobike[i].value
          ? d.nospace[i].value
          : -d.nobike[i].value;
      }
      return true;
      function fn$(){
        var i$, to$, results$ = [];
        for (i$ = 0, to$ = d.nospace.length - 1; i$ <= to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }
    });
    me = null;
    overlayGoog.onAdd = function(){
      var layer, svg, gPrints, gv;
      layer = d3.select(this.getPanes().overlayMouseTarget).append("div");
      svg = layer.append("svg");
      gPrints = svg.append("g").attr("class", "gPrints");
      svg.attr("width", mapOffset * 2).attr("height", mapOffset * 2).style("position", "absolute").style("top", -1 * mapOffset).style("left", -1 * mapOffset);
      gv = svg.append("g").attr("class", "gv");
      return overlayGoog.draw = function(){
        var overlayProjection, googleMapProjection, projecting, current_zoom, setcircle, settext, setclipPath, t, cp, b, voronoi, setvoronoi, pv, c;
        overlayProjection = this.getProjection();
        googleMapProjection = function(coordinates){
          var googleCoordinates, pixelCoordinates;
          googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0]);
          pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates);
          return [pixelCoordinates.x + mapOffset, pixelCoordinates.y + mapOffset];
        };
        projecting = d3.geo.path().projection(googleMapProjection);
        stationsTsv.filter(function(it){
          var coor;
          coor = googleMapProjection([it.lng, it.lat]);
          it.coorx = coor[0];
          it.coory = coor[1];
          return true;
        });
        current_zoom = this.map.zoom;
        googleMapProjection([10, 11]);
        console.log;
        setcircle = function(it){
          return it.attr({
            "cx": function(it){
              return it.coorx;
            },
            "cy": function(it){
              return it.coory;
            },
            "r": function(){
              return 3;
            },
            "class": "stationdots"
          }).style({
            "fill": "red"
          });
        };
        settext = function(it){
          return it.attr({
            "x": function(it){
              return it.coorx;
            },
            "y": function(it){
              return it.coory;
            }
          }).style({
            "opacity": zoomTest(current_zoom)
          });
        };
        setclipPath = function(it){
          return it.attr({
            "cx": function(it){
              return it.coorx;
            },
            "cy": function(it){
              return it.coory;
            },
            "r": function(){
              return zoomLevel[20 - current_zoom] / 1000000 * 3;
            }
          });
        };
        t = gPrints.selectAll("text").data(stationsTsv);
        t.enter().append("text").text(function(it){
          return it["station_name"];
        }).call(settext);
        t.call(settext);
        cp = gPrints.selectAll(".clipPath").data(stationsTsv);
        cp.selectAll("circle").call(setclipPath);
        cp.enter().append("clipPath").attr({
          "id": function(it, i){
            return "clip-" + i;
          },
          "class": "clipPath"
        }).append("circle").call(setclipPath);
        b = mapOffset / 2;
        voronoi = d3.geom.voronoi().clipExtent([[mapOffset - b, 0 + mapOffset - b], [w + mapOffset + b, h + mapOffset + b]]).x(function(it){
          return it.coorx;
        }).y(function(it){
          return it.coory;
        });
        setvoronoi = function(it){
          return it.attr({
            "d": function(it){
              return "M" + it.join(",") + "Z";
            }
          }).style({
            "stroke": "white",
            "stroke-width": 2,
            "opacity": 0.7
          });
        };
        pv = gv.selectAll("path").data(voronoi(stationsTsv));
        pv.enter().append("path").call(setvoronoi).attr({
          "id": function(it, i){
            return "path-" + i;
          },
          "class": "vcircle",
          "clip-path": function(it, i){
            return "url(#clip-" + i + ")";
          }
        }).on("mousedown", function(it, i){
          return console.log(i);
        });
        pv.transition().call(setvoronoi);
        c = gPrints.selectAll(".stationdots").data(stationsTsv);
        c.transition().call(setcircle);
        return c.enter().append("circle").call(setcircle);
      };
    };
    return overlayGoog.setMap(map);
  });
});