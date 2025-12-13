import 'package:shoes_store_app_project/model/shopping_cart.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ShopcartHandler {
  Future<Database> get _db async => await Initialize.initDatabase();

  Future<List<Map<String, dynamic>>> selectByCustomer(int customerId) async {
    final db = await _db;
    return await db.query(
      'cart_items',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'updated_at DESC',
    );
  }

  /// 장바구니 담기: 같은 (customer_id, product_id, size)면 qty + 1
  Future<void> upsertAddOne({
    required int customerId,
    required int productId,
    required String title,
    required int price,
    required String image,
    required String size,
  }) async {
    final db = await _db;

    await db.rawInsert(
      '''
      INSERT INTO cart_items(customer_id, product_id, title, price, image, size, qty, updated_at)
      VALUES(?, ?, ?, ?, ?, ?, 1, datetime('now'))
      ON CONFLICT(customer_id, product_id, size)
      DO UPDATE SET
        qty = qty + 1,
        updated_at = datetime('now')
    ''',
      [customerId, productId, title, price, image, size],
    );
  }

  Future<void> updateQty({required int cartId, required int qty}) async {
    final db = await _db;
    await db.update(
      'cart_items',
      {'qty': qty, 'updated_at': DateTime.now().toIso8601String()},
      where: 'cart_id = ?',
      whereArgs: [cartId],
    );
  }

  Future<void> deleteByCartId(int cartId) async {
    final db = await _db;
    await db.delete('cart_items', where: 'cart_id = ?', whereArgs: [cartId]);
  }

  Future<void> clearByCustomer(int customerId) async {
    final db = await _db;
    await db.delete(
      'cart_items',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );
  }
}
