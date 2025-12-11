

import 'package:shoes_store_app_project/model/review.dart';
import 'package:shoes_store_app_project/util/initialize.dart';
import 'package:sqflite/sqflite.dart';

class ReviewHandler {

  Future<List<Review>> selectQuery(int id) async {
    Database db = await Initialize.initDatabase();
    final data = await db.rawQuery('select * from review');

    return data.map((data)=>Review.fromMap(data)).toList();
  }
  
  Future<int> insert(Review review) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert("""
        insert into reviews( 
          customer_id,
          product_id,
          review_rating,
          review_content,
          created_at
   ) values (?,?,?,?,?) 
      """,[
        review.customer_id,
        review.product_id,
        review.review_rating,
        review.review_content,
        review.created_at.toString()
      ]
    );
  }

  
  Future<int> update(Review review) async {
    Database db = await Initialize.initDatabase();
    return await db.rawInsert(
      'update reviews set review_rating=?,review_content=? where id=?',
      [
   
        review.review_rating,
        review.review_content,
        review.review_id
      ]
    );
  }



}