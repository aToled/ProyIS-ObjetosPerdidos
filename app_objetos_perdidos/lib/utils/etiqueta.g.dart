// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etiqueta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EtiquetaAdapter extends TypeAdapter<Etiqueta> {
  @override
  final int typeId = 3;

  @override
  Etiqueta read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Etiqueta.celular;
      case 1:
        return Etiqueta.llaves;
      case 2:
        return Etiqueta.cartera;
      case 3:
        return Etiqueta.billetera;
      case 4:
        return Etiqueta.utiles;
      case 5:
        return Etiqueta.documento;
      case 6:
        return Etiqueta.lentes;
      case 7:
        return Etiqueta.botella;
      case 8:
        return Etiqueta.otro;
      default:
        return Etiqueta.celular;
    }
  }

  @override
  void write(BinaryWriter writer, Etiqueta obj) {
    switch (obj) {
      case Etiqueta.celular:
        writer.writeByte(0);
        break;
      case Etiqueta.llaves:
        writer.writeByte(1);
        break;
      case Etiqueta.cartera:
        writer.writeByte(2);
        break;
      case Etiqueta.billetera:
        writer.writeByte(3);
        break;
      case Etiqueta.utiles:
        writer.writeByte(4);
        break;
      case Etiqueta.documento:
        writer.writeByte(5);
        break;
      case Etiqueta.lentes:
        writer.writeByte(6);
        break;
      case Etiqueta.botella:
        writer.writeByte(7);
        break;
      case Etiqueta.otro:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EtiquetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
