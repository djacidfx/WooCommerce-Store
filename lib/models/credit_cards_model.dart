class CreditCardsModel {
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvv;

  CreditCardsModel(
      {this.cardNumber, this.expiryDate, this.cardHolderName, this.cvv});

  CreditCardsModel.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    expiryDate = json['expiryDate'];
    cardHolderName = json['cardHolderName'];
    cvv = json['cvv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardNumber'] = cardNumber;
    data['expiryDate'] = expiryDate;
    data['cardHolderName'] = cardHolderName;
    data['cvv'] = cvv;
    return data;
  }
  
}