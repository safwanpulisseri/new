import 'package:hive/hive.dart';
part 'db_category.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String categoryName;

  @HiveField(1)
  final String categoryImagePath;

  CategoryModel({required this.categoryName, required this.categoryImagePath});
}
