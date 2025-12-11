
import 'package:shoes_store_app_project/model/manufacture.dart';
import 'package:shoes_store_app_project/model/product_category.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ManufactureHandler {

  Future<List<Manufacture>> selectQuery() async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from manufactures');

    return data.map((data)=>Manufacture.fromMap(data)).toList();
  }
  /*
  manufacture_id INTEGER PRIMARY KEY AUTOINCREMENT,
          manufacture_name TEXT NOT NULL,
          manufacture_address TEXT,   
          manufacture_contact TEXT,
          business_number TEXT, 
          created_at TEXT NOT NULL
  */
  
  Future<int> insert(Manufacture man) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into manufactures( 
          manufacture_name,
          manufacture_address,
          manufacture_contact,
          business_number,
          created_at) values(?,?,?,?,?)
      """,[man.manufacture_name, man.manufacture_address,
      man.manufacture_contact,man.business_number, man.created_at.toString()
      ]);
  }
    Future<int> update(Manufacture man) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        update manufactures set 
          manufacture_name=?,
          manufacture_address=?,
          manufacture_contact=?,
          business_number=?
        where manufacture_id=?
      """,[man.manufacture_name, man.manufacture_address,
      man.manufacture_contact,man.business_number, man.manufacture_id
      ]);
  }

}