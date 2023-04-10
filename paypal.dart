// create account in https://developer.paypal.com/braintree/

dependencies:
  flutter_braintree: ^3.0.0

// all method give in 'flutter_braintree' package.

// method call on button click
  static final String tokenizationKey = 'Your_Token_key';

  // The payment method nonce containing all relevant information for the payment.
  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

                 
 //LAUNCH NATIVE DROP-IN

  /// Authorization allowing this client to communicate with Braintree.
  /// Either [clientToken] or [tokenizationKey] must be set.
                var request = BraintreeDropInRequest(
                  tokenizationKey: tokenizationKey,
                  collectDeviceData: true,
                  googlePaymentRequest: BraintreeGooglePaymentRequest(
                    totalPrice: '4.20',  /// Total price of the payment.
                    currencyCode: 'USD',  /// Currency code of the transaction.
                    billingAddressRequired: false,  /// Whether billing address information should be collected and passed.
                  ),
                  applePayRequest: BraintreeApplePayRequest(
                      currencyCode: 'USD',
                      supportedNetworks: [
                        ApplePaySupportedNetworks.visa,
                        ApplePaySupportedNetworks.masterCard,
                        // ApplePaySupportedNetworks.amex,
                        // ApplePaySupportedNetworks.discover,
                      ],
                      countryCode: 'US',
                      merchantIdentifier: '',
                      displayName: '',
                      paymentSummaryItems: []
                  ),

   /// Amount of the transaction. If [amount] is `null`, PayPal will use the billing agreement (Vault) flow.
  /// If [amount] is set, PayPal will follow the one time payment (Checkout) flow.
                  paypalRequest: BraintreePayPalRequest(
                    amount: '4.20',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );
                final result = await BraintreeDropIn.start(request);
                if (result != null) {
                  showNonce(result.paymentMethodNonce);
                }
             
  // TOKENIZE CREDIT CARD   
        
                final request = BraintreeCreditCardRequest(
                  cardNumber: '4111111111111111',  /// Number shown on the credit card.
                  expirationMonth: '12',  /// Two didgit expiration month, e.g. `'05'`.
                  expirationYear: '2021',  /// Four didgit expiration year, e.g. `'2021'`.
                  cvv: '123',  /// A 3 or 4 digit card verification value assigned to credit cards.
                );
                final result = await Braintree.tokenizeCreditCard(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
             

  //PAYPAL VAULT FLOW

                final request = BraintreePayPalRequest(
                  amount: null,
                  billingAgreementDescription:
                  'description....',
                  displayName: 'Your Company',
                );
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
            


// PAYPAL CHECKOUT FLOW  
//         
                final request = BraintreePayPalRequest(amount: '13.37');
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
             