var WIDTH = 1000;
var HEIGHT = 700;

var bgcolor = 0xffffff;
var stage = new PIXI.Stage(bgcolor);
var renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT);
board.appendChild(renderer.view);
var loader = new PIXI.AssetLoader(['tiles.json']);

var VERT = 0;
var HORZ = 1;
var WATER = 2;
var DESTROYED = 3;

var vert = isoTile('roadEW.png');
var horz = isoTile('roadNS.png');
var water = isoTile('water.png');
var destroyed = isoTile('dirtDouble.png');
var tiles = [vert, horz, water, destroyed];

var tileWidth = 50;
var tileHeight = 50;

function convert_to_letter(i) {

	return String.fromCharCode(64 + i);
}

function drawMap(rowdata, rowsize, xOffset, yOffset) {

    var tileType, x, y, isoX, isoY, idx;

    console.log("rowsize " + rowsize);

    var textstart = 500;
    for (var i = 1; i < rowsize; i++) {
        
        var rowText = new PIXI.Text(convert_to_letter(i), { font: "32px Arial", fill: "gray"});
        rowText.position.x = textstart + (-i * 50);
        rowText.position.y = 0 + (i * 24);;
		stage.addChild(rowText);

        var cols = rowdata[i];
        console.log(cols);			     

        for (var j = 0, jL = cols.length; j < jL; j++) {

            x = j * tileWidth;
            y = i * tileHeight;

            // iso coordinate
            isoX = x - y;
            isoY = (x + y) / 2;

            tileType = cols[j];

            if (tileType != " ") {
    			console.log("Tile type [" + tileType + "]");

    			if (tileType == "V") {
					drawTile = tiles[VERT];                				
					drawTile(isoX + xOffset, isoY + yOffset);
    			}

				if (tileType == "H") {
					drawTile = tiles[HORZ];                				
					drawTile(isoX + xOffset, isoY + yOffset);
    			}

    			if (tileType == "D") {

					drawTile = tiles[DESTROYED];                				
					drawTile(isoX + xOffset, isoY + yOffset);
    			}                			

            } else {
            	drawTile = tiles[WATER];                				
				drawTile(isoX + xOffset, isoY + yOffset);
            }

         }
    }

    var xstart = -40;
    var ystart = 290;

    // Col numbers
    for (var i = 1; i < rowsize; i++) {

        var colHeaderText = new PIXI.Text(i, { font: "32px Arial", fill: "gray"});
        colHeaderText.position.x = xstart + (i * 45);
        colHeaderText.position.y = ystart + (i * 24);
		stage.addChild(colHeaderText);
    }
}

function isoTile(filename) {

	console.log("filename " + filename);

	return function(x, y) {

		var tile = PIXI.Sprite.fromFrame(filename);
		tile.position.x = x;
		tile.position.y = y;

		// bottom-left
		tile.anchor.x = 0;
		tile.anchor.y = 1;
		stage.addChild(tile);
	}
}

function loadexistingboard(gameid, currentplayernumber) {

	$.getJSON("/board/" + gameid + "/player/" + currentplayernumber, 

		function(board) {

			console.log(board);
			var y = -250;

			var size = board["size"] + 1;
			var rowdata = board["rows"];

			// Callback start() when the loader completes loading
			loader.onComplete = start;
			loader.load();

			function start() {

			  drawMap(rowdata, size, WIDTH / 2, tileHeight * 1.5);

			  function animate() {
			     //requestAnimFrame(animate);
			     renderer.render(stage);
			  }

			  requestAnimFrame(animate);
			}

		}
	);
}

function displayboard() {

	console.log(board);
	var y = -250;

	var size = board["size"] + 1;
	var rowdata = board["rows"];

	// Callback start() when the loader completes loading
	loader.onComplete = start;
	loader.load();

	function start() {

	  drawMap(rowdata, size, WIDTH / 2, tileHeight * 1.5);

	  function animate() {
	     //requestAnimFrame(animate);
	     renderer.render(stage);
	  }

	  requestAnimFrame(animate);
	}
}