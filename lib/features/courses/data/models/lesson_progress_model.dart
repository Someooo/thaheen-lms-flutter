import 'package:hive/hive.dart';

class LessonProgressModel {
  final String lessonId;
  final int position;
  final bool completed;

  const LessonProgressModel({
    required this.lessonId,
    required this.position,
    required this.completed,
  });

  LessonProgressModel copyWith({
    String? lessonId,
    int? position,
    bool? completed,
  }) {
    return LessonProgressModel(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      completed: completed ?? this.completed,
    );
  }
}

class LessonProgressModelAdapter extends TypeAdapter<LessonProgressModel> {
  @override
  final int typeId = 0;

  @override
  LessonProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonProgressModel(
      lessonId: fields[0] as String,
      position: fields[1] as int,
      completed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LessonProgressModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lessonId)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
