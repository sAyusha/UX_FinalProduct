// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeHiveModelAdapter extends TypeAdapter<HomeHiveModel> {
  @override
  final int typeId = 1;

  @override
  HomeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeHiveModel(
      artId: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      creator: fields[3] as String,
      image: fields[4] as String,
      startingBid: fields[5] as num,
      endingDate: fields[6] as DateTime,
      artType: fields[7] as String,
      categories: fields[8] as String,
      isSaved: fields[9] as bool?,
      isAlert: fields[10] as bool?,
      upcomingDate: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HomeHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.artId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.creator)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.startingBid)
      ..writeByte(6)
      ..write(obj.endingDate)
      ..writeByte(7)
      ..write(obj.artType)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.isSaved)
      ..writeByte(10)
      ..write(obj.isAlert)
      ..writeByte(11)
      ..write(obj.upcomingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
