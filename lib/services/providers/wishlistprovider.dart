import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListProvider extends ChangeNotifier {
  Future<bool> isWishlistEmpty() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList("wishlist_id")!.isEmpty ? true : false;
  }

  Future<bool> isSavedToWishList(String productID) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("wishlist_id")?.contains(productID) ?? false;
  }

  Future<List<String>> getWishlistProductIDs() async {
    final prefs = await SharedPreferences.getInstance();

    var list = prefs.getStringList("wishlist_id");
    return list!;
  }

  Future addToWishlist(String productID) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> wishlist = prefs.getStringList("wishlist_id") ?? [];

    wishlist.add(productID);
    prefs.setStringList("wishlist_id", wishlist);

    var wishlistIDs = prefs.getStringList("wishlist_id");
    debugPrint(wishlistIDs.toString());

    notifyListeners();
  }

  Future removeFromWishlist(String productID) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> wishlist = prefs.getStringList("wishlist_id") ?? [];

    wishlist.remove(productID);
    prefs.setStringList("wishlist_id", wishlist);
    prefs.getStringList("wishlist_id");

    var wishlistIDs = prefs.getStringList("wishlist_id");
    debugPrint(wishlistIDs.toString());

    notifyListeners();
  }
}
