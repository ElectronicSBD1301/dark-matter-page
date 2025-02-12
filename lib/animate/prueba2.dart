import 'dart:async';
import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:flutter_gl/flutter_gl.dart';
import 'dart:html' as html;

// 📌 Widget del Anillo 3D en Flutter
class Rotating3DRing extends StatefulWidget {
  @override
  _Rotating3DRingState createState() => _Rotating3DRingState();
}

class _Rotating3DRingState extends State<Rotating3DRing> {
  late FlutterGlPlugin flutterGl;
  late three.Scene scene;
  late three.PerspectiveCamera camera;
  late three.WebGLRenderer renderer;
  late three.Mesh torus;
  late three.PointLight pointLight;
  late Timer timer;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initWebGL();
  }

  Future<void> _initWebGL() async {
    flutterGl = FlutterGlPlugin();
    await flutterGl.initialize(
      options: {
        "antialias": true,
        "alpha": true,
      },
    );

    renderer = three.WebGLRenderer({
      "canvas": flutterGl.element,
      "alpha": true,
      "antialias": true,
    });

    _initThreeDartScene();
    isInitialized = true;

    // Inicia la animación
    timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _animate();
    });

    setState(() {});
  }

  void _initThreeDartScene() {
    scene = three.Scene();

    // 📌 Cámara con valores seguros para evitar `toDouble()` en null
    camera = three.PerspectiveCamera(45, 1, 0.1, 1000);
    camera.position.set(0, 0, 5);
    if (camera.position.x.isNaN) {
      camera.position.set(0.0, 0.0, 5.0);
    }

    scene.add(camera);

    // 🔹 Creación del Anillo 3D
    var torusGeometry = three.TorusGeometry(1.2, 0.3, 30, 100);
    var torusMaterial = three.MeshStandardMaterial({
      "color": 0xff44ff,
      "emissive": 0x4422ff,
      "metalness": 0.8,
      "roughness": 0.3,
    });

    torus = three.Mesh(torusGeometry, torusMaterial);
    scene.add(torus);

    // 🔹 Luces para realismo
    pointLight = three.PointLight(0xffffff, 1.5);
    pointLight.position.set(2, 2, 3);
    scene.add(pointLight);
    scene.add(three.AmbientLight(0x404040));
  }

  void _animate() {
    if (!isInitialized) return;

    torus.rotation.x += 0.02; // Rotación en X (torsión)
    torus.rotation.y += 0.05; // Rotación en Y
    torus.rotation.z += 0.02; // Rotación en Z (efecto ondulado)

    renderer.render(scene, camera);
  }

  @override
  void dispose() {
    timer.cancel();
    flutterGl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isInitialized
        ? HtmlElementView(
            viewType: flutterGl.textureId!
                .toString()) // 🔹 FIX: Convert int to String
        : const Center(child: CircularProgressIndicator());
  }
}
