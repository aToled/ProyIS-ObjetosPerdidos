// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:collection';
import 'package:app_objetos_perdidos/utils/campus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportMapScreenArgs {
  Function placeCallback;
  Campus campus;

  ReportMapScreenArgs(this.placeCallback, this.campus);
}

class ReportMapScreen extends StatefulWidget {
  const ReportMapScreen({super.key});

  @override
  State<ReportMapScreen> createState() => _ReportMapScreenState();
}

class _ReportMapScreenState extends State<ReportMapScreen> {
  bool _showingNoInternetConnection = false;
  // 1. Centro de la universidad
  CameraPosition? _initialPosition;

  static final Map<Campus, Map<String, double>> _campusCoords = {
    Campus.concepcion: {
      "SW_LAT": -36.837222,
      "SW_LNG": -73.039100,
      "NE_LAT": -36.822500,
      "NE_LNG": -73.031700
    },
    Campus.chillan: {
      "SW_LAT": -36.599444,
      "SW_LNG": -72.088889,
      "NE_LAT": -36.593333,
      "NE_LNG": -72.078611
    },
    Campus.losAngeles: {
      "SW_LAT": -37.473056,
      "SW_LNG": -72.347500,
      "NE_LAT": -37.470556,
      "NE_LNG": -72.343889
    }
  };

  Function? _placeCallback;

  // 2. Almacena el marcador y el círculo
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  LatLng? _selectedPoint;

  // 3. Función que se llama al tocar el mapa
  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedPoint = tappedPoint;

      // 4. Crea el marcador en el punto tocado
      _markers = {
        Marker(
          markerId: const MarkerId('selected_point'),
          position: tappedPoint,
          infoWindow: const InfoWindow(
            title: 'Lugar estimado',
            snippet: 'El objeto se perdió por aquí',
          ),
        ),
      };

      // 5. Crea el círculo con radio de 100m
      _circles = {
        Circle(
          circleId: const CircleId('loss_radius'),
          center: tappedPoint,
          radius: 100, // <-- Radio en METROS
          fillColor: Colors.blue.withValues(alpha: 0.2), // Color de relleno
          strokeColor: Colors.blue, // Color del borde
          strokeWidth: 2, // Ancho del borde
        ),
      };
    });
  }

  void _showInternetConectionDialog() {
    if (_showingNoInternetConnection) {
      return;
    }
    _showingNoInternetConnection = true;
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _showingNoInternetConnection = false;
          }
        },
        child: AlertDialog(
          title: const Text("No tiene conexión WIFI"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 25),
              Icon(Icons.wifi_off, size: 50),
              const SizedBox(height: 25),
              Text("Por favor conectese a una red wifi."),
              const SizedBox(height: 25),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Aceptar"))],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
      .addPostFrameCallback((_) async {
        List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
        if (!connectivityResult.contains(ConnectivityResult.wifi)
            && !connectivityResult.contains(ConnectivityResult.mobile)) {
          _showInternetConectionDialog();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    ReportMapScreenArgs args = ModalRoute.of(context)!.settings.arguments as ReportMapScreenArgs;

    if (_initialPosition == null) {
      _placeCallback = args.placeCallback;

      double SW_LAT = _campusCoords[args.campus]!["SW_LAT"]!;
      double NE_LAT = _campusCoords[args.campus]!["NE_LAT"]!;
      double SW_LNG = _campusCoords[args.campus]!["SW_LNG"]!;
      double NE_LNG = _campusCoords[args.campus]!["NE_LNG"]!;

      _initialPosition = CameraPosition(
          target: LatLng((SW_LAT + NE_LAT) / 2, (SW_LNG + NE_LNG) / 2),
          zoom: 15.5,
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar objeto perdido'),
      ),
      body: GoogleMap(
        mapType: MapType.normal, // Puedes usar .satellite si prefieres
        initialCameraPosition: _initialPosition!,
        onTap: _handleMapTap, // <-- El evento clave
        markers: _markers,     // <-- Muestra el marcador
        circles: _circles,     // <-- Muestra el círculo
        // Restringe el movimiento de la cámara
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            southwest: LatLng(_campusCoords[args.campus]!["SW_LAT"]!, _campusCoords[args.campus]!["SW_LNG"]!), // Punto Suroeste
            northeast: LatLng(_campusCoords[args.campus]!["NE_LAT"]!, _campusCoords[args.campus]!["NE_LNG"]!), // Punto Noreste
          ),
        ),
        // Opcional: restringe el zoom
        minMaxZoomPreference: const MinMaxZoomPreference(
          16.0, // Nivel de zoom mínimo (para no alejarse mucho)
          19.0, // Nivel de zoom máximo (para no acercarse demasiado)
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aquí guardas _selectedPoint en tu base de datos
          if (_selectedPoint != null) {
            print('Punto seleccionado: $_selectedPoint');
            
            if (_placeCallback != null && _selectedPoint != null) {
              _placeCallback!(_selectedPoint!.latitude, _selectedPoint!.longitude);
            }
            
            // Cierra el mapa y devuelve la coordenada
            Navigator.pop(context, _selectedPoint); 
          }
        },
        label: const Text('Confirmar Ubicación'),
        icon: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}