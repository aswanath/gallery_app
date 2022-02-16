import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'image_model.g.dart';

@HiveType(typeId:0)
class ImagePath extends HiveObject{
@HiveField(0)
  dynamic imagepath;
ImagePath({required this.imagepath});
}