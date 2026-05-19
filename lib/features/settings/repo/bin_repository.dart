import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class BinRepository {
  Future<List<BookListing>> getBin() async {
    final response = await apiInstance.getData(url: ApiUrl.baseUrl + ApiUrl.bin);
    final List<dynamic> data = response['data'];
    return data.map((json) => BookListing.fromJson(json)).toList();
  }

  Future<void> recoverBook(String bookId) async {
    await apiInstance.postData(
      url: '${ApiUrl.baseUrl}books/$bookId/recover',
    );
  }

  Future<void> permanentlyDeleteBook(String bookId) async {
    await apiInstance.deleteData(
      url: '${ApiUrl.baseUrl}bin/$bookId',
    );
  }

  Future<void> recoverAllBooks() async {
    await apiInstance.postData(
      url: '${ApiUrl.baseUrl}books/all/recover',
    );
  }

  Future<void> deleteAllBooks() async {
    await apiInstance.deleteData(
      url: '${ApiUrl.baseUrl}bin/delete-all',
    );
  }
}
