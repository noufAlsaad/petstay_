import 'dart:io';

import 'package:checkout_screen_ui/checkout_page/checkout_page.dart';
import 'package:checkout_screen_ui/models/card_form_results.dart';
import 'package:checkout_screen_ui/models/checkout_result.dart';
import 'package:checkout_screen_ui/models/price_item.dart';
import 'package:checkout_screen_ui/ui_components/footer.dart';
import 'package:checkout_screen_ui/ui_components/pay_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key , required this.price}) : super(key: key);
  final int price ;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final demoOnlyStuff = DemoOnlyStuff();
    final GlobalKey<CardPayButtonState> _payBtnKey =
    GlobalKey<CardPayButtonState>();

    Future<void> _creditPayClicked(
        CardFormResults results, CheckOutResult checkOutResult) async {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.processing);


      demoOnlyStuff.callTransactionApi(_payBtnKey , context);
    }

    final List<PriceItem> _priceItems = [
      PriceItem(name: 'Slot', quantity: 1, itemCostCents: (widget.price * 27).toInt()),
    ];
    const String _payToName = 'Pet Hotel';

    Function? _onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null;
    return Scaffold(
      appBar: null,
      body: CheckoutPage(
        data: CheckoutData(
          priceItems: _priceItems,
          payToName: _payToName,
          onCardPay: (paymentInfo, checkoutResults) => _creditPayClicked(paymentInfo, checkoutResults),
          onBack: _onBack,
          payBtnKey: _payBtnKey,

        ),
        // footer: _footer,
      ),
    );
  }
}

/// This class is meant to help separate logic that is only used within this demo
/// and not expected to resemble logic needed in live code. That said there may
/// exist some logic that is helpful to use in live code, such as calls to the
/// [CardPayButtonState] key to update its displayed color and icon.
class DemoOnlyStuff {
  // DEMO ONLY:
  // this variable is only used for this demo.
  bool shouldSucceed = true;

  // DEMO ONLY:
  // In this demo, this function is used to delay the resetting of the pay
  // button state in order to allow the user to resubmit the form.
  // If you API calls a failing a transaction, you may need a similar function
  // to update the button from CardPayButtonStatus.fail to
  // CardPayButtonStatus.success. The user will not be able to submit another
  // payment until the button is reset.
  Future<void> provideSomeTimeBeforeReset(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.ready);
      return;
    });
  }

  Future<void> callTransactionApi(
      GlobalKey<CardPayButtonState> _payBtnKey , context) async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (shouldSucceed) {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.success);
        Future.delayed(const Duration(seconds: 1), () async {
          Navigator.of(context).pop(true);
        });

        shouldSucceed = false;
      } else {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.fail);
        shouldSucceed = true;
      }
      provideSomeTimeBeforeReset(_payBtnKey);
      return;
    });
  }
}