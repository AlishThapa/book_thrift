import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class HomepageRepo {
  Future<Map<String, List<BookListing>>> getDashboardData({double? lat, double? lng}) async {
    final Map<String, dynamic> queryParams = {};
    // if (lat != null)
    if (lat != null) queryParams['lat'] = lat;
        // ?? 27.591883;
    if (lng != null) queryParams['lng'] = lng;
        // ?? 85.376210;
    

    final response = await apiInstance.getData(url: ApiUrl.dashboard, queryParameters: queryParams, useToken: true);

    final data = response['data'] as Map<String, dynamic>;
    

    return {
      'near_you': _parseListings(data['near_you']),
      'picks_for_you': _parseListings(data['picks_for_you']),
      'just_dropped': _parseListings(data['just_dropped']),
      'trending_this_month': _parseListings(data['trending_this_month'] ?? data['trending_this_week']),
    };
  }

  List<BookListing> _parseListings(dynamic list) {
    if (list == null || list is! List) return [];
    return list.map((e) => BookListing.fromJson(e as Map<String, dynamic>)).toList();
  }
}
