import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_logic.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class GameTheme {
  final Color backgroundColor;
  final Color gridColor;
  final String name;

  const GameTheme({
    required this.backgroundColor,
    required this.gridColor,
    required this.name,
  });
}

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
  Map<String, Offset> _positions = {};
  Direction? _lastDirection;
  
  Color _backgroundColor = const Color(0xFFFAF8EF);
  Color _gridColor = const Color(0xFFBBADA0);
  
  final List<GameTheme> _themes = const [
    GameTheme(
      name: 'Classique',
      backgroundColor: Color(0xFFFAF8EF),
      gridColor: Color(0xFFBBADA0),
    ),
    GameTheme(
      name: 'Sombre',
      backgroundColor: Color(0xFF37474F),
      gridColor: Color(0xFF455A64),
    ),
    GameTheme(
      name: 'Pastel',
      backgroundColor: Color(0xFFB5EAD7),
      gridColor: Color(0xFFC7F0E3),
    ),
  ];
  
  late GameTheme _currentTheme;
  
  bool _isDarkMode = false;
  
  final Color _darkBackgroundColor = const Color(0xFF37474F);
  final Color _darkGridColor = const Color(0xFF455A64);
  
  final List<Map<String, dynamic>> _darkThemes = [
    {
      'name': 'Sombre Classique',
      'background': Color(0xFF37474F),
      'grid': Color(0xFF455A64),
    },
    {
      'name': 'Sombre Bleu',
      'background': Color(0xFF1A237E),
      'grid': Color(0xFF283593),
    },
    {
      'name': 'Sombre Violet',
      'background': Color(0xFF4A148C),
      'grid': Color(0xFF6A1B9A),
    },
    {
      'name': 'Full Dark',
      'background': Colors.black,
      'grid': Color(0xFF1C1C1C),
    },
  ];
  
  @override
  void initState() {
    super.initState();
    game.newGame();
    _focusNode = FocusNode();
    _currentTheme = _themes[0];
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
    if (!game.canMove) return;
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _lastDirection = Direction.up;
          game.move(Direction.up);
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _lastDirection = Direction.down;
          game.move(Direction.down);
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          _lastDirection = Direction.left;
          game.move(Direction.left);
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          _lastDirection = Direction.right;
          game.move(Direction.right);
        });
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

  void _updateObjective(int newObjective) {
    setState(() {
      objective = newObjective;
      game.objective = newObjective;
      game.newGame();
    });
    Navigator.pop(context);
  }

  void _showObjectiveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Objective'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [16, 32, 64, 128, 256, 512, 1024, 2048, 4096].map((value) => 
              ListTile(
                title: Text('$value'),
                onTap: () => _updateObjective(value),
              ),
            ).toList(),
          ),
        );
      },
    );
  }

  Offset _getSlideOffset(int row, int col, Direction? direction) {
    if (direction == null) return Offset.zero;
    
    switch (direction) {
      case Direction.up:
        return Offset(0, 0.2);
      case Direction.down:
        return Offset(0, -0.2);
      case Direction.left:
        return Offset(0.2, 0);
      case Direction.right:
        return Offset(-0.2, 0);
      default:
        return Offset.zero;
    }
  }

  Future<Color?> showColorPicker({
    required BuildContext context,
    required Color initialColor,
  }) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une couleur'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (Color color) {
                initialColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(initialColor),
              child: const Text('OK'),
            ),
          ],
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
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: const Color(0xFF776E65),
          title: const Text('2048', style: TextStyle(color: Colors.white, fontSize: 28)),
          actions: [
            Row(
              children: [
                const Text('Dark mode', style: TextStyle(color: Colors.white)),
                Switch(
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(_isDarkMode ? 'Thèmes sombres' : 'Personnalisation'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _isDarkMode
                            ? _darkThemes.map((theme) => ListTile(
                                title: Text(theme['name']),
                                trailing: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: theme['background'],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _backgroundColor = theme['background'];
                                    _gridColor = theme['grid'];
                                  });
                                  Navigator.pop(context);
                                },
                              )).toList()
                            : [
                                ListTile(
                                  title: const Text('Couleur de fond'),
                                  trailing: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _backgroundColor,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onTap: () async {
                                    Color? color = await showColorPicker(
                                      context: context,
                                      initialColor: _backgroundColor,
                                    );
                                    if (color != null) {
                                      setState(() => _backgroundColor = color);
                                    }
                                  },
                                ),
                                ListTile(
                                  title: const Text('Couleur de la grille'),
                                  trailing: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _gridColor,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onTap: () async {
                                    Color? color = await showColorPicker(
                                      context: context,
                                      initialColor: _gridColor,
                                    );
                                    if (color != null) {
                                      setState(() => _gridColor = color);
                                    }
                                  },
                                ),
                              ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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
                      color: _gridColor,
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
                      color: _gridColor,
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
                color: _gridColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (!game.canMove) return;
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    setState(() {
                      _lastDirection = Direction.up;
                      game.move(Direction.up);
                    });
                  } else {
                    setState(() {
                      _lastDirection = Direction.down;
                      game.move(Direction.down);
                    });
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (!game.canMove) return;
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    setState(() {
                      _lastDirection = Direction.left;
                      game.move(Direction.left);
                    });
                  } else {
                    setState(() {
                      _lastDirection = Direction.right;
                      game.move(Direction.right);
                    });
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
                    
                    if (value == 0) {
                      return Container(
                        decoration: BoxDecoration(
                          color: getTileColor(0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: getTileColor(value),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 200),
                          tween: Tween<double>(begin: 0.5, end: 1),
                          builder: (context, double scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: value > 512 ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: getNumberColor(value),
                            ),
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
                  'Game Over! Moves: ${game.moves}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (game.won)
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'You Won! Moves: ${game.moves}',
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
