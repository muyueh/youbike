// Generated by LiveScript 1.2.0
var ref$, listsToObj, flatten, ggl, setColorScl, whtick, setVCircleColor, setHRect, hhdr, hmap, initHeat;
ref$ = require("prelude-ls"), listsToObj = ref$.listsToObj, flatten = ref$.flatten;
ggl = {};
ggl.mpw = 800;
ggl.mph = 750;
ggl.mapOffset = 4000;
ggl.styleName = "paper_light";
ggl.hrls = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
ggl.wkls = ["ㄧ", "二", "三", "四", "五", "六", "日"];
ggl.flls = ["neg", "pos", "sum"];
ggl.stationsInfo = {};
ggl.whdata = {};
ggl.crrview = "neg";
ggl.crrstation = "捷運公館站(2號出口)";
ggl.crrweek = 0;
ggl.crrhour = 0;
ggl.colorscl = null;
ggl.zoomlevel = {
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
ggl.colorSet = {
  "neg": {
    schm: "GnBu",
    dm: [0, -20]
  },
  "pos": {
    schm: "YlOrRd",
    dm: [0, 20]
  },
  "sum": {
    schm: "RdYlBu",
    dm: [10, -10]
  }
};
setColorScl = function(){
  return ggl.colorscl = d3.scale.quantize().domain(ggl.colorSet[ggl.crrview]["dm"]).range(colorbrewer[ggl.colorSet[ggl.crrview]["schm"]][5]);
};
setColorScl();
whtick = function(){
  ++ggl.crrhour;
  if (ggl.crrhour >= 24) {
    ggl.crrhour = 0;
    ++ggl.crrweek;
  }
  if (ggl.crrweek >= 7) {
    ggl.crrweek = 0;
    ggl.crrhour = 0;
  }
  setVCircleColor();
  return console.log(ggl.crrweek + ":" + ggl.crrhour);
};
setInterval(function(){
  return whtick();
}, 1000);
setVCircleColor = function(){
  return d3.selectAll(".vcircle").transition().duration(1000).style({
    "fill": function(it){
      var nm, w_h;
      nm = it.point.goodstationname;
      w_h = ggl.crrweek + "_" + ggl.crrhour;
      return ggl.colorscl(ggl.whdata[ggl.crrview][nm][w_h]);
    }
  });
};
setHRect = function(){
  var dt, cwh, results$ = [];
  dt = ggl.whdata[ggl.crrview][ggl.crrstation];
  for (cwh in dt) {
    if (cwh !== "stations") {
      results$.push(d3.selectAll(".hm-" + cwh).style({
        "fill": ggl.colorscl(dt[cwh])
      }));
    }
  }
  return results$;
};
hhdr = flatten([0, 1, 2, 3, 4, 5, 6].map(function(w){
  return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23].map(function(h){
    return {
      "week": w,
      "hour": h,
      "wh": w + "_" + h
    };
  });
}));
hmap = {};
hmap.mgleft = 5;
hmap.mgright = 5;
hmap.mgtop = 10;
hmap.mgbottom = 10;
hmap.w = 330 - hmap.mgleft - hmap.mgright;
hmap.h = 100 - hmap.mgtop - hmap.mgbottom;
hmap.rctmg = 3;
hmap.rctw = 12 - hmap.rctmg;
initHeat = function(){
  var g;
  g = d3.selectAll(".stn0").selectAll(".heatmap").attr({
    width: hmap.w + hmap.mgleft + hmap.mgright,
    height: hmap.h + hmap.mgtop + hmap.mgbottom
  }).append("g").attr({
    "transform": "translate(" + hmap.mgleft + "," + hmap.mgtop + ")"
  });
  return g.selectAll(".rctheat").data(hhdr).enter().append("rect").attr({
    "x": function(it, i){
      return it.hour * (hmap.rctw + hmap.rctmg);
    },
    "y": function(it, i){
      var w;
      w = ((it.week - 1) + 7) % 7;
      return ((w > 4 ? 0.5 : 0) + w) * (hmap.rctw + hmap.rctmg);
    },
    "class": function(it, i){
      return "rctheat hm-" + it.wh;
    },
    "width": hmap.rctw,
    "height": hmap.rctw
  }).style({
    "fill": "orange"
  });
};
initHeat();
d3.json("../week_hour_total/station_start.json", function(err, startJson){
  var enddate, at;
  enddate = new Date("Fri May 09 2014 08:22:54 GMT+0800 (CST)");
  for (at in startJson) {
    startJson[at] = (enddate - new Date(startJson[at])) / 1000 / 60 / 60 / 7 / 24;
  }
  return d3.tsv("../stations.tsv", function(err, infoTsv){
    var flwait, overlayGoog, map;
    infoTsv.filter(function(d, i){
      ["lat", "lng", "n_space"].map(function(it){
        return d[it] = +d[it];
      });
      ggl.stationsInfo[d.goodstationname] = d;
      return true;
    });
    flwait = ggl.flls.length;
    ggl.flls.map(function(flname){
      return d3.tsv("../move_week _hour/" + flname + ".tsv", function(err, whdata){
        var whwait;
        --flwait;
        whwait = whdata.length;
        ggl.whdata[flname] = {};
        return whdata.map(function(stdata){
          var dt;
          --whwait;
          for (dt in stdata) {
            if (dt !== "stations") {
              stdata[dt] = +stdata[dt] / startJson[stdata.stations];
            }
          }
          ggl.whdata[flname][stdata.stations] = stdata;
          if (flwait === 0 && whwait === 0) {
            return console.log(ggl.whdata[ggl.crrview][ggl.crrstation]);
          }
        });
      });
    });
    overlayGoog = new google.maps.OverlayView();
    map = null;
    return d3.json("../mapstyle/" + ggl.styleName + ".json", function(err, mapStyle){
      var addOverlay;
      mapStyle = new google.maps.StyledMapType(mapStyle, {
        name: ggl.styleName
      });
      d3.select('#map').style("width", ggl.mpw + "px").style("height", ggl.mph + "px").style("margin", "0px").style("padding", "0px");
      map = new google.maps.Map(d3.select('#map').node(), {
        zoom: 15,
        center: new google.maps.LatLng(25.009985401778902, 121.53998335828783),
        mapTypeControlOptions: {
          mapTypeId: [google.maps.MapTypeId.ROADMAP, 'map_style']
        }
      });
      google.maps.event.addListener(map, "bounds_changed", function(){
        var bounds, northEast, southWest;
        bounds = this.getBounds();
        northEast = bounds.getNorthEast();
        southWest = bounds.getSouthWest();
        return console.log([(southWest.lng() + northEast.lng()) / 2, (southWest.lat() + northEast.lat()) / 2]);
      });
      map.mapTypes.set('map_style', mapStyle);
      map.setMapTypeId('map_style');
      addOverlay = function(stations){
        overlayGoog.onAdd = function(){
          var layer, svg, gv, gPrints;
          layer = d3.select(this.getPanes().overlayMouseTarget).append("div");
          svg = layer.append("svg");
          gv = svg.append("g").attr("class", "gv");
          gPrints = svg.append("g").attr("class", "gPrints");
          svg.attr({
            "width": ggl.mapOffset * 2,
            "height": ggl.mapOffset * 2
          }).style({
            "position": "absolute",
            "top": -1 * ggl.mapOffset,
            "left": -1 * ggl.mapOffset
          });
          return overlayGoog.draw = function(){
            var overlayProjection, googleMapProjection, projecting, current_zoom, setcircle, settext, setclipPath, cp, b, voronoi, setvoronoi, pv, c;
            overlayProjection = this.getProjection();
            googleMapProjection = function(coordinates){
              var googleCoordinates, pixelCoordinates;
              googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0]);
              pixelCoordinates = overlayProjection.fromLatLngToDivPixel(googleCoordinates);
              return [pixelCoordinates.x + ggl.mapOffset, pixelCoordinates.y + ggl.mapOffset];
            };
            projecting = d3.geo.path().projection(googleMapProjection);
            stations.filter(function(it){
              var coor;
              coor = googleMapProjection([it.lng, it.lat]);
              it.coorx = coor[0];
              it.coory = coor[1];
              return true;
            });
            current_zoom = this.map.zoom;
            setcircle = function(it){
              return it.attr({
                "cx": function(it){
                  return it.coorx;
                },
                "cy": function(it){
                  return it.coory;
                },
                "r": function(){
                  return 0;
                },
                "class": "stationdots"
              }).style({
                fill: "white",
                stroke: "rgb(252, 78, 42)",
                strokeWidth: "5px"
              });
            };
            settext = function(it){
              return it.attr({
                "x": function(it, i){
                  return it.coorx + (i === 0 ? -400 : 50);
                },
                "y": function(it){
                  return it.coory - 100;
                }
              }).style({
                "font-size": "30px"
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
                "r": ggl.zoomlevel[20 - current_zoom] / 1000000 * 3
              });
            };
            cp = gPrints.selectAll(".clipPath").data(stations);
            cp.selectAll("circle").call(setclipPath);
            cp.enter().append("clipPath").attr({
              "id": function(it, i){
                return "clip-" + i;
              },
              "class": "clipPath"
            }).append("circle").call(setclipPath);
            b = ggl.mapOffset / 2;
            voronoi = d3.geom.voronoi().clipExtent([[ggl.mapOffset - b, 0 + ggl.mapOffset - b], [ggl.mpw + ggl.mapOffset + b, ggl.mph + ggl.mapOffset + b]]).x(function(it){
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
                "fill": "none",
                "opacity": 0.8
              });
            };
            pv = gv.selectAll("path").data(voronoi(stations));
            pv.enter().append("path").call(setvoronoi).attr({
              "id": function(it, i){
                return "path-" + i;
              },
              "class": function(it, i){
                return "vcircle" + " pathnm-" + it.goodstationname;
              },
              "clip-path": function(it, i){
                return "url(#clip-" + i + ")";
              }
            });
            pv.call(setvoronoi);
            pv.exit().remove();
            c = gPrints.selectAll(".stationdots").data(stations);
            c.transition().call(setcircle);
            return c.enter().append("circle").call(setcircle);
          };
        };
        return overlayGoog.setMap(map);
      };
      return addOverlay(infoTsv);
    });
  });
});