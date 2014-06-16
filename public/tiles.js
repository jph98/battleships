var WIDTH = 700;
var HEIGHT = 300;
var bgcolor = 0xffffff;
var stage = new PIXI.Stage(bgcolor);
var renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT);
document.body.appendChild(renderer.view);

var loader = new PIXI.AssetLoader(['tiles.json']);

// map
var S=0, W=1;
var terrain = [
    [S, S, S, S, W],
    [W, W, S, S, W],
    [W, S, S, W, W],
    [W, S, W, W, W],
    [W, S, W, W, W],
];

// Tiles with height can exceed these dimensions.
var tileHeight = 50;
var tileWidth = 50;

// tiles
var ship = isoTile('road.png');
var water = isoTile('water.png');

var tileMethods = [ship, water];

function isoTile(filename) {
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

function drawMap(terrain, xOffset, yOffset) {
    
    var tileType, x, y, isoX, isoY, idx;

    for (var i = 0, iL = terrain.length; i < iL; i++) {
        
        for (var j = 0, jL = terrain[i].length; j < jL; j++) {

            // cartesian 2D coordinate
            x = j * tileWidth;
            y = i * tileHeight;

            // iso coordinate
            isoX = x - y;
            isoY = (x + y) / 2;

            tileType = terrain[i][j];
            drawTile = tileMethods[tileType];
            drawTile(isoX + xOffset, isoY + yOffset);
        }
    }
}

loader.onComplete = start;
loader.load();

function start() {

  drawMap(terrain, WIDTH / 2, tileHeight * 1.5);

  function animate() {
    requestAnimFrame(animate);
    renderer.render(stage);
  }
  requestAnimFrame(animate);
}