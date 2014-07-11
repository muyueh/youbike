// Generated by LiveScript 1.2.0
var ref$, each, listsToObj, flatten, drawsvg, sttHdr, sttTwo, sttPerh, sttMax, toentry, sttw_h, ggl, overlayGoog;
ref$ = require("prelude-ls"), each = ref$.each, listsToObj = ref$.listsToObj, flatten = ref$.flatten;
drawsvg = function(svgClass, file){
  var dsc, svg;
  dsc = {};
  dsc.mgtop = 50;
  dsc.mgbottom = 50;
  dsc.mgleft = 50;
  dsc.mgright = 80;
  dsc.w = 800 - dsc.mgleft - dsc.mgright;
  dsc.h = 700 - dsc.mgtop - dsc.mgbottom;
  svg = d3.select(svgClass).attr({
    "width": dsc.w + dsc.mgleft + dsc.mgright,
    "height": dsc.h + dsc.mgtop + dsc.mgbottom
  }).append("g").attr({
    "transform": "translate(" + dsc.mgleft + "," + dsc.mgtop + ")"
  });
  return d3.tsv("./" + file + ".tsv", function(err, usageTsv){
    var x, y, line;
    usageTsv = usageTsv.filter(function(it, i){
      it.kpi = +it.kpi;
      return it.dt = new Date(it.dt);
    });
    x = d3.time.scale().domain(d3.extent(usageTsv, function(it){
      return it.dt;
    })).range([0, dsc.w]);
    y = d3.scale.linear().domain([
      0, d3.max(usageTsv, function(it){
        return it.kpi;
      })
    ]).range([dsc.h, 0]);
    line = d3.svg.line().interpolate("basis").x(function(it){
      return x(it.dt);
    }).y(function(it){
      return y(it.kpi);
    });
    svg.append("g").attr({
      "class": "axis"
    }).attr({
      "transform": "translate(0," + dsc.h + ")"
    }).call(d3.svg.axis().scale(x).orient("bottom"));
    svg.append("g").attr({
      "class": "axis"
    }).attr({
      "transform": "translate(" + dsc.w + ", 0)"
    }).call(d3.svg.axis().scale(y).orient("right"));
    return svg.selectAll(".pfm").data([usageTsv]).enter().append("path").attr({
      "d": function(it){
        return line(it);
      },
      "fill": "none",
      "class": "pfm"
    }).style({
      "stroke": "black",
      "stroke-width": 2
    });
  });
};
drawsvg(".svgusage", "usage");
drawsvg(".svgbad", "bad");
sttHdr = ["district", "stationname", "address", "n_space", "lng", "lat", "goodstationname"];
sttTwo = ["文山區	師範大學公館校區	師大公館校區校門口(汀州路側)	42	121.537188	25.007528	師範大學公館校區", "大安區	捷運公館2號	羅斯福路/辛亥路(西北側)	30	121.534538	25.01476	捷運公館站(2號出口)"];
sttPerh = [
  {
    "goodstationname": "捷運公館站(2號出口)",
    "data": [591, 3, 152, -274, 16, 145, -68, -357, -337, 290, -262, 264, 416, 245, 73, 2, 40, -378, -166, -261, -410, -231, -9, 510]
  }, {
    "goodstationname": "師範大學公館校區",
    "data": [611, 117, -39, 567, 58, -259, -99, 351, 254, 162, -301, -647, -558, -368, 226, 142, -223, -155, -116, -40, -19, 25, 383, -45]
  }
];
sttMax = d3.max(
flatten(
sttPerh.map(function(it, i){
  return it.data.map(function(it){
    return Math.abs(it);
  });
})));
sttPerh.map(function(it, i){
  var hs, x, y, line, area, g, xt;
  hs = {};
  hs.mgleft = 20;
  hs.mgright = 30;
  hs.mgtop = 30;
  hs.mgbottom = 30;
  hs.w = 280 - hs.mgleft - hs.mgright;
  hs.h = 150 - hs.mgtop - hs.mgbottom;
  x = d3.scale.linear().domain([0, it.data.length]).range([0, hs.w]);
  y = d3.scale.linear().domain([-sttMax, sttMax]).range([hs.h, 0]);
  line = d3.svg.line().interpolate("basis").x(function(it, i){
    return x(i);
  }).y(function(it, i){
    return y(it);
  });
  area = d3.svg.area().interpolate("basis").x(function(it, i){
    return x(i);
  }).y(function(it, i){
    return y(it);
  }).y0(hs.h / 2);
  g = d3.select("#stn" + (i + 1)).select(".stnhis").attr({
    width: hs.w + hs.mgleft + hs.mgright,
    height: hs.h + hs.mgtop + hs.mgbottom
  }).append("g").attr({
    "transform": "translate(" + hs.mgleft + "," + hs.mgtop + ")"
  });
  g.selectAll(".gridx").data(y.ticks(4)).enter().append("line").attr({
    "clas": "gridx",
    "x1": 0,
    "x2": hs.w,
    "y1": function(it){
      return y(it);
    },
    "y2": function(it){
      return y(it);
    },
    "fill": "none",
    "shape-rendering": "crispEdges",
    "stroke": "orange",
    "stroke-width": 1
  });
  xt = g.selectAll(".gridy").data([6, 12, 18].map(function(it){
    return it - 1;
  }));
  xt.enter().append("line").attr({
    "clas": "gridy",
    "x1": function(it){
      return x(it);
    },
    "x2": function(it){
      return x(it);
    },
    "y1": 10,
    "y2": hs.h - 8,
    "fill": "none",
    "shape-rendering": "crispEdges",
    "stroke": "orange",
    "stroke-width": 1
  });
  xt.enter().append("text").text(function(it){
    return it + 1;
  }).attr({
    "x": function(it){
      return x(it) - 3;
    },
    "y": hs.h + 10,
    "stroke": "orange"
  });
  return g.append("path").attr({
    "d": line(it.data)
  }).style({
    "fill": "none",
    "stroke": "white",
    "stroke-width": 2
  });
});
toentry = function(array){
  var c_w, c_h;
  c_w = 0;
  c_h = 0;
  return array.map(function(it, i){
    var rslt;
    rslt = {
      "week": (c_w - 1 + 7) % 7,
      "hour": c_h,
      "value": it
    };
    if (c_h === 23) {
      c_h = 0;
      ++c_w;
    } else {
      ++c_h;
    }
    return rslt;
  });
};
sttw_h = [
  {
    "goodstationname": "捷運公館站(2號出口)",
    "data": toentry([67, 94, 34, 99, 157, 11, 9, 10, 11, 103, 109, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 24, 32, 2, 0, 0, 0, 4, 2, 0, 26, 103, 178, 92, 101, 87, 58, 24, 0, 0, 0, 0, 0, 0, 0, 57, 42, 15, 0, 9, 0, 11, 12, 0, 23, 65, 95, 78, 76, 8, 3, 0, 0, 0, 0, 0, 0, 0, 0, 31, 2, 17, 0, 0, 0, 46, 5, 0, 21, 58, 125, 128, 56, 24, 17, 23, 0, 0, 0, 0, 0, 0, 0, 23, 15, 3, 6, 0, 0, 0, 0, 14, 43, 107, 160, 82, 70, 40, 6, 0, 0, 0, 0, 22, 32, 0, 16, 36, 35, 14, 8, 2, 3, 25, 6, 19, 107, 125, 63, 48, 71, 18, 11, 2, 0, 0, 0, 0, 0, 2, 0, 89, 208, 35, 32, 35, 85, 73, 17, 21, 31, 37, 111, 111, 91, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 38, 136])
  }, {
    "goodstationname": "師範大學公館校區",
    "data": toentry([6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 75, 37, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 70, 34, 24, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 26, 0, 0, 0, 0, 0, 36, 28, 15, 0, 0, 0, 39, 30, 8, 13, 11, 1, 0, 0, 0, 0, 0, 0, 14, 3, 44, 2, 45, 5, 28, 39, 25, 5, 0, 8, 44, 0, 0, 0, 6, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 6, 0, 1, 52, 138, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 51, 5, 25, 66, 0, 0, 27, 47, 0, 0, 0, 2, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 6, 33, 32, 0, 0, 33, 21, 9, 8, 0, 0])
  }
];
sttw_h.map(function(it, i){
  var hmap, g;
  hmap = {};
  hmap.mgleft = 20;
  hmap.mgright = 30;
  hmap.mgtop = 20;
  hmap.mgbottom = 0;
  hmap.w = 280 - hmap.mgleft - hmap.mgright;
  hmap.h = 150 - hmap.mgtop - hmap.mgbottom;
  hmap.rctmg = 2;
  hmap.rctw = 9.5 - hmap.rctmg;
  g = d3.select("#stn" + (i + 1)).select(".stnheat").attr({
    width: hmap.w + hmap.mgleft + hmap.mgright,
    height: hmap.h + hmap.mgtop + hmap.mgbottom
  }).append("g").attr({
    "transform": "translate(" + hmap.mgleft + "," + hmap.mgtop + ")"
  });
  return g.selectAll(".rctheat").data(it.data).enter().append("rect").attr({
    "x": function(it, i){
      return it.hour * (hmap.rctw + hmap.rctmg);
    },
    "y": function(it, i){
      return ((it.week > 4 ? 0.5 : 0) + it.week) * (hmap.rctw + hmap.rctmg);
    },
    "width": hmap.rctw,
    "height": hmap.rctw
  }).style({
    "fill": "orange",
    "opacity": function(it, i){
      return it.value / 100 + 0.1;
    }
  });
});
sttTwo = sttTwo.map(function(it){
  return listsToObj(sttHdr, it.split("\t"));
}).filter(function(d, i){
  return ["lat", "lng", "n_space"].map(function(it){
    return d[it] = +d[it];
  });
});
ggl = {};
ggl.mpw = 1300;
ggl.mph = 800;
ggl.mapOffset = 4000;
ggl.styleName = "paper_light";
overlayGoog = new google.maps.OverlayView();
d3.json("../mapstyle/" + ggl.styleName + ".json", function(err, mapStyle){
  var map, addOverlay;
  mapStyle = new google.maps.StyledMapType(mapStyle, {
    name: ggl.styleName
  });
  d3.select('#map').style("width", ggl.mpw + "px").style("height", ggl.mph + "px").style("margin", "0px").style("padding", "0px");
  map = new google.maps.Map(d3.select('#map').node(), {
    zoom: 15,
    center: new google.maps.LatLng(25.012476274167252, 121.53414687147142),
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
          }).transition().attr({
            "r": function(){
              return 50;
            }
          }).transition().attr({
            "r": function(){
              return 10;
            }
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
            "r": function(){
              return 150;
            }
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
            "fill": "orange",
            "opacity": 0.1
          });
        };
        pv = gv.selectAll("path").data(voronoi(stations));
        pv.enter().append("path").call(setvoronoi).attr({
          "id": function(it, i){
            return "path-" + i;
          },
          "class": "vcircle",
          "clip-path": function(it, i){
            return "url(#clip-" + i + ")";
          }
        }).on("mouseenter", function(){
          return d3.select(this).transition().style({
            "opacity": 0.8
          });
        }).on("mouseleave", function(){
          return d3.select(this).transition().style({
            "opacity": 0.1
          });
        });
        pv.transition().call(setvoronoi);
        c = gPrints.selectAll(".stationdots").data(stations);
        c.transition().call(setcircle);
        return c.enter().append("circle").call(setcircle);
      };
    };
    return overlayGoog.setMap(map);
  };
  return addOverlay(sttTwo);
});