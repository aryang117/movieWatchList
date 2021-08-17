import 'package:hive/hive.dart';

part 'movieDB.g.dart';

@HiveType(typeId: 1)
class MovieDB {
  @HiveField(0)
  final String movieName;
  @HiveField(1)
  final String directorName;
  @HiveField(2)
  final String posterLink;

  const MovieDB(this.movieName, this.directorName, this.posterLink);
}
