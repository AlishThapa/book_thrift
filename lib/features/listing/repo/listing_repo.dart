import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/constants/api_url.dart';
import 'package:dio/dio.dart';

import '../models/book_listing.dart';

class ListingRepo {
  Future<Map<String, dynamic>> postBook({
    required String title,
    required String condition,
    required double price,
    required int quantity,
    required String description,
    required String location,
    required String category,
    required List<String> imagePaths,
  }) async {
    final Map<String, dynamic> data = {
      'title': title,
      'condition': condition.toLowerCase(), // API expects lower case based on documentation
      'price': price,
      'quantity': quantity,
      'description': description,
      'location': location,
      'category': category,
    };

    if (imagePaths.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in imagePaths) {
        files.add(await MultipartFile.fromFile(path));
      }
      data['images'] = files;
    }

    return await apiInstance.postData(
      url: ApiUrl.postBook,
      data: data,
      isFileUpload: true,
    );
  }

  Future<BookListing> getBookDetails(int bookId) async {
    final response = await apiInstance.getData(
      url: ApiUrl.bookDetails,
      queryParameters: {'book_id': bookId},
      useToken: false,
    );
    return BookListing.fromJson(response['data'] as Map<String, dynamic>);
  }
}
