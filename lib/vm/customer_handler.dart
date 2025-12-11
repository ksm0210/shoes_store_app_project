
import 'package:shoes_store_app_project/model/customer.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class CustomerHandler {

  Future<List<Customer>> selectQuery() async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from customers');

    return data.map((data)=>Customer.fromMap(data)).toList();
  }

  
  Future<int> insert(Customer cust) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into customers( 
    customer_password,customer_name,
    customer_email,customer_city,
    customer_state,customer_lat,
    customer_lng,created_at) values (?,?,?,?,?,?,?,?) 
      """,[cust.customer_password,
      cust.customer_name,
      cust.customer_email,
      cust.customer_city,
      cust.customer_state,
      cust.customer_lat,
      cust.customer_lng,
      cust.created_at.toString()
      ]);
  }

  Future<int> update(Customer cust) async {
    Database db = await Initialize.initDatabase();
    return await db.rawUpdate("""
        update customers set 
   customer_password=?,customer_name=?,
    customer_email=?,customer_city=?,
    customer_state=?,customer_lat=?,
    customer_lng=? where customer_id=? 
      """,[cust.customer_password,
      cust.customer_name,
      cust.customer_email,
      cust.customer_city,
      cust.customer_state,
      cust.customer_lat,
      cust.customer_lng,
      cust.customer_id
      ]);
  }
}