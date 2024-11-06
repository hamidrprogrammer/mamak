import 'package:feature/externalSignIn/model/external_sign_in_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleIDLoginHelper extends StatelessWidget {
  const AppleIDLoginHelper({super.key, required this.onSignIn});

  final Function(ExternalSignInModel) onSignIn;

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () async {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        onSignIn.call(
          ExternalSignInModel(
            name: credential.givenName ?? '',
            email: credential.email ?? '',
            code: credential.authorizationCode,
          ),
        );
        print(credential);
        // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
        // after they have been validated with Apple (see `Integration` section for more information on how to do this)
      },
    );
  }
}
