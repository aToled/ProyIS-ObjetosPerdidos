// ignore_for_file: constant_identifier_names

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportMapScreen extends StatefulWidget {
  const ReportMapScreen({super.key});

  @override
  State<ReportMapScreen> createState() => _ReportMapScreenState();
}

class _ReportMapScreenState extends State<ReportMapScreen> {
  // 1. Centro de la universidad
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng((SW_LAT + NE_LAT) / 2, (SW_LNG + NE_LNG) / 2),
    zoom: 15.5,
  );

  static const double SW_LAT = -36.837222;
  static const double SW_LNG = -73.036111;
  static const double NE_LAT = -36.822500;
  static const double NE_LNG = -73.031700;

  Function? _placeCallback;

  // 2. Almacena el marcador y el círculo
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  LatLng? _selectedPoint;

  // 3. Función que se llama al tocar el mapa
  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedPoint = tappedPoint;

      if (_placeCallback != null) {
        _placeCallback!(tappedPoint.latitude, tappedPoint.longitude);
      }

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

  @override
  Widget build(BuildContext context) {
    _placeCallback = ModalRoute.of(context)!.settings.arguments as Function;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar objeto perdido'),
      ),
      body: GoogleMap(
        mapType: MapType.normal, // Puedes usar .satellite si prefieres
        initialCameraPosition: _initialPosition,
        onTap: _handleMapTap, // <-- El evento clave
        markers: _markers,     // <-- Muestra el marcador
        circles: _circles,     // <-- Muestra el círculo
        // Restringe el movimiento de la cámara
        cameraTargetBounds: CameraTargetBounds(
          LatLngBounds(
            southwest: LatLng(SW_LAT, SW_LNG), // Punto Suroeste
            northeast: LatLng(NE_LAT, NE_LNG), // Punto Noreste
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