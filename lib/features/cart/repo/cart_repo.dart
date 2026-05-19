import 'package:book_thrift/constants/api_url.dart';
import 'package:book_thrift/core/services/api_services.dart';
import 'package:book_thrift/features/cart/models/cart_item.dart';

class CartRepo {
  Future<List<CartItem>> getCart() async {
    final response = await apiInstance.getData(url: ApiUrl.cart);
    final List data = response['data'] ?? [];
    return data.map((e) => CartItem.fromJson(e)).toList();
  }

  Future<int> addToCart(int bookId) async {
    final response = await apiInstance.postData(
      url: ApiUrl.addToCart,
      data: {'book_id': bookId},
    );

    return response['data']['cart_amount'];
  }
}
