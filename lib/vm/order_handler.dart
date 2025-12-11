import 'package:path/path.dart';
import 'package:simple_todo_list_app/model/todo_list.dart';
import 'package:sqflite/sqflite.dart';

enum TableName { todolist, todolist_deleted, todolist_alarm }

class DatabaseHandle {
  final int limitNum = 5;

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'todolists.db'),
      onCreate: (db, version) async {
        await db.execute("""
          create table todolist (
            id integer primary key autoincrement,
            title text,
            content text,
            isAlarm integer,
            importance integer not null default 5,
            startDate text,
            endDate text,
            isDeleted integer default 0
          )
        """);
        await db.execute("""
          create table todolist_alarm (
            id integer primary key,
            title text,
            content text,
            isAlarm integer,
            importance integer,
            startDate text,
            endDate text
            isDeleted integer default 0
          )
        """);

        await db.execute("""
          create table todolist_deleted (
            id integer primary key,
            title text,
            content text,
            isAlarm integer,
            importance integer,
            startDate text,
            endDate text
            isDeleted integer default 0
          )
        """);
      },
      version: 1,
    );
  }

  Future<List<TodoList>> getTodoList(Map<String, dynamic>? kwd, TableName tableName, int s) async {
    Database db = await initDatabase();
    List<Map<String, Object?>> queryResults = [];
    if (kwd == null) {
      // 전체리스트.
      // 조건 없이 전체 리스트
      queryResults = await db.rawQuery(
        """
        select * from ${tableName.name.toString()} order by startDate DESC limit ?,?
      
      """,
        [s, limitNum],
      );
    } else {
      if (kwd['id'] != null) {
        // 조건 없이 ID로

        queryResults = await db.rawQuery(
          """
          select * from ${tableName.name.toString()} where id=? order by startDate DESC limit ?,?
        """,
          [kwd['id'], s, limitNum],
        );
      } else if (kwd['name'] != null) {
        queryResults = await db.rawQuery(
          """
          select * from ${tableName.name.toString()} where title like ? or content like ? order by startDate DESC limit ?,?
        """,
          ['%${kwd["name"]}%', '%${kwd["name"]}%', s, limitNum],
        );
      } else if (kwd['isAlarm'] != null) {
        queryResults = await db.rawQuery(
          """
        select * from ${tableName.name.toString()} where isAlarm=? and isDeleted=0 order by startDate DESC limit ?,?
      
      """,
          [kwd['isAlarm'], s, limitNum],
        );
      } else if (kwd['startDate'] != null) {
        queryResults = await db.rawQuery(
          """
        select * from ${tableName.name.toString()} where startDate>=? order by startDate DESC limit ?,?
      
        """,
          [kwd['startDate'], s, limitNum],
        );
      } else if (kwd['importance'] != null) {
        queryResults = await db.rawQuery(
          """
        select * from ${tableName.name.toString()} where importance>5 and isDeleted=0 order by importance DESC,startDate DESC limit ?,?
      
        """,
          [s, limitNum],
        );
      } else if (kwd['today'] != null) {
        if (kwd['today']['n']) {
          print('=========HIT DATABASE ++++++++++ ${kwd['today']['datetime'].toString()}');
          queryResults = await db.rawQuery(
            """
          select * from ${tableName.name.toString()} where DATE(startDate)=DATE(?)  order by importance DESC,startDate DESC limit ?,?
        
          """,
            [kwd['today']['datetime'].toString(), s, limitNum],
          );
        }
      } else if (kwd['range'] != null) {
        queryResults = await db.rawQuery(
          """
        select * from ${tableName.name.toString()} where startDate>=? and startDate < ? order by startDate
      
        """,
          [kwd['range']['startDate'], kwd['range']['endDate']],
        );
      }
    }
    // if(queryResults.length>0)
    return queryResults.map((d) => TodoList.fromJson(d)).toList();
    // else
    //   return [];
  }

  Future<List<int>> getTodayReport(DateTime now) async {
    print(now.toString());
    Database db = await initDatabase();
    List<int> result = await db.transaction((tx) async {
      List<Map<String, Object?>> data = await tx.rawQuery("select count(*) as c from todolist_alarm where DATE(startDate)=DATE(?)", [now.toString()]);
      int todayAlarmCount = data[0]["c"] as int;

      data = await tx.rawQuery("select count(*) as c from todolist where importance>5 and DATE(startDate)=DATE(?)  and isDeleted=0", [
        now.toString(),
      ]);

      int todayImportanceCount = data[0]["c"] as int;

      data = await tx.rawQuery("select count(*) as c from todolist where DATE(startDate)=DATE(?)  and isDeleted=0", [now.toString()]);
      int todayCount = data[0]["c"] as int;
      data = await tx.rawQuery("select count(*) as c from todolist where importance>5 and isDeleted=0");
      int totalImportanceCount = data[0]["c"] as int;

      data = await tx.rawQuery("select count(*) as c from todolist_alarm");
      int totalAlarmCount = data[0]["c"] as int;

      return [todayAlarmCount, todayImportanceCount, todayCount, totalImportanceCount, totalAlarmCount];
    });

    return result;
  }

  Future<int> insertTodoList(TodoList todolist, TableName tableName) async {
    final Database db = await initDatabase();
    int result = 0;
    if (todolist.isAlarm == 1) {
      result = await db.transaction((tx) async {
        int seq = await tx.rawInsert(
          """
          insert into ${tableName.name}(title,content,importance,isAlarm,startDate,isDeleted) 
          values (?,?,?,?,?,?)
""",
          [todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString(), 0],
        );
        await tx.rawInsert(
          """
      insert into todolist_alarm(id,title,content,importance,isAlarm,startDate) values (?,?,?,?,?,?)
""",
          [seq, todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString()],
        );

        return seq;
      });
    } else {
      result = await db.rawInsert(
        """
      insert into ${tableName.name}(title,content,importance,isAlarm,startDate,isDeleted) 
      values (?,?,?,?,?,?)
    
""",
        [todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString(), 0],
      );
    }

    // int result = await db.rawInsert(
    //   """
    //   insert into ${tableName.name}(title,importance,isAlarm,startDate) values (?,?,?,?)

    // """,
    //   [
    //     todolist.title,
    //     todolist.importance,
    //     todolist.isAlarm,
    //     todolist.startDate.toString(),
    //   ],
    // );
    // if (result != 0 && todolist.isAlarm == 1) {
    //   result = await db.rawInsert(
    //     """
    //   insert into ${tableName.name}(id,title,importance,isAlarm,startDate) values (?,?,?,?,?)

    // """,
    //     [
    //       result,
    //       todolist.title,
    //       todolist.importance,
    //       todolist.isAlarm,
    //       todolist.startDate.toString(),
    //     ],
    //   );
    // }

    return result;
  }

  Future<int> updateTodoList(TodoList todolist, TableName tableName) async {
    Database db = await initDatabase();
    int result = 0;
    if (todolist.isAlarm == 1) {
      result = await db.transaction((tx) async {
        await tx.rawUpdate(
          """
      update ${tableName.name.toString()} set title=?,content=?,importance=?,isAlarm=?,startDate=?, isDeleted=0 where id=?
    
    """,
          [todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString(), todolist.id],
        );

        final d = await tx.rawQuery("select * from todolist_alarm where id=?", [todolist.id]);
        print('=== Check D: === ${d.length}');
        if (d.isNotEmpty && d.length > 0) {
          // Update
          await tx.rawUpdate(
            """
            update todolist_alarm set title=?,content=?,importance=?,isAlarm=?,startDate=? where id=?
          
          """,
            [todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString(), todolist.id],
          );
        } else {
          // 지워져서 추가해야 한다
          await tx.rawInsert(
            """
                insert into todolist_alarm(id,title,content,importance,isAlarm,startDate) values (?,?,?,?,?,?)
          """,
            [todolist.id, todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString()],
          );
        }

        return todolist.id!;
      });
    } else {
      result = await db.transaction((tx) async {
        int r = await tx.rawUpdate(
          """
          update ${tableName.name.toString()} set title=?,content=?,importance=?,isAlarm=?,startDate=?,isDeleted=0 where id=?
        
        """,
          [todolist.title, todolist.content, todolist.importance, todolist.isAlarm, todolist.startDate.toString(), todolist.id],
        );
        if (r != 0) {
          await tx.rawDelete('delete from todolist_alarm where id=?', [todolist.id]);
        }
        return r;
      });
    }
    return result;
  }

  Future<int> toggleAlarm(TodoList todolist) async {
    int result = 0;
    Database db = await initDatabase();
    if (todolist.isAlarm == 0) {
      int value = 1;

      result = await db.transaction((tx) async {
        int r = await tx.rawUpdate('update todolist set isAlarm=? where id=?', [value, todolist.id]);

        if (r != 0) {
          final d = await tx.rawQuery("select * from todolist_alarm where id=?", [todolist.id]);
          print('=== Check D: === ${d.length}');
          if (d.isNotEmpty && d.length > 0) {
            // update
            r = await tx.rawUpdate('update todolist set isAlarm=? where id=?', [value, todolist.id]);
          } else {
            r = await tx.rawInsert(
              """
                  insert into todolist_alarm(id,title,content,importance,isAlarm,startDate) values (?,?,?,?,?,?)
            """,
              [todolist.id, todolist.title, todolist.content, todolist.importance, value, todolist.startDate.toString()],
            );
          }
        }
        return r;
      });
    } else {
      int value = 0;
      result = await db.transaction((tx) async {
        int r = await tx.rawUpdate('update todolist set isAlarm=? where id=?', [value, todolist.id]);

        if (r != 0) {
          await tx.rawDelete('delete from todolist_alarm where id=?', [todolist.id]);
        }
        return r;
      });
    }
    return result;
  }

  // 소프트 제거
  Future<int> deleteSoft(int id) async {
    int result = 0;
    Database db = await initDatabase();
    try {
      result = await db.transaction((tx) async {
        await tx.rawUpdate('update todolist set isDeleted=1 where id=?', [id]);
        await tx.rawDelete("delete from todolist_alarm where id=?", [id]);
        return 100;
      });
    } catch (err) {
      print('== DB: SoftDELETE ERROR ${err.toString()}');
      result = 0;
    }
    return result;
  }

  // 완전 제거
  Future<int> deleteTodoList(int id) async {
    int result = 0;
    try {
      Database db = await initDatabase();

      // Get ID
      List<TodoList> d = await getTodoList({"id": id}, TableName.todolist, 0);

      result = await db.transaction((tx) async {
        await tx.rawDelete("delete from todolist where id=?", [id]);
        await tx.rawInsert("insert into todolist_deleted(id,title,startDate) values (?,?,?)", [d[0].id, d[0].title, d[0].startDate.toString()]);
        await tx.rawDelete("delete from todolist_alarm where id=?", [id]);
        return 100;
      });

      return result;
    } catch (err) {
      return 0;
    }
  }

  // 알람 제거
  Future<int> deleteAalarm(int id) async {
    Database db = await initDatabase();

    int result = 0;
    result = await db.transaction((tx) async {
      int r = await tx.rawDelete("delete from todolist_alarm where id=?", [id]);
      r = await tx.rawDelete("update todolist set isAlarm=0, isDeleted=1 where id=?", [id]);
      return r;
    });
    return result;
  }
}
