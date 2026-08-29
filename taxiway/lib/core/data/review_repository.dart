import '../api/api_client.dart';

abstract class ReviewRepository {
  Future<void> submitReview({
    required String bookingId,
    required int rating,
    String? comment,
    List<String> tags = const [],
  });
}

class ApiReviewRepository implements ReviewRepository {
  @override
  Future<void> submitReview({
    required String bookingId,
    required int rating,
    String? comment,
    List<String> tags = const [],
  }) {
    return ApiClient.instance.post('/customer/reviews', body: {
      'booking_id': int.parse(bookingId),
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
      'tags': tags,
    });
  }
}
