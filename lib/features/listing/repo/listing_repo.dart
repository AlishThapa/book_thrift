import 'dart:developer';

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
    double? latitude,
    double? longitude,
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

    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;

    if (imagePaths.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in imagePaths) {
        files.add(await MultipartFile.fromFile(path));
      }
      data['images'] = files;
    }

    return await apiInstance.postData(url: ApiUrl.postBook, data: data, isFileUpload: true);
  }

  Future<BookListing> getBookDetails(int bookId) async {
    final response = await apiInstance.getData(url: ApiUrl.bookDetails, queryParameters: {'book_id': bookId}, useToken: true);
    return BookListing.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<BookListing>> getWishlist() async {
    final response = await apiInstance.getData(url: ApiUrl.wishlist, useToken: true);
    final List<dynamic> data = response['data'] ?? [];
    return data.map((e) => BookListing.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> toggleWishlist(int bookId) async {
    return await apiInstance.postData(url: ApiUrl.toggleWishlist, queryParameters: {'book_id': bookId});
  }

  Future<Map<String, dynamic>> deleteListing(int bookId) async {
    log("delete book id is $bookId");
    return await apiInstance.getData(url: ApiUrl.deleteBook, queryParameters: {'book_id': bookId});
  }
}
