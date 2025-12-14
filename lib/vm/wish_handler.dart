import 'package:shoes_store_app_project/model/wish.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class WishHandler {
  Future<List<Wish>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery(
      """
      select * from Wishes
      where customer_id = ?
      """,
      [id],
    );
    return data.map((data) => Wish.fromMap(data)).toList();
  }

  // 위시에있는 상품들 가져오기
  Future<List<Map<String, dynamic>>> selectProductQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery(
      """
      select w.product_id as product_id ,p.mainImageUrl as mainImageUrl, p.product_name as product_name, p.product_price as product_price
      from Wishes as w
      inner join products as p
        on p.product_id = w.product_id
      where w.customer_id = ?
      """,
      [id],
    );
    return data;
  }

  // 위시하트 유지하는 Query
  Future<bool> exists(int customerId, int productId) async {
    final db = await Initialize.initDatabase();
    final res = await db.rawQuery(
      '''
    SELECT 1 FROM Wishes
    WHERE customer_id = ? AND product_id = ?
    LIMIT 1
    ''',
      [customerId, productId],
    );
    return res.isNotEmpty;
  }

  Future<int> insert(Wish wish) async {
    Database db = await Initialize.initDatabase();
    final result = await db.rawInsert(
      """
        insert into Wishes( 
          customer_id,
          product_id,
          created_at
        ) values (?,?,?) 
      """,
      [wish.customer_id, wish.product_id, wish.created_at.toString()],
    );
    print('들어감');
    return result;
  }

  Future<void> deleteWish(int cid, int pid) async {
    Database db = await Initialize.initDatabase();
    await db.rawDelete(
      """
      delete from Wishes
      where customer_id = ? and product_id = ?
      """,
      [cid, pid],
    );
    print('지워짐');
  }
}
