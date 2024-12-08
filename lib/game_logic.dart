import 'dart:math';

class Game2048 {
  List<List<int>> board;
  int moves = 0;
  bool gameOver = false;
  Random random = Random();

  Game2048() : board = List.generate(4, (_) => List.filled(4, 0));

  void newGame() {
    board = List.generate(4, (_) => List.filled(4, 0));
    moves = 0;
    gameOver = false;
    addNewTile();
    addNewTile();
  }

  void addNewTile() {
    List<List<int>> emptyTiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyTiles.add([i, j]);
        }
      }
    }

    if (emptyTiles.isEmpty) return;

    final position = emptyTiles[random.nextInt(emptyTiles.length)];
    board[position[0]][position[1]] = random.nextInt(10) < 9 ? 2 : 4;
  }

  bool move(Direction direction) {
    bool moved = false;
    
    switch (direction) {
      case Direction.up:
        moved = moveUp();
        break;
      case Direction.down:
        moved = moveDown();
        break;
      case Direction.left:
        moved = moveLeft();
        break;
      case Direction.right:
        moved = moveRight();
        break;
    }

    if (moved) {
      moves++;
      addNewTile();
      checkGameOver();
    }

    return moved;
  }

  bool moveLeft() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i].where((x) => x != 0).toList();
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          moved = true;
          row.removeAt(j + 1);
        }
      }
      while (row.length < 4) {
        row.add(0);
      }
      if (row != board[i]) moved = true;
      board[i] = row;
    }
    return moved;
  }

  bool moveRight() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i].where((x) => x != 0).toList();
      for (int j = row.length - 1; j > 0; j--) {
        if (row[j] == row[j - 1]) {
          row[j] *= 2;
          moved = true;
          row.removeAt(j - 1);
        }
      }
      while (row.length < 4) {
        row.insert(0, 0);
      }
      if (row != board[i]) moved = true;
      board[i] = row;
    }
    return moved;
  }

  bool moveUp() {
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> column = [];
      for (int i = 0; i < 4; i++) {
        if (board[i][j] != 0) column.add(board[i][j]);
      }
      for (int i = 0; i < column.length - 1; i++) {
        if (column[i] == column[i + 1]) {
          column[i] *= 2;
          moved = true;
          column.removeAt(i + 1);
        }
      }
      while (column.length < 4) {
        column.add(0);
      }
      for (int i = 0; i < 4; i++) {
        if (board[i][j] != column[i]) moved = true;
        board[i][j] = column[i];
      }
    }
    return moved;
  }

  bool moveDown() {
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> column = [];
      for (int i = 0; i < 4; i++) {
        if (board[i][j] != 0) column.add(board[i][j]);
      }
      for (int i = column.length - 1; i > 0; i--) {
        if (column[i] == column[i - 1]) {
          column[i] *= 2;
          moved = true;
          column.removeAt(i - 1);
        }
      }
      while (column.length < 4) {
        column.insert(0, 0);
      }
      for (int i = 0; i < 4; i++) {
        if (board[i][j] != column[i]) moved = true;
        board[i][j] = column[i];
      }
    }
    return moved;
  }

  void checkGameOver() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) return;
        if (i < 3 && board[i][j] == board[i + 1][j]) return;
        if (j < 3 && board[i][j] == board[i][j + 1]) return;
      }
    }
    gameOver = true;
  }
}

enum Direction { up, down, left, right } 