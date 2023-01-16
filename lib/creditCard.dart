import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({Key? key}) : super(key: key);

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = "";
  String expiryDay = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  OutlineInputBorder? border; // can be deleted
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> saveInformation() async {
    DocumentReference<Map<String, dynamic>> a = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await a.update({
      'credit card': {
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'cvv': cvvCode,
        'expiryDate': expiryDay,
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Credit card is saved'),
    ));
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 0.5,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Card"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.orange,
              ],
            )),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDay,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                bankName: 'Axis BANK',
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: Colors.redAccent,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                cardType: CardType.visa,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDay,
                        themeColor: Colors.red,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Card Number',
                          labelStyle: const TextStyle(color: Colors.purple),
                          hintText: 'XXXX XXXX XXXX XXXX',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90)),
                        ),
                        expiryDateDecoration: InputDecoration(
                            labelText: 'Expired Date',
                            labelStyle: const TextStyle(color: Colors.purple),
                            hintText: 'XX/XX',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90))),
                        cvvCodeDecoration: InputDecoration(
                            labelText: 'CVV',
                            labelStyle: const TextStyle(color: Colors.purple),
                            hintText: 'XXX',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90))),
                        cardHolderDecoration: InputDecoration(
                            labelText: 'Card Holder',
                            labelStyle: const TextStyle(color: Colors.purple),
                            hintText: 'GAZIHAN ALANKUS',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(90))),
                        cardHolderValidator: (p0) {
                          if (p0 == null ||
                              p0.isEmpty ||
                              p0.contains(RegExp('[a-z]')) ||
                              p0.contains(RegExp('[0-9]')) ||
                              !p0.contains(" ") ||
                              p0.contains(RegExp('[?,!,;,,,.]'))) {
                            return 'Please input a valid card holder.';
                          }
                          return null;
                        },
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: const Color(0xff1b447b),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'times new roman',
                                fontSize: 16,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              final content = formKey.currentState?.validate();
                              if (content == true) {
                                formKey.currentState?.save();
                                saveInformation();
                              }
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDay = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
