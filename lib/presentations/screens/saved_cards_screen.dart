import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import '../../models/credit_cards_model.dart';
import '../../services/providers/cards_provider.dart';
import '../widgets/elevated_button.dart';
import '../widgets/snackbar.dart';

class SavedCardsScreen extends StatefulWidget {
  const SavedCardsScreen({Key? key}) : super(key: key);

  @override
  State<SavedCardsScreen> createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  bool _isAddCardScreen = false;
  final _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: const BorderSide(color: Colors.white),
  );

  String? cardsIDvalue;
  var cardIDs = ['card1', 'card2', 'card3'];

  String? email;

  @override
  Widget build(BuildContext context) {
    var cardsProvider = context.watch<CardsProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        tooltip: !_isAddCardScreen ? 'Add Card' : 'Close',
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            _isAddCardScreen = !_isAddCardScreen;
          });
        },
        child: !_isAddCardScreen ? const Icon(Icons.add_card) : const Icon(Icons.close),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          !_isAddCardScreen ? 'Saved Cards' : 'Add Card',
          style:
              const TextStyle(fontFamily: 'baloo da 2', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: _isAddCardScreen
          ? addCards()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: cardsProvider.isEmpty(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.red,
                    ));
                  } else {
                    if (snapshot.data == true) {
                      return const Center(
                        child: Text(
                          'No Cards Saved. Click on the + button to add a card. You can add up to 3 cards.',
                          style: TextStyle(
                            fontFamily: 'baloo da 2',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return loadCards();
                    }
                  }
                },
              ),
            ),
    );
  }

  Widget loadCards() {
    var cardsProvider = context.watch<CardsProvider>();

    return FutureBuilder(
      future: cardsProvider.getCard1(),
      builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card1) {
        return FutureBuilder(
          future: cardsProvider.getCard2(),
          builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card2) {
            return FutureBuilder(
              future: cardsProvider.getCard3(),
              builder: (BuildContext context, AsyncSnapshot<CreditCardsModel> card3) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      card1.data == null ? Container() : 
                        buildCard(cardSlot: 'card1', card: card1.data!, cardsProvider: cardsProvider),

                        card2.data == null ? Container() : 
                        buildCard(cardSlot: 'card2', card: card2.data!, cardsProvider: cardsProvider),

                        card3.data == null ? Container() : 
                        buildCard(cardSlot: 'card3', card: card3.data!, cardsProvider: cardsProvider),

                    ]
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildCard({required String cardSlot, required CreditCardsModel card, required CardsProvider cardsProvider}) {
    return Badge(
      badgeContent: InkWell(
        onTap: () {
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text(
                    'Delete Card',
                    style: TextStyle(fontFamily: 'baloo da 2', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'Are you sure you want to delete this card?',
                    style: TextStyle(fontFamily: 'baloo da 2', fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontFamily: 'baloo da 2', fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontFamily: 'baloo da 2', fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        if (cardSlot == 'card1') {
                          cardsProvider.deleteCard1();
                        } else if (cardSlot == 'card2') {
                          cardsProvider.deleteCard2();
                        } else if (cardSlot == 'card3') {
                          cardsProvider.deleteCard3();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      position: BadgePosition.topEnd(top: 10, end: 10),
      child: CreditCardWidget(
        cardNumber: card.cardNumber!,
        expiryDate: card.expiryDate!,
        cardHolderName: card.cardHolderName!,
        cvvCode: card.cvv!,
        showBackView: isCvvFocused,
        isSwipeGestureEnabled: true,
        isHolderNameVisible: true,
        onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
      ),
    );
  }

  Widget addCards() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/res/abstract.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            isSwipeGestureEnabled: true,
            isHolderNameVisible: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          ),

          CreditCardForm(
            formKey: _formKey,
            obscureCvv: true,
            obscureNumber: true,
            cardNumber: cardNumber,
            cvvCode: cvvCode,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardHolderName: cardHolderName,
            expiryDate: expiryDate,
            themeColor: Colors.blue,
            textColor: Colors.white,
            cardNumberDecoration: InputDecoration(
              labelText: 'Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              hintStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  )),
            ),
            expiryDateDecoration: InputDecoration(
              hintStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelText: 'Expiry Date',
              hintText: 'XX/XX',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  )),
            ),
            cvvCodeDecoration: InputDecoration(
              hintStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelText: 'CVV',
              hintText: 'XXX',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  )),
            ),
            cardHolderDecoration: InputDecoration(
              hintStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelStyle: const TextStyle(
                fontFamily: 'baloo da 2',
                color: Colors.white,
              ),
              labelText: 'Card Holder',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  )),
            ),
            onCreditCardModelChange: onCreditCardModelChange,
          ),
          const SizedBox(
            height: 20,
          ),

          //address ID dropdown
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 10),
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: cardsIDvalue,
                  dropdownColor: Colors.white,
                  focusColor: Colors.white24,
                  hint: const Text(
                    '-- Select Card Slot --',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontFamily: 'baloo da 2', fontSize: 14.0, color: Colors.black54),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontFamily: 'baloo da 2', fontSize: 14.0, color: Colors.black),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 30),
                  items: cardIDs.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    setState(() {
                      cardsIDvalue = value as String?;
                    });
                  }),
            ),
          ),
          const SizedBox(height: 20),

          //save button
          elevatedButton(
              icon: Icons.save,
              text: 'Save Card Details',
              backgroundColor: const Color(0xff1b447b),
              onPressed: () {
                if (cardsIDvalue == null) {
                  snackbar(
                    context,
                    'Please select a card slot',
                    Colors.white,
                    Colors.red,
                  );
                } else {
                  if (validateAndSave()) {
                    saveCardDetails();
                  }
                }
              }),
          const SizedBox(height: 55),
        ]),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void saveCardDetails() {
    final cardsProvider = Provider.of<CardsProvider>(context, listen: false);

    if (cardsIDvalue == 'card1') {
      cardsProvider.storeCardDetails1(
          cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvvCode, cardHolderName: cardHolderName);
    } else {
      if (cardsIDvalue == 'card2') {
        cardsProvider.storeCardDetails2(
            cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvvCode, cardHolderName: cardHolderName);
      } else {
        if (cardsIDvalue == 'card3') {
          cardsProvider.storeCardDetails3(
              cardNumber: cardNumber, expiryDate: expiryDate, cvv: cvvCode, cardHolderName: cardHolderName);
        }
      }
    }
    setState(() {
      cardsIDvalue = null;
      _isAddCardScreen = false;
    });
    snackbar(
      context,
      'Card Details Saved',
      Colors.white,
      Colors.green,
    );
  }

  //build dropmenu item list
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style:
            const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'baloo da 2', fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
