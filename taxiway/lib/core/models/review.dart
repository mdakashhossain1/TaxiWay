class Review {
  final String id;
  final String reviewerName;
  final double rating;
  final String relativeDate;
  final String comment;
  final List<String> tags;

  const Review({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.relativeDate,
    required this.comment,
    this.tags = const [],
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;
    return Review(
      id: json['id'].toString(),
      reviewerName: customer?['name'] as String? ?? 'Customer',
      rating: double.parse(json['rating'].toString()),
      relativeDate: _relativeDate(DateTime.parse(json['created_at'] as String)),
      comment: json['comment'] as String? ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  static String _relativeDate(DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return '1 day ago';
    if (days < 14) return '$days days ago';
    if (days < 60) return '${(days / 7).floor()} weeks ago';
    return '${(days / 30).floor()} months ago';
  }
}

/// Percentage of reviews per star, 5 down to 1 (PRD §18 example: 78/16/4/1/1).
class RatingDistribution {
  final double average;
  final int totalReviews;
  final List<int> percentageByStar;

  const RatingDistribution({
    required this.average,
    required this.totalReviews,
    required this.percentageByStar,
  });

  factory RatingDistribution.fromReviews(List<Review> reviews) {
    if (reviews.isEmpty) {
      return const RatingDistribution(average: 0, totalReviews: 0, percentageByStar: [0, 0, 0, 0, 0]);
    }
    final total = reviews.length;
    final average = reviews.map((r) => r.rating).reduce((a, b) => a + b) / total;
    final percentages = List.generate(5, (i) {
      final star = 5 - i;
      final count = reviews.where((r) => r.rating.round() == star).length;
      return ((count / total) * 100).round();
    });
    return RatingDistribution(average: average, totalReviews: total, percentageByStar: percentages);
  }
}
