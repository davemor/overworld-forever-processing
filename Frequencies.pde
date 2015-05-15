import java.util.Collections;
import java.util.Random;

class FrequencyTable {
  ArrayList<Integer> arr = new ArrayList<Integer>();

  void incromentCount(Integer tileIdx) {
    arr.add(tileIdx);
  }
  int sample() {
    int index = int(random(arr.size()));
    return arr.get(index);
  }
}

FrequencyTable countTileFrequencies(Map map) {
  FrequencyTable table = new FrequencyTable();
  for(int idx=0; idx < map.size(); ++idx) {
    table.incromentCount( map.get(idx) ); 
  }
  return table;
}

Map makeMapFromFrequencyTable(FrequencyTable table, int w, int h) {
  Map map = new Map(w, h);
  for(int idx=0; idx < map.size(); ++idx) {
    int value = table.sample();
    map.set(idx, value);
  }
  return map;
}

HashMap<Integer, FrequencyTable> makePredecessorFrequencyTables(Map map) {
  FrequencyTable unconstrainedTable = countTileFrequencies(map);
  HashMap<Integer, FrequencyTable> table = new HashMap<Integer, FrequencyTable>();
  table.put(-1, unconstrainedTable); // -1 is the index of unconstrained tile
  for (int idx=0; idx < map.size() - 1; ++idx) {
    int curr = map.get(idx);
    int next = map.get(idx+1);
    if (table.containsKey(curr)) {
      table.get(curr).incromentCount(next);
    } else {
      FrequencyTable ft = new FrequencyTable();
      ft.incromentCount(next);
      table.put(curr, ft);
    }
  }
  return table;
}

Map makeMapFromPredecessorFrequencyTables(HashMap<Integer, FrequencyTable> tables, int w, int h) {
  Map map = new Map(w, h);
  int curr = -1;
  for (int idx=0; idx < map.size(); ++idx) {
    int next = tables.get(curr).sample();
    map.set(idx, next);
    curr = next;
  }
  return map;
}

HashMap<String, FrequencyTable> makeFrequencyTablesForNLengthPredecessors(Map map, int n) {
  HashMap<String, FrequencyTable> table = new HashMap<String, FrequencyTable>();
  for (int idx=0; idx < map.size(); ++idx) {
    ArrayList<Integer> predecessors = new ArrayList<Integer>();
    for(int p=0; p < n; ++p) {
       int backIdx = idx - (p + 1);
       predecessors.add(map.get(backIdx));
    }
    int curr = map.get(idx);
    String keyStr = listToString(predecessors);
    if (table.containsKey(keyStr)) {
      table.get(keyStr).incromentCount(curr);
    } else {
      FrequencyTable ft = new FrequencyTable();
      ft.incromentCount(curr);
      table.put(keyStr, ft);
    }
  }
  return table;
}

Map makeMapFromNLengthPredecessorsTables(HashMap<String, FrequencyTable> tables, int w, int h, int n) {
  Map map = new Map(w, h);
  for (int idx=0; idx < map.size(); ++idx) {
    ArrayList<Integer> predecessors = new ArrayList<Integer>();
    for(int p=0; p < n; ++p) {
       int backIdx = idx - (p + 1);
       predecessors.add(map.get(backIdx));
    }
    String keyStr = listToString(predecessors);
    int next = NO_VALUE;
    if (tables.containsKey(keyStr)) {
      next = tables.get(keyStr).sample(); 
    } else {
      println("Could not match predecessor pattern: " + keyStr); 
    }
    map.set(idx, next);
  }
  return map;
}

String listToString(ArrayList<Integer> list) {
  String str = "";
  for (Integer i : list) {
    str = str + i + " ";
  }
  return str;
}

HashMap<String, FrequencyTable> makeFrequencyTablesForUpLeft(Map map) {
  HashMap<String, FrequencyTable> tables = new HashMap<String, FrequencyTable>();
  for (int x = 0; x < map.getWidth(); ++x) {
    for (int y = 0; y < map.getHeight(); ++ y) {
      int curr = map.get(x, y);
      int up = map.get(x, y - 1);
      int left = map.get(x - 1, y);
      String keyStr = "" + up + " " + left;
      // println("pattern: " + keyStr + " = " + curr);
      if (tables.containsKey(keyStr)) {
        tables.get(keyStr).incromentCount(curr);
      } else {
        FrequencyTable ft = new FrequencyTable();
        ft.incromentCount(curr);
        tables.put(keyStr, ft);
      }
    }
  } 
  return tables;
}

Map makeMapFromUpLeft(HashMap<String, FrequencyTable> tables, HashMap<Integer, FrequencyTable> fallbackTable, int w, int h) {
  Map map = new Map(w, h);
  for (int x = 0; x < map.getWidth(); ++x) {
    for (int y = 0; y < map.getHeight(); ++ y) {
      int up = map.get(x, y - 1);
      int left = map.get(x - 1, y);
      String keyStr = "" + up + " " + left;
      int next = NO_VALUE;
      if (tables.containsKey(keyStr)) {
        next = tables.get(keyStr).sample(); 
      } else {
        println("Could not match up left pattern: " + keyStr);
        println("As a fallback we copy the left tile.");
        next = fallbackTable.get(left).sample();
      }
      map.set(x, y, next);
    }
  }
  return map;
}
