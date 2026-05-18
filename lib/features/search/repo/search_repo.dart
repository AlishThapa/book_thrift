import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class SearchRepo {
  Future<List<BookListing>> getBooks({
    List<String>? categories,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    final filteredCategories = categories?.where((c) => c != 'All').toList();
    final queryParams = {
      if (filteredCategories != null && filteredCategories.isNotEmpty) 'category': filteredCategories,
      if (search != null && search.isNotEmpty) 'search': search,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
    };

    final response = await apiInstance.getData(
      url: ApiUrl.getBooks,
      queryParameters: queryParams,
      useToken: false,
    );

    final List<dynamic> data = response['data'] ?? [];
    return data.map((e) => BookListing.fromJson(e as Map<String, dynamic>)).toList();
  }
}
