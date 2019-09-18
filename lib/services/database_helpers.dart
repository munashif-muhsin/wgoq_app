import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wgoq_app/modals/post.dart';


  // final int id;
  // final DateTime date;
  // final String link;
  // final String title;
  // final String content;
  // final int authorId;
  // final int category;
  // final String thumbnail;

final String tablePosts = 'posts';
final String columnId = 'id';
final String columnDate = 'date';
final String columnLink = 'link';
final String columnTitle = 'title';
final String columnContent = 'content';
final String columnAuthorId = 'authorId';
final String columnCategory = 'category';
final String columnThumbnail = 'thumbnail';


class DatabaseHelper {

      // This is the actual database filename that is saved in the docs directory.
      static final _databaseName = "MyDatabase.db";
      // Increment this version when you need to change the schema.
      static final _databaseVersion = 1;

      // Make this a singleton class.
      DatabaseHelper._privateConstructor();
      static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

      // Only allow a single open connection to the database.
      static Database _database;
      Future<Database> get database async {
        if (_database != null) return _database;
        _database = await _initDatabase();
        return _database;
      }

      // open the database
      _initDatabase() async {
        // The path_provider plugin gets the right directory for Android or iOS.
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);
        // Open the database. Can also add an onUpdate callback parameter.
        return await openDatabase(path,
            version: _databaseVersion,
            onCreate: _onCreate);
      }

      // SQL string to create the database 
      Future _onCreate(Database db, int version) async {
        await db.execute('''CREATE TABLE $tablePosts (
                $columnId INTEGER PRIMARY KEY,
                $columnDate TEXT NOT NULL,
                $columnLink TEXT NOT NULL,
                $columnTitle TEXT NOT NULL,
                $columnContent TEXT NOT NULL,
                $columnAuthorId INTEGER NOT NULL,
                $columnCategory INTEGER NOT NULL,
                $columnThumbnail TEXT NOT NULL)
              ''');
      }

      // Database helper methods:

      Future<int> insert(Post post) async {
        Database db = await database;
        int id = await db.insert(tablePosts, post.toMap());
        return id;
      }

      Future<Post> queryPost(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tablePosts,
            columns: [
              columnId,
              columnDate,
              columnLink,
              columnTitle,
              columnContent,
              columnAuthorId,
              columnCategory,
              columnThumbnail,
            ],
            where: '$columnId = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
          return Post.fromMap(maps.first);
        }
        return null;
      }

      Future<List<Post>> queryAll() async {
        Database db = await database;
        List<Map> maps = await db.rawQuery('SELECT * FROM ' + tablePosts);
        if (maps.length > 0) {
          return maps.map((item) => Post.fromMap(item)).toList();
        }
        return null;
      }

      Future<bool> deleteWithId(int id) async {
        Database db = await database;
        try {
          await db.delete(tablePosts, where: '$columnId = ?', whereArgs: [id]);
          return true;
        } catch (e) {
          print(e);
          return false;
        }
      }
     }
