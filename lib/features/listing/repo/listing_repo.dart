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
    return await apiInstance.postData(url: "${ApiUrl.toggleWishlist}$bookId");
  }

  Future<Map<String, dynamic>> deleteListing(int bookId) async {
    log("delete book id is $bookId");
    return await apiInstance.getData(url: ApiUrl.deleteBook, queryParameters: {'book_id': bookId});
  }

  Future<Map<String, dynamic>> updateBook({
    required int bookId,
    String? title,
    String? condition,
    double? price,
    int? quantity,
    String? description,
    String? location,
    String? category,
    List<String>? imagePaths,
    double? latitude,
    double? longitude,
    bool? isSold,
    bool? isDeleted,
  }) async {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (condition != null) data['condition'] = condition.toLowerCase();
    if (price != null) data['price'] = price;
    if (quantity != null) data['quantity'] = quantity;
    if (description != null) data['description'] = description;
    if (location != null) data['location'] = location;
    if (category != null) data['category'] = category;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (isSold != null) data['is_sold'] = isSold;
    if (isDeleted != null) data['is_deleted'] = isDeleted;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      final List<MultipartFile> files = [];
      for (final path in imagePaths) {
        // If path is a network URL, we might not want to re-upload it or handled differently
        // But assuming these are new local paths if we are sending them
        if (!path.startsWith('http')) {
          files.add(await MultipartFile.fromFile(path));
        }
      }
      if (files.isNotEmpty) {
        data['images'] = files;
      }
    }

    return await apiInstance.putData(
      url: "${ApiUrl.updateBook}$bookId",
      data: data,
      isFileUpload: true,
    );
  }
}
