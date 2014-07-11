// Generated by LiveScript 1.2.0
var listsToObj, mk_look;
listsToObj = require("prelude-ls").listsToObj;
mk_look = function(filename, ctnClass){
  var cnvidx, ggl, svg, scaleM, scaleW, dateToMinute;
  cnvidx = 0;
  ggl = {};
  ggl.margin = {
    top: 40,
    left: 50,
    right: 60,
    bottom: 15
  };
  ggl.w = 500 - ggl.margin.left - ggl.margin.right;
  ggl.h = 500 - ggl.margin.top - ggl.margin.bottom;
  svg = d3.select("body").select(ctnClass).append("svg").attr({
    "width": ggl.w + ggl.margin.left + ggl.margin.right,
    "height": ggl.h + ggl.margin.top + ggl.margin.bottom
  }).style({
    "position": "absolute"
  }).append("g").attr("transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")");
  d3.select("body").select(ctnClass).append("canvas").attr({
    "width": ggl.w + ggl.margin.left + ggl.margin.right,
    "height": ggl.h + ggl.margin.top + ggl.margin.bottom,
    "id": "cnvlook" + filename
  });
  scaleM = d3.time.scale().range([0, ggl.w]).domain([0, 24 * 60]);
  scaleW = d3.scale.linear().range([ggl.h, 0]);
  dateToMinute = function(it){
    return it.getHours() * 60 + it.getMinutes();
  };
  return d3.text("../under_n_over/" + filename + ".csv", function(err, staionTSV){
    var stringToDate, stationJSON, mrg, unt, hlp, scaleT, cnv, cnvW, cnvH, ctx, cnvData, buf8, drawPixel, clear, updateCanvas, oran, blue, drawHLine, scaleH, arrw, hdx, hdy, bltArr;
    stringToDate = function(it){
      return new Date(eval(
      it.trim()));
    };
    stationJSON = staionTSV.split("\n").map(function(row, i){
      var cells, r;
      if (row === "") {
        return;
      }
      cells = row.split(",");
      r = {};
      r.start = stringToDate(cells[0]);
      r.end = stringToDate(cells[1]);
      r.sec = (r.end - r.start) / 1000;
      r.type = cells[2].trim();
      return r;
    });
    stationJSON = stationJSON.filter(function(it){
      if (it === undefined) {
        return false;
      } else {
        return true;
      }
    });
    mrg = 20;
    unt = (ggl.h - 6 * mrg) / 7;
    hlp = d3.time.scale().range([unt, 0]).domain(d3.extent(stationJSON, function(it){
      return it.start;
    }));
    scaleT = function(time){
      return hlp(time) + (time.getDay() - 1 + 7) % 7 * (unt + mrg);
    };
    stationJSON.filter(function(it, i){
      return it.pos_y = scaleT(it.start);
    });
    cnv = document.getElementById("cnvlook" + filename);
    cnvW = cnv.width;
    cnvH = cnv.height;
    ctx = cnv.getContext("2d");
    cnvData = ctx.getImageData(0, 0, cnvW, cnvH);
    buf8 = new Uint8ClampedArray(new ArrayBuffer(cnvData.data.length));
    drawPixel = function(x, y, r, g, b, a){
      var index;
      index = ((x + ggl.margin.left) + (y + ggl.margin.top) * cnvW) * 4;
      cnvData.data[index + 0] = r;
      cnvData.data[index + 1] = g;
      cnvData.data[index + 2] = b;
      return cnvData.data[index + 3] = a;
    };
    clear = function(){
      return cnvData.data.set(buf8);
    };
    updateCanvas = function(){
      return ctx.putImageData(cnvData, 0, 0);
    };
    oran = colorbrewer["RdYlBu"][5][0];
    blue = colorbrewer["RdYlBu"][5][4];
    drawHLine = function(x1, x2, y1, y2, color){
      return (function(){
        var i$, to$, results$ = [];
        for (i$ = x1, to$ = x2; i$ <= to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }()).map(function(xi){
        drawPixel(~~xi, ~~y1, color.r, color.g, color.b, 255);
        return drawPixel(~~xi, ~~(y1 + 1), color.r, color.g, color.b, 255);
      });
    };
    stationJSON.map(function(it, i){
      var x1, x2, y1, y2, c;
      x1 = scaleM(dateToMinute(it.start));
      x2 = scaleM(it.start.getDate() !== it.end.getDate()
        ? 24 * 60
        : dateToMinute(it.end));
      y1 = it.pos_y;
      y2 = it.pos_y;
      c = it.type === "nospace"
        ? d3.rgb(blue)
        : d3.rgb(oran);
      return drawHLine(x1, x2, y1, y2, c);
    });
    updateCanvas();
    svg.selectAll(".ylabel").data(["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]).enter().append("text").attr({
      "x": -40,
      "y": function(it, i){
        return (i + 0.5) * (unt + mrg);
      }
    }).text(function(it, i){
      return it;
    });
    scaleH = d3.scale.linear().range([0, ggl.w]).domain([0, 24]);
    svg.append("g").attr({
      "class": "axis"
    }).attr({
      "transform": "translate(0, -10)"
    }).call(d3.svg.axis().scale(scaleH).orient("top").tickValues([0, 6, 12, 18, 24]));
    arrw = function(it){
      return it.style({
        "stroke": "black",
        "stroke-width": 1
      });
    };
    svg.append("line").attr({
      "x1": ggl.w + 10,
      "x2": ggl.w + 10,
      "y1": ggl.h - unt,
      "y2": ggl.h
    }).call(arrw).style({
      "shape-rendering": "crispEdges"
    });
    hdx = ggl.w + 10;
    hdy = ggl.h - unt;
    bltArr = function(x1, y1){
      svg.append("line").attr({
        "x1": x1,
        "x2": x1 - 6,
        "y1": y1,
        "y2": y1 + 9
      }).call(arrw);
      return svg.append("line").attr({
        "x1": x1,
        "x2": x1 + 6,
        "y1": y1,
        "y2": y1 + 9
      }).call(arrw);
    };
    bltArr(hdx, hdy);
    svg.append("text").attr({
      "x": hdx - 15,
      "y": hdy - 2
    }).text("Now").style({
      font: 10,
      "sans-serif": "sans-serif"
    });
    return svg.append("text").attr({
      "x": hdx - 15,
      "y": hdy + unt + 12
    }).text("Nov. '13 ").style({
      font: 10,
      "sans-serif": "sans-serif"
    });
  });
};
mk_look("信義廣場(台北101)", ".data_look");
mk_look("捷運公館站(2號出口)", ".data_look");
mk_look("捷運國父紀念館站", ".data_look");