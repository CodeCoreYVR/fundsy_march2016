$(function(){
  // Grab Stripe Publishable Key from meta data in our header
  // Remember, we inserted it in our application.html.erb
  var stripePublishableKey = $('meta[name=\'stripe-publishable-key\']').attr('content')

  // Preselect all jQuery nodes we need
  var $stripeErrorMessage = $('#stripe-error-message')
  var $paymentForm        = $('#payment-form')
  var $serverForm         = $('#server-form')
  var $stripeToken        = $('#stripe-token')
  
  // Configure Stripe tool with publishable key
  Stripe.setPublishableKey(stripePublishableKey)

  $paymentForm.on('submit', function (event) {
    // Do not submit form yet!!
    // There are things that must be done first
    event.preventDefault()

    // We're trying to process the credit card again
    // Hide error message whether it was present or not
    $stripeErrorMessage.addClass('hide')

    // Prevent user from submitting repeatedly
    $paymentForm.find('input:submit').attr('disabled', true)

    // Tokenize credit card data
    // This will allow our app to make future payments for the user
    // without asking for his credit card data again and without
    // actually saving their credit card data to our database
    Stripe.card.createToken($paymentForm, stripeResponseHandler);
  })

  // This callback will be called if Stripe successfully generated
  // the credit card token
  function stripeResponseHandler (status, data) {
    if (status === 200) {
      var token = data.id

      // Add tokenized credit card to hidden field in server form
      $stripeToken.val(token)

      // Submit form, POST to payments#create
      $serverForm.submit()
    } else {
      // Oops, an error was received
      var errorMessage = data.error.message

      // Display it in error div
      $stripeErrorMessage.html(errorMessage)
      // Unhide it
      $stripeErrorMessage.removeClass('hide')
      // Allow user to submit payment form again
      $paymentForm.find('input:submit').attr('disable', false)
    }
  }
})
