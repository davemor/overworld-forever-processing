import java.util.Map;

final int WIDTH_TILES = 16;
final int HEIGHT_TILES = 12;

final int TILE_WIDTH = 16; // px
final int TILE_HEIGHT = 16; // px

int numPredecessors = 64;

Camera cam;
Map map;

// state for different models 
FrequencyTable zeldaMapFrequencyTable;
HashMap<Integer, FrequencyTable> PredecessorTable;
HashMap<String, FrequencyTable> nPredecessorTables;
HashMap<String, FrequencyTable> upLeftTables;
HashMap<String, FrequencyTable> frequencyTablesForUpLeftN;

// Notes on Zelda Overworld Map
// world is 16 x 8 rooms, 256 x 88 tiles, 4096 x 1408 pixels
// rooms are 16 x 11 tiles, 256 x 176 pixels (but only the top half of the bottom row of tiles is shown on screen)
// tiles are 16 x 16 pixels

void setup() {
  //noSmooth();
  //size(256, 176);
  size(1024, 768);
  loadTiles();
  final Map zeldaMap = loadMap();
  zeldaMapFrequencyTable = countTileFrequencies(zeldaMap);
  PredecessorTable = makePredecessorFrequencyTables(zeldaMap);
  nPredecessorTables = makeFrequencyTablesForNLengthPredecessors(zeldaMap, numPredecessors);
  upLeftTables = makeFrequencyTablesForUpLeft(zeldaMap);
  map = zeldaMap;
  cam = new Camera();
}

void draw() {
  background(#DCF1FA);
  cam.update();
  cam.begin();
  map.draw();
  cam.end();
}

void keyPressed() {
  switch(key) {
    case '1':
      map = makeMapFromFrequencyTable(zeldaMapFrequencyTable, 256, 88);
      break;
    case '2':
      map = makeMapFromPredecessorFrequencyTables(PredecessorTable, 256, 88);
      break;
    case '3':
      map = makeMapFromNLengthPredecessorsTables(nPredecessorTables, 256, 88, numPredecessors);
      break;
    case '4':
      map = makeMapFromUpLeft(upLeftTables, PredecessorTable, 256, 88); // 16, 11
      break;
  } 
}








