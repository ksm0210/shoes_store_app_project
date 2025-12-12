
import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class OrderHandler {

  Future<List<Order>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from orders');

    return data.map((data)=>Order.fromMap(data)).toList();
  }

  // Future<List<Order>> selectQueryByProductId(int id) async {
  //   Database db = await Initialize.initDatabase();
  //   final data = await db.rawQuery("""
  //   select orders.*,product from orders 
  //   inner join products on orders.product_id = orders.product_id
  //   """
  // );

  //   return data.map((data)=>Order.fromMap(data)).toList();
  // }

  Future<int> insert(Order ord) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into orders( 
     
          customer_id,
          product_id,
          order_store_id,
          order_quantity,
          order_total_price,
          order_status,
          created_at
   ) values (?,?,?,?,?,?,?) 
      """,[
        ord.customer_id,
        ord.product_id,
        ord.order_store_id,
        ord.order_quantity,
        ord.order_total_price,
        ord.order_status,
        DateTime.now().toString()
      ]);
  }

  Future<int> update(Order ord) async {

    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        update orders set
     
          customer_id=?
          product_id=?,
          order_store_id=?,
          order_quantity=?,
          order_total_price=?,
          order_status=?
          where order_id=?
      """,[
        ord.customer_id,
        ord.product_id,
        ord.order_store_id,
        ord.order_quantity,
        ord.order_total_price,
        ord.order_status,
        ord.order_id
      ]);
    
  }
    
  
}