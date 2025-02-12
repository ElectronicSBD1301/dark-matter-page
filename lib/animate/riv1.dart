import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'dart:async';

class LearningRiveWidget extends StatelessWidget {
  const LearningRiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight - 70;
        width = height * (16 / 9); // Mantiene una relación de aspecto 16:9
        return _LearningRiveWidget(width: width, height: height);
      },
    );
  }
}

class _LearningRiveWidget extends StatefulWidget {
  final double width;
  final double height;

  const _LearningRiveWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _LearningRiveWidgetState createState() => _LearningRiveWidgetState();
}

class _LearningRiveWidgetState extends State<_LearningRiveWidget> {
  Artboard? _artboard;
  SMIInput<double>? _positionInput;
  SMITrigger? _dropTrigger;
  SMIBool? _pickedBool;
  bool _isRunningSequence = false;
  int _currentPositionIndex = 0;

  // Mapeo de posiciones en el lienzo
  final List<double> _positions = [0.0, 1.0, 2.0, 3.0, 4.0];

  @override
  void initState() {
    super.initState();
    _initializeRive();
  }

  Future<void> _initializeRive() async {
    await RiveFile.initialize();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/animate/learning.riv');
    final file = RiveFile.import(bytes);
    final artboard = file.artboardByName('Drag and Drop');
    if (artboard != null) {
      final controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        _positionInput =
            controller.findInput<double>('Position') as SMIInput<double>?;
        _dropTrigger = controller.findInput<bool>('Drop Dude') as SMITrigger?;
        _pickedBool = controller.findInput<bool>('Dude Picked') as SMIBool?;
      }
      setState(() => _artboard = artboard);
    }
  }

  void _startSequence() {
    if (_isRunningSequence) return;
    _isRunningSequence = true;
    _runSequence();
  }

  Future<void> _runSequence() async {
    while (_isRunningSequence) {
      _setPicked(true);
      await Future.delayed(Duration(seconds: 1));
      _setPosition(_positions[_currentPositionIndex]);
      await Future.delayed(Duration(seconds: 1));
      _dropDude();
      await Future.delayed(Duration(seconds: 2));

      // Mantiene la posición actual hasta que se inicie el siguiente movimiento
      if (_currentPositionIndex < _positions.length - 1) {
        _currentPositionIndex++;
      } else {
        _isRunningSequence = false;
      }
    }
  }

  void _setPosition(double position) {
    setState(() {
      _positionInput?.value = position;
    });
  }

  void _setPicked(bool picked) {
    setState(() {
      _pickedBool?.value = picked;
    });
  }

  void _dropDude() {
    setState(() {
      _dropTrigger?.fire();
      _setPicked(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            child: Stack(
              children: [
                if (_artboard != null)
                  Center(
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: Rive(
                        artboard: _artboard!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: _startSequence, child: Text("Start Sequence")),
          ],
        ),
      ],
    );
  }
}
