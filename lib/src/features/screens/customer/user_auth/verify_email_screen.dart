import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistics_express/src/features/screens/delivery_agent/agent_auth/details_fillup.dart';
import 'package:logistics_express/src/models/user_auth_model.dart';
import 'package:logistics_express/src/services/authentication/auth_controller.dart';
import 'package:logistics_express/src/services/authentication/auth_service.dart';
import 'package:logistics_express/src/models/user_model.dart';
import 'package:logistics_express/src/services/user_services.dart';
import 'package:logistics_express/src/custom_widgets/custom_loader.dart';
import 'package:logistics_express/src/utils/firebase_exceptions.dart';
import 'package:logistics_express/src/custom_widgets/form_header.dart';
import 'package:logistics_express/src/features/screens/customer/user_dashboard/user_dashboard_screen.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail(
      {super.key, required this.email, this.user, required this.userAuthModel});

  final String email;
  final UserAuthModel userAuthModel;
  final UserModel? user;
  @override
  ConsumerState<VerifyEmail> createState() {
    return _VerifyEmailState();
  }
}

class _VerifyEmailState extends ConsumerState<VerifyEmail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final authService = ref.watch(authServiceProvider);
    final role = ref.watch(roleProvider);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: _isLoading,
              child: Column(
                children: [
                  const Expanded(
                    flex: 2,
                    child: FormHeader(
                      currentLogo: 'logo',
                      imageSize: 110,
                      text: 'Verifying... E-mail',
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            Text(
                              'Verification link has been sent to ${widget.email}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (await authService
                                              .checkEmailVerified() &&
                                          context.mounted) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        final userServices = UserServices();
                                        await userServices.createAuthUser(
                                            widget.userAuthModel);
                                        if (widget.user != null) {
                                          await userServices
                                              .createUser(widget.user!);
                                        }
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance
                                            .collection('customers')
                                            .doc(user!.uid)
                                            .update({
                                          'id': user.uid,
                                        });
                                        authController.clearAll();
                                        if (context.mounted) {
                                          showSuccessSnackBar(
                                            context,
                                            'Email Verified!',
                                          );
                                          if (role == 'Customer') {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserHomeScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          } else {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsFillup(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        }
                                      } else {
                                        showErrorSnackBar(
                                          context,
                                          "Email not verified yet!",
                                        );
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(FontAwesomeIcons.arrowRight),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CustomLoader(),
              ),
          ],
        ),
      ),
    );
  }
}
