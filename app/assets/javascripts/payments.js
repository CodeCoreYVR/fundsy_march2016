$(document).ready(function(){

  var $form = $('#payment-form');

  var stripeResponseHandler = function(status, response){
    if(status === 200) {
      var token = response.id;
      $("#stripe_token").val(token);
      $("#submit-form").submit();
    } else {
      $("#stripe-errors").html(response.error.message);
      $form.find(':submit').prop('disabled', false);
    }
  }

  $form.submit(function(event) {
    // Disable the submit button to prevent repeated clicks:
    $form.find(':submit').prop('disabled', true);

    // Request a token from Stripe:
    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from being submitted:
    return false;
  });

});
