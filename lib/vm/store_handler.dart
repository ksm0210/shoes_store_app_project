

import 'package:shoes_store_app_project/model/review.dart';
import 'package:shoes_store_app_project/model/store.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class StoreHandler {

  Future<List<Store>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select distinct * from stores');

    return data.map((data)=>Store.fromMap(data)).toList();
  }
  
  Future<int> insert(Store store) async {
    /*
    store_name TEXT NOT NULL,
          store_address TEXT,
          store_phone TEXT,
          store_zipcode TEXT,
          store_lat REAL, 
          store_lng REAL, 
          store_city TEXT,
          store_state TEXT,
          created_at TEXT NOT NULL
    */
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into stores( 
          store_name,
          store_address,
          store_phone,
          store_zipcode,
          store_lat,
          store_lng,
          store_city,
          store_state,
          created_at
   ) values (?,?,?,?,?,?,?,?,?) 
      """,[
        store.store_name,
        store.store_address,
        store.store_phone,
        store.store_zipcode,
        store.store_lat,
        store.store_lng,
        store.store_city,
        store.store_state,
        store.created_at.toString()
      ]
    );
  }

  
  Future<int> update(Store store) async {
    Database db = await Initialize.initDatabase();
    return await db.rawUpdate("""
        update stores set 
          store_name=?,
          store_address=?,
          store_phone=?,
          store_zipcode=?,
          store_lat=?,
          store_lng=?,
          store_city=?,
          store_state=?,
          created_at=?
        where store_id = ?
      """,[
        store.store_name,
        store.store_address,
        store.store_phone,
        store.store_zipcode,
        store.store_lat,
        store.store_lng,
        store.store_city,
        store.store_state,
        store.created_at.toString(),
        store.store_id
      ]
    );
  }



}