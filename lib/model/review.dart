class Review {
  int? review_id;
  int customer_id;
  int product_id;
  int review_rating;
  String review_content;
  DateTime created_at;

  Review({
    this.review_id,
    required this.customer_id,
    required this.product_id,
    required this.review_rating,
    required this.review_content,
    required this.created_at,
  });

  Review.fromMap(Map<String, dynamic> res)
      : review_id = res['review_id'],
        customer_id = res['customer_id'],
        product_id = res['product_id'],
        review_rating = res['review_rating'],
        review_content = res['review_content'],
        created_at = DateTime.parse(res['created_at']);
}
