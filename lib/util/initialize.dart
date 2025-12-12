import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Initialize {

  static Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoesproject.db'),

      onCreate: (db, version) async {
        // == Product table
        await db.execute("""
          create table products (
            product_id integer primary key autoincrement,
            category_id integer not null,
            manufacture_id integer not null,
            store_id integer not null,
            product_name text,
            product_description text,
            gender text,
            product_color text,
            product_size integer,
            product_price integer,
            product_quantity integer,
            product_released_date text,
            created_at text
          )
        """);
        // customer table

        await db.execute("""

          CREATE TABLE Customers (
            customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_password TEXT NOT NULL,
            customer_name TEXT NOT NULL,
            customer_email TEXT NOT NULL, 
            customer_lat REAL,  
            customer_lng REAL,   
            customer_city TEXT,  
            customer_state TEXT, 
            created_at TEXT NOT NULL
          )
        """);

        // employee table
        await db.execute("""
        CREATE TABLE Employees (
          employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
          employee_password TEXT NOT NULL,
          employee_type TEXT NOT NULL,
          employee_name TEXT NOT NULL,
          employee_address TEXT,
          employee_email TEXT, 
          employee_phone TEXT, 
          manager_id INTEGER, 
          created_at TEXT NOT NULL
        )
        """);

        // store table
        await db.execute("""
        CREATE TABLE Store (
          store_id INTEGER PRIMARY KEY AUTOINCREMENT,
          store_name TEXT NOT NULL,
          store_address TEXT,
          store_phone TEXT,
          store_zipcode TEXT,
          store_lat REAL, 
          store_lng REAL, 
          store_city TEXT,
          store_state TEXT,
          created_at TEXT NOT NULL
        )
        """);

        // manufactures table
        await db.execute("""
         CREATE TABLE Manufactures (
          manufacture_id INTEGER PRIMARY KEY AUTOINCREMENT,
          manufacture_name TEXT NOT NULL,
          manufacture_address TEXT,   
          manufacture_contact TEXT,
          business_number TEXT, 
          created_at TEXT NOT NULL
        )
        """);

        // orders table
        await db.execute("""
        CREATE TABLE Orders (
          order_id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          order_store_id INTEGER NOT NULL,
          order_quantity INTEGER NOT NULL,
          order_total_price INTEGER NOT NULL,
          order_status TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
        """);

        /*
        -- 외래 키 제약 조건 (선택 사항, 필요시 추가)
          -- FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
          -- FOREIGN KEY (product_id) REFERENCES Products(product_id),
          -- FOREIGN KEY (order_store_id) REFERENCES Stores(store_id)
        */

        // orderreceives table
        await db.execute("""
        CREATE TABLE OrderReceives (
          seq INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER NOT NULL,
          customer_id INTEGER NOT NULL,
          employee_id INTEGER,          -- Nullable (NOT NULL 없음)
          product_id INTEGER NOT NULL,
          order_store_id INTEGER NOT NULL,
          order_quantity INTEGER NOT NULL,
          order_total_price INTEGER NOT NULL,
          order_status TEXT NOT NULL,
          order_created_at TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
        """);
        /*
  -- FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  -- FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  -- FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
  -- FOREIGN KEY (product_id) REFERENCES Products(product_id),
  -- FOREIGN KEY (order_store_id) REFERENCES Stores(store_id)
        */

        // orderreturns table
        await db.execute("""
        CREATE TABLE OrderReturns (
        seq INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        customer_id INTEGER NOT NULL,
        employee_id INTEGER,          -- Nullable (NOT NULL 없음)
        product_id INTEGER NOT NULL,
        order_store_id INTEGER NOT NULL,
        order_quantity INTEGER NOT NULL,
        order_total_price INTEGER NOT NULL,
        order_status TEXT NOT NULL,   -- 반품 요청, 반품 수거중, 반품 완료 등
        order_created_at TEXT NOT NULL,
        created_at TEXT NOT NULL
  )
        """);

        // productcategories table
        await db.execute("""
       CREATE TABLE ProductCategories (
          category_id INTEGER PRIMARY KEY AUTOINCREMENT,
          category_name TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
        """);

        // reviews table
        await db.execute("""
        CREATE TABLE Reviews (
          review_id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          review_rating INTEGER NOT NULL, 
          review_content TEXT,            
          created_at TEXT NOT NULL,

          FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
          FOREIGN KEY (product_id) REFERENCES Products(product_id)
        )
        """);

        // shoppingcarts table
        await db.execute("""      
        CREATE TABLE ShoppingCarts (
          cart_seq_id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          created_at TEXT NOT NULL
        )
        """);

        // wishes table
        await db.execute("""
        CREATE TABLE Wishes (
          wish_id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          UNIQUE(customer_id, product_id)
        )
        """);
      },
      version: 1,
    );
  }
}
