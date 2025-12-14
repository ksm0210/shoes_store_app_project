import 'package:shoes_store_app_project/model/order.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class OrderHandler {
  // 주문목록 가져오기
  Future<List<Order>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from orders');

    return data.map((data) => Order.fromMap(data)).toList();
  }

  // customer 주문내역 Query
  Future<List<Order>> selectQueryByCustomerId(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery(
      """
      select o.*, p.product_name, p.product_size, s.store_name, p.mainImageUrl as product_mainImageUrl
      from orders as o 
      inner join products as p
        on o.product_id = p.product_id
      inner join Stores as s
        on o.order_store_id = s.store_id
      where o.customer_id=?;
    """,
      [id],
    );

    return data.map((data) => Order.fromMap(data)).toList();
  }

  // 입력
  Future<int> insert(Order ord) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert(
      """
        insert into orders( 
     
          customer_id,
          product_id,
          order_store_id,
          order_quantity,
          order_total_price,
          order_status,
          created_at
   ) values (?,?,?,?,?,?,?) 
      """,
      [
        ord.customer_id,
        ord.product_id,
        ord.order_store_id,
        ord.order_quantity,
        ord.order_total_price,
        ord.order_status,
        DateTime.now().toString(),
      ],
    );
  }

  // 수정
  Future<int> update(Order ord) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert(
      """
        update orders set
     
          customer_id=?
          product_id=?,
          order_store_id=?,
          order_quantity=?,
          order_total_price=?,
          order_status=?
          where order_id=?
      """,
      [
        ord.customer_id,
        ord.product_id,
        ord.order_store_id,
        ord.order_quantity,
        ord.order_total_price,
        ord.order_status,
        ord.order_id,
      ],
    );
  }
}
