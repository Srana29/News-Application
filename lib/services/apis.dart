import 'package:amplify_flutter/amplify_flutter.dart';

class APIs{

  String apikey = "41dd062857f9477ebc0ebe295c896f32";
  String baseUrl="https://newsapi.org/v2/";

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }


  Future<void> signUpUser({
    required String name,
    required String password,
    required String email,
    //String? phoneNumber,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        //if (phoneNumber != null) AuthUserAttributeKey.phoneNumber: phoneNumber,
        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
        username: name,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );


      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');

    }
  }

  Future<bool?> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        //shareprefrences call
        return true;
      default:
        return false;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
          'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  Future<bool> confirmUser({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );
      bool? success = await _handleSignUpResult(result);
      return success!;
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
      return false;
    }
  }

  Future<bool> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      if(result.isSignedIn){
        return true;
      }else{
        await _handleSignInResult(result,username);
        return false;
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return false;
    }
  }

  Future<void> _handleSignInResult(SignInResult result,String username) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        safePrint('Enter a new password to continue signing in');
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        final parameters = result.nextStep.additionalInfo;
        final prompt = parameters['prompt']!;
        safePrint(prompt);
        break;
      case AuthSignInStep.resetPassword:
        final resetResult = await Amplify.Auth.resetPassword(
          username: username,
        );
        //await _handleResetPasswordResult(resetResult);
        break;
      case AuthSignInStep.confirmSignUp:
      // Resend the sign up code to the registered device.
        final resendResult = await Amplify.Auth.resendSignUpCode(
          username: username,
        );
        _handleCodeDelivery(resendResult.codeDeliveryDetails);
        break;
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
        break;
    }
  }





}