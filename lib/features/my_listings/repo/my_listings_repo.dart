import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class MyListingsRepo {
  Future<List<BookListing>> getMyListings({String? status}) async {
    final Map<String, dynamic> queryParameters = {};
    if (status != null) {
      queryParameters['listing_status'] = status;
    }
    
    final response = await apiInstance.getData(
      url: ApiUrl.myListings,
      queryParameters: queryParameters,
    );

    final List data = response['data'] ?? [];
    return data.map((e) => BookListing.fromJson(e)).toList();
  }
}
