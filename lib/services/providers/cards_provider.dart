import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/utils/print_to_console.dart';
import '../../models/credit_cards_model.dart';

class CardsProvider with ChangeNotifier {

  Future<bool> isEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? card1 = prefs.getString('card1');
    String? card2 = prefs.getString('card2');
    String? card3 = prefs.getString('card3');

    if (card1 == null && card2 == null && card3 == null) {
      return true;
    } else {
      return false;
    }
   
  }

  //get cards from shared preferences
  Future<CreditCardsModel> getCard1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      
    Map<String,dynamic> creditCardModel = jsonDecode(prefs.getString('card1')!);

    final cardDetails = CreditCardsModel.fromJson(creditCardModel);

    return cardDetails;
    
  }

  Future<CreditCardsModel> getCard2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      
    Map<String,dynamic> creditCardModel = jsonDecode(prefs.getString('card2')!);

    final cardDetails = CreditCardsModel.fromJson(creditCardModel);

    return cardDetails;
    
  }

  Future<CreditCardsModel> getCard3() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      
    Map<String,dynamic> creditCardModel = jsonDecode(prefs.getString('card3')!);

    final cardDetails = CreditCardsModel.fromJson(creditCardModel);

    return cardDetails;
    
  }

  //store cards in shared preferences
  Future storeCardDetails1({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CreditCardsModel creditCardModel = CreditCardsModel(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );

    String card1 = jsonEncode(creditCardModel);

    printToConsole(card1);

    prefs.setString('card1', card1);
    notifyListeners();
  }

  Future storeCardDetails2({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CreditCardsModel creditCardModel = CreditCardsModel(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );

    String card2 = jsonEncode(creditCardModel);

    printToConsole(card2);

    prefs.setString('card2', card2);
    notifyListeners();
  }

  Future storeCardDetails3({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CreditCardsModel creditCardModel = CreditCardsModel(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );

    String card3 = jsonEncode(creditCardModel);

    printToConsole(card3);

    prefs.setString('card3', card3);
    notifyListeners();
  }
  
  //delete cards from shared preferences
  Future deleteCard1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('card1');
    notifyListeners();
  }

  Future deleteCard2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('card2');
    notifyListeners();
  }

  Future deleteCard3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('card3');
    notifyListeners();
  }

  //create demo cards on customer login
  Future createDemoCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CreditCardsModel creditCardModel = CreditCardsModel(
      cardNumber: '4084 0840 8408 4081',
      expiryDate: '12/24',
      cvv: '408',
      cardHolderName: 'John Doe',
    );

    String card1 = jsonEncode(creditCardModel);

    prefs.setString('card1', card1);

    CreditCardsModel creditCardModel2 = CreditCardsModel(
      cardNumber: '4242 4242 4242 4242',
      expiryDate: '03/24',
      cvv: '123',
      cardHolderName: 'John A. Doe',
    );

    String card2 = jsonEncode(creditCardModel2);

    prefs.setString('card2', card2);

    CreditCardsModel creditCardModel3 = CreditCardsModel(
      cardNumber: '4111111111111111',
      expiryDate: '12/20',
      cvv: '123',
      cardHolderName: 'John Doe A.',
    );

    String card3 = jsonEncode(creditCardModel3);

    prefs.setString('card3', card3);

    notifyListeners();
  }
}

