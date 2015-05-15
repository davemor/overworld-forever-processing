PImage [] tiles;
int NO_VALUE = -1;

class Map {
  // [y, x]
  int [][] cells;
  int w, h;

  Map(int w, int h) {
    cells = new int[h][w]; 
    this.w = w;
    this.h = h;  
    // all map cells are initalised to NO_VALUE
    for (int x=0; x < getWidth (); x++) {
      for (int y=0; y < getHeight (); y++) {
        cells[y][x] = NO_VALUE;
      }
    }
  }

  void set(int x, int y, int value) {
    cells[y][x] = value;
  }

  int getHeight() {
    return h;
  }
  int getWidth() {
    return w;
  }

  int get(int x, int y) {
    if (x < 0 || x >= w || y < 0 || y >= h) {
      return -1;
    } else {
      return cells[y][x];
    }
  }

  int size() {
    return getWidth() * getHeight();
  }

  int get(int idx) {
    if (idx < 0) { 
      return -1;
    }// accounts for mod of neg being positive
    int x = idx % getWidth();
    int y = idx / getWidth();
    return get(x, y);
  }

  void set(int idx, int value) {
    int x = idx % getWidth();
    int y = idx / getWidth();
    set(x, y, value);
  }

  void draw() {
    for (int x=0; x < getWidth (); x++) {
      for (int y=0; y < getHeight (); y++) {
        int index = get(x, y);
        if (index != NO_VALUE) {
          image(tiles[index], x * TILE_WIDTH, y * TILE_HEIGHT);
        }
      }
    }
  }
}

void loadTiles() {
  final int TILE_BORDER = 1;
  PImage tilesImg = loadImage("overworldtiles.png");
  int widthInTiles = 20; // padded
  int heightInTiles = tilesImg.height / TILE_HEIGHT;
  tiles = new PImage[widthInTiles * heightInTiles];
  for (int x = 0; x < widthInTiles; ++x) {
    for (int y = 0; y < heightInTiles; ++ y) {
      tiles[y * widthInTiles + x] = tilesImg.get(
      x * (TILE_WIDTH + TILE_BORDER) + TILE_BORDER, 
      y * (TILE_HEIGHT + TILE_BORDER) + TILE_BORDER, 
      TILE_WIDTH, TILE_HEIGHT);
    }
  }
  println("Tiles count: " + tiles.length);
}


void drawTiles() {
  for (int idx = 0; idx < tiles.length; ++idx) {
    image(tiles[idx], (idx % 19) * TILE_WIDTH, (idx / 19) * TILE_HEIGHT);
  }
}

Map loadMap() {
  Map rtn = new Map(256, 88);
  BufferedReader reader = createReader("nes_zelda_overworld_tile_map.txt");
  try {
    int y = 0;
    String strLine;
    while ( (strLine = reader.readLine ())!= null) {
      String [] tiles = strLine.split(" ");
      for (int x=0; x < tiles.length; ++x) {
        int index = Integer.decode("0x" + tiles[x]);
        rtn.set(x, y, index);
      }
      ++y;
    }
  } 
  catch(Exception e) {
    System.out.println(e);
  }
  return rtn;
}

