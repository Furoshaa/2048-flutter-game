import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final Game2048 game = Game2048();
  int objective = 2048;
  late FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    game.newGame();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color getTileColor(int value) {
    switch (value) {
      case 2: return const Color(0xFFEEE4DA);
      case 4: return const Color(0xFFEDE0C8);
      case 8: return const Color(0xFFF2B179);
      case 16: return const Color(0xFFF59563);
      case 32: return const Color(0xFFF67C5F);
      case 64: return const Color(0xFFF65E3B);
      case 128: return const Color(0xFFEDCF72);
      case 256: return const Color(0xFFEDCC61);
      case 512: return const Color(0xFFEDC850);
      case 1024: return const Color(0xFFEDC53F);
      case 2048: return const Color(0xFFEDC22E);
      case 4096: return const Color(0xFF3C3A32);
      default: return const Color(0xFFCDC1B4);
    }
  }

  Color getNumberColor(int value) {
    return value <= 4 ? const Color(0xFF776E65) : Colors.white;
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() => game.move(Direction.up));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() => game.move(Direction.down));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() => game.move(Direction.left));
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() => game.move(Direction.right));
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text('Developed by Kyllian and Remi'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showObjectiveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Objective'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('16'),
                onTap: () {
                  setState(() => objective = 16);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('32'),
                onTap: () {
                  setState(() => objective = 32);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('64'),
                onTap: () {
                  setState(() => objective = 64);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('128'),
                onTap: () {
                  setState(() => objective = 128);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('256'),
                onTap: () {
                  setState(() => objective = 256);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('512'),
                onTap: () {
                  setState(() => objective = 512);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('1024'),
                onTap: () {
                  setState(() => objective = 1024);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('2048'),
                onTap: () {
                  setState(() => objective = 2048);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('4096'),
                onTap: () {
                  setState(() => objective = 4096);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF8EF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF776E65),
          title: const Text('2048', style: TextStyle(color: Colors.white, fontSize: 28)),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showAboutDialog,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBADA0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        const Text('MOVES',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          '${game.moves}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBADA0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        const Text('OBJECTIVE',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          '$objective',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFBBADA0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    setState(() => game.move(Direction.up));
                  } else {
                    setState(() => game.move(Direction.down));
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    setState(() => game.move(Direction.left));
                  } else {
                    setState(() => game.move(Direction.right));
                  }
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    int row = index ~/ 4;
                    int col = index % 4;
                    int value = game.board[row][col];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: getTileColor(value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          value == 0 ? '' : value.toString(),
                          style: TextStyle(
                            fontSize: value > 512 ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: getNumberColor(value),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => game.newGame()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7A66),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'New Game',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _showObjectiveDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7A66),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Change Objective',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
            if (game.gameOver)
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Game Over! Final Score: ${game.moves}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
