// Generated by LiveScript 1.2.0
var each, w, h, mapOffset, styleName, overlayGoog;
each = require("prelude-ls").each;
w = 1280;
h = 500;
mapOffset = 4000;
styleName = "subtle";
overlayGoog = new google.maps.OverlayView();
d3.json("./mapstyle/" + styleName + ".json", function(err, mapStyle){
  var map, zoomTest, zoomText;
  mapStyle = new google.maps.StyledMapType(mapStyle, {
    name: styleName
  });
  d3.select('#map').style("width", w + "px").style("height", h + "px").style("margin", "0px").style("padding", "0px");
  map = new google.maps.Map(d3.select('#map').node(), {
    zoom: 13,
    center: new google.maps.LatLng(25.043897602152036, 121.5321110748291),
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
    stationsTsv.filter(function(d, i){
      ["lat", "lng", "n_space"].map(function(it){
        return d[it] = +d[it];
      });
      return true;
    });
    overlayGoog.onAdd = function(){
      var layer, svg, gPrints, gv;
      layer = d3.select(this.getPanes().overlayLayer).append("div").attr("class", "svgOverlay");
      svg = layer.append("svg");
      gPrints = svg.append("g").attr("class", "gPrints");
      svg.attr("width", mapOffset * 2).attr("height", mapOffset * 2).style("position", "absolute").style("top", -1 * mapOffset).style("left", -1 * mapOffset);
      gv = svg.append("g").attr("class", "gv");
      return overlayGoog.draw = function(){
        var overlayProjection, googleMapProjection, projecting, setcircle, current_zoom, settext, c, t, voronoi, setvoronoi, pv;
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
        setcircle = function(it){
          return it.attr({
            "cx": function(it){
              return it.coorx;
            },
            "cy": function(it){
              return it.coory;
            },
            "r": function(it){
              return it.n_space / 10;
            }
          }).style({
            "fill": "orange",
            "opacity": 0.9
          });
        };
        current_zoom = this.map.zoom;
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
        c = gPrints.selectAll("circle").data(stationsTsv);
        c.transition().call(setcircle);
        c.enter().append("circle").call(setcircle);
        t = gPrints.selectAll("text").data(stationsTsv);
        t.enter().append("text").text(function(it){
          return it["station name"];
        }).call(settext);
        t.call(settext);
        voronoi = d3.geom.voronoi().clipExtent([[300 + mapOffset, 0 + mapOffset], [w + mapOffset - 300, h + mapOffset]]).x(function(it){
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
            "stroke": "red",
            "fill": "none"
          });
        };
        return pv = gv.selectAll("path").data(voronoi(stationsTsv));
      };
    };
    return overlayGoog.setMap(map);
  });
});