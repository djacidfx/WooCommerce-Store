import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../models/cart_request.dart';
import '../models/cart_response.dart';
import '../models/category.dart';
import '../models/customer.dart';
import 'dart:convert';
import 'dart:io';
import '../models/login_response.dart';
import '../models/order.dart';
import '../models/order_detail.dart';
import '../models/product.dart';
import '../models/variable_product.dart';
import '../utils/shared_prefs.dart';

class WooApiService {

  //customer sign up
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken =  base64.encode(utf8.encode(APIconstants.key + ":" + APIconstants.secret));

    bool ret = false;

    try {
      var response = await Dio().post(APIconstants.url + APIconstants.customerURL,
          data: model.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json'
          }));

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  //customer login
  Future<LoginResponseModel> loginCustomer( String? username, String? password) async{
    LoginResponseModel model = LoginResponseModel();

    try {
      var response = await Dio().post(APIconstants.tokenURL,
          data: {
            "username": username,
            "password": password,
          },
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          }));

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
        debugPrint('RESPONSE: ${response.data.toString()}');
        debugPrint('token: ${model.toString()}');
      }
    } on DioError catch (e) {
      debugPrint('ERROR MESSAGE: ${e.message}');
      debugPrint('token: ${model.data.toString()}');
    }

    return model; 
  }
  
  //socialLogin
  Future<LoginResponseModel> loginSocialCustomer( String userName) async {
    LoginResponseModel model = LoginResponseModel();

    try {
      var response = await Dio().post(
      APIconstants.tokenURL,
      data: {"username" : userName, "social_login" : "true"},
      options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          }));

    if(response.statusCode ==200) {
      debugPrint(response.data.toString());
      model = LoginResponseModel.fromJson(response.data);
    } 

    } on DioError catch (e) {
      debugPrint(e.message.toString());
    }

    return model; 
  }

  //Categories listing
  // Future<List<Category>> getCategories() async {
  //   List<Category> data = <Category>[];
  //   try {
  //     String url = APIconstants.url +
  //         APIconstants.categoriesURL + 
  //         "?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";
  //     var response = await Dio().get(url,
  //         options: Options(headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         }));
  //     if (response.statusCode == 200) {
  //       data =
  //           (response.data as List).map((i) => Category.fromJson(i)).toList();
  //     }
  //   } on DioError catch (e) {
  //     debugPrint(e.response.toString());
  //   }
  //   return data;
  // }

  //100 categories per page
  Future<List<Category>> getCategories() async {
    int perPage = 100;
    List<Category> data = <Category>[];

    try {
      String url = APIconstants.url +
          APIconstants.categoriesURL +
          "?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}&per_page=$perPage";
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map((i) => Category.fromJson(i))
            .toList();
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }

    return data;
  }

  //Products listing
  Future<List<Product>> getProducts({int? pageNumber, int? pageSize, String? strSearch, String? tagId, String? categoryId, List<int>? productsIDs, String? sortBy, String sortOrder = "asc" }) async { List<Product> data = <Product>[];
    try {
      String parameter = "";
      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagId != null) {
        parameter += "&tag=$tagId";
      }

      if (productsIDs != null) {
        parameter += "&include=${productsIDs.join(",").toString()}";
      }

      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }

      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      parameter += "&order=$sortOrder";

      String url = APIconstants.url +
          APIconstants.productsURL +
          "?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}${parameter.toString()}";
      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        data = (response.data as List).map((i) => Product.fromJson(i)).toList();
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }

    return data;
  }

  //get product
  Future<Product> getProduct({required int productId}) async {
    Product productModel = Product();

    try {

      String url = APIconstants.url + APIconstants.productsURL + "/$productId?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        productModel = Product.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      }
    }
    return productModel;
  }


  // add to cart
  Future<CartResponseModel> addtoCart(CartRequestModel model) async {

    LoginResponseModel? loginResponseModel = await SharedService.loginDetails();
    if (loginResponseModel!.data != null) {
      model.userId = loginResponseModel.data!.id;
    }

    CartResponseModel responseModel = CartResponseModel();

    try {
      var response = await Dio().post(
       APIconstants.url +APIconstants.addtoCartURL,
        data: model.toJson(),
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );
      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      }
    }
    return responseModel;
  }
  // get cart items
  Future<CartResponseModel> getCartItems() async {
    CartResponseModel responseModel = CartResponseModel();

    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if(loginResponseModel!.data != null) {
        int? userId = loginResponseModel.data!.id;
      String url = APIconstants.url +
          APIconstants.cartURL +
          "?user_id=$userId&consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";
      debugPrint(url);

      var response = await Dio().get(
        url,
        options: Options(
            headers: {HttpHeaders.contentTypeHeader: "application/json"}),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }

    return responseModel;
  }

//get variable products
  Future<List<VariableProduct>> getVariableProducts(int productId) async{
    List<VariableProduct> responseModel = <VariableProduct>[];

    try {
      String url = APIconstants.url + APIconstants.productsURL + "/${productId.toString()}/${APIconstants.variableProductsURL}?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";

      var response = await Dio().get(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        responseModel =(response.data as List).map((e) => VariableProduct.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    return responseModel;
  }

  //update address
  Future updateAddress(CustomerModel responseModel) async {
    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if(loginResponseModel!.data != null) {
        int? userId = loginResponseModel.data!.id;

      String url = APIconstants.url + APIconstants.customerURL + "/$userId?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";
      
      var response = await Dio().put(
        url,
        data: responseModel.toJson(),
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        responseModel = CustomerModel.fromJson(response.data);
      }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      }
    }
    return responseModel;
  }

  //get customer details
  Future<CustomerModel> getCustomerDetails() async {
    CustomerModel responseModel = CustomerModel();

    try {

      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if(loginResponseModel!.data != null) {
        int? userId = loginResponseModel.data!.id;

      String url = APIconstants.url + APIconstants.customerURL + "/$userId?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        responseModel = CustomerModel.fromJson(response.data);
      }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      }
    }
    return responseModel;
  }

  //create order
  Future<bool> createOrder(OrderModel model) async {
    LoginResponseModel? loginResponseModel = await SharedService.loginDetails();
    if (loginResponseModel!.data != null) {
      model.customerId = loginResponseModel.data!.id!;
    }
    bool isOrderCreated = false;

    var authToken = base64.encode(
      utf8.encode(
        APIconstants.key + ":" + APIconstants.secret
      )
    );

    try {
      var response = await Dio().post(
        APIconstants.url + APIconstants.orderURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          }
        )
      );

      if (response.statusCode == 201) {
        isOrderCreated = true;
      }

    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      } 
    }

    return isOrderCreated;
  }

  //get orders
  Future<List<OrderModel>> getOrders({required String status}) async {
    List<OrderModel> data = <OrderModel>[];
    int perPage = 100;

    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if(loginResponseModel!.data != null) { 
        int? customerID = loginResponseModel.data!.id;

        String url = APIconstants.url + APIconstants.orderURL + "?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}&customer=$customerID&per_page=$perPage&status=$status";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        data = ( response.data as List).map((i) => OrderModel.fromJson(i)).toList();
      }
      }

    } on DioError catch (e) {
        debugPrint(e.response.toString());
    }
    return data;
  }

  //get order details
  Future<OrderDetailModel> getOrderDetails(int orderId) async {
    OrderDetailModel responseModel = OrderDetailModel();

    try {
      String url = APIconstants.url + APIconstants.orderURL + "/$orderId?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";
      debugPrint(url);

      var response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
         responseModel = OrderDetailModel.fromJson(response.data);
      }

    } on DioError catch (e) {
        debugPrint(e.response.toString());
    }
    return responseModel;
    
  }

  //update order (can be used for cancel order)
  Future cancelOrder({required OrderModel model}) async {

    try {
      String url = APIconstants.url + APIconstants.orderURL + "/${model.orderId}?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}";

      var response = await Dio().put(
        url,
        data: model.toJson(),
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        model = OrderModel.fromJson(response.data);
      }

    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      } 
    }

    return model;
  }

  // force delete account
  Future<bool> deleteAccount() async {
    bool isAccountDeleted = false;

    try {
      LoginResponseModel? loginResponseModel = await SharedService.loginDetails();

      if(loginResponseModel!.data != null) {
        int? userId = loginResponseModel.data!.id;

      String url = APIconstants.url + APIconstants.customerURL + "/$userId?consumer_key=${APIconstants.key}&consumer_secret=${APIconstants.secret}&force=true";

      var response = await Dio().delete(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"}
        )
      );

      if (response.statusCode == 200) {
        isAccountDeleted = true;
      }
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        debugPrint(e.response!.statusCode.toString());
      } else {
        debugPrint(e.message);
      }
    }
    return isAccountDeleted;
  }

}