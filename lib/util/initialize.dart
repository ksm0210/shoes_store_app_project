
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Initialize {

  createDatabase() async {
Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoesproject.db'),

      
      onCreate: (db, version) async {
        // == Product table
        await db.execute("""
          create table product (
            product_id integer primary key autoincrement,
            product_name text,
            product_description text,
            gender text,
            product_color text,
            product_size integer,
            product_price integer,
            product_quantity integer,
            product_released_date text,
            created_at text,
            endDate text,
            isDeleted integer default 0
          )
        """);
        // customer table
        
        await db.execute("""
          CREATE TABLE Customers (
            customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_password TEXT NOT NULL,
            customer_name TEXT NOT NULL,
            customer_email TEXT,
            customer_lat real,
            customer_lng real,
            customer_city TEXT,
            customer_state TEXT,
            created_at TEXT NOT NULL
          )
        """);

        await db.execute("""
         CREATE TABLE Employees (
  employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
  employee_password TEXT NOT NULL,
  employee_type TEXT NOT NULL,
  employee_name TEXT NOT NULL,
  employee_address TEXT,
  employee_email TEXT,
  employee_phone TEXT,
  manager_id TEXT NOT NULL, -- manager_id의 Dart 타입이 String이므로 TEXT로 지정합니다.
  created_at TEXT NOT NULL
)
        """);
      },
      version: 1,
    );
  }

  }

}