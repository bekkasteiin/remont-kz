// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remont_kz/domain/services/rest_services.dart';
import 'package:remont_kz/main.dart';
import 'package:remont_kz/model/profile/get_profile.dart';
import 'package:remont_kz/screens/login/enable_local_auth_modal_bottom_sheet.dart';
import 'package:remont_kz/screens/login/password/change_password_screen.dart';
import 'package:remont_kz/screens/login/pin_code_admin.dart';
import 'package:remont_kz/utils/app_text_style.dart';
import 'package:remont_kz/utils/app_colors.dart';
import 'package:remont_kz/utils/box.dart';
import 'package:remont_kz/utils/global_widgets/shared_pr_widget.dart';
import 'package:remont_kz/utils/routes.dart';

class SignScreen extends StatelessWidget {
  bool? isWorker;
  SignScreen({Key? key, this.isWorker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            scrollDirection: Axis.vertical,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: AppColors.white,
                      indicatorWeight: 4,
                      tabs: [
                        Tab(
                          child: Text(
                            'Войти',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ),
                        Tab(
                          child: Text('Зарегистрироваться',
                              style: AppTextStyles.bodySecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                SignInScreen(
                  isWorkers: isWorker,
                ),
                SignUpScreen(isWorkers: isWorker)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  bool? isWorkers;
  SignInScreen({Key? key, this.isWorkers}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String login = '';
  String password = '';
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  bool isObsecure = true;
  bool _savePassword = true;

  final _storage = const FlutterSecureStorage();

  final String KEY_USERNAME = "KEY_USERNAME";

  final String KEY_PASSWORD = "KEY_PASSWORD";

  final String KEY_LOCAL_AUTH_ENABLED = "KEY_LOCAL_AUTH_ENABLED";
  var localAuth = LocalAuthentication();

  _onFormSubmit(BuildContext context) async {
    if (_savePassword) {
      await _storage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "false");
      await _storage.write(
          key: KEY_USERNAME, value: login.replaceAll(RegExp(r'\D'), ''));
      await _storage.write(key: KEY_PASSWORD, value: password);
      if (await localAuth.canCheckBiometrics) {
        final LocalAuthentication localAuthentication = LocalAuthentication();
        bool isBiometricSupported =
            await localAuthentication.isDeviceSupported();
        bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
        if (isBiometricSupported && canCheckBiometrics) {
          showModalBottomSheet<void>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
            ),
            builder: (_) {
              return EnableLocalAuthModalBottomSheet(
                action: _onEnableLocalAuth,
                email: login.replaceAll(RegExp(r'\D'), ''),
                password: password,
                faceId: false,
              );
            },
          );
        } else {
          var api = await RestServices().auth(
              login: login.replaceAll(RegExp(r'\D'), ''), password: password);
          if (api == 200) {
            SharedPreferencesHelper.setSeen(true);
            GetProfile serviceProfile = await RestServices().getMyProfile();
            if (serviceProfile.isClient == false) {
              Navigator.pop(context);
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.mainNavWorker, (route) => false);
            } else {
              Navigator.pop(context);
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.mainNav, (route) => false);
            }
          } else {}
        }
      }
    }
  }

  _onFaceSubmit(BuildContext context) async {
    if (_savePassword) {
      await _storage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "false");
      await _storage.write(
          key: KEY_USERNAME, value: login.replaceAll(RegExp(r'\D'), ''));
      await _storage.write(key: KEY_PASSWORD, value: password);
      if (await localAuth.canCheckBiometrics) {
        final LocalAuthentication localAuthentication = LocalAuthentication();
        bool isBiometricSupported =
            await localAuthentication.isDeviceSupported();
        bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
        if (isBiometricSupported && canCheckBiometrics) {
          showModalBottomSheet<void>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
            ),
            builder: (_) {
              return EnableLocalAuthModalBottomSheet(
                action: _onEnableLocalAuth,
                email: login.replaceAll(RegExp(r'\D'), ''),
                password: password,
                faceId: true,
              );
            },
          );
        } else {
          await _storage.write(
              key: KEY_USERNAME, value: login.replaceAll(RegExp(r'\D'), ''));
          await _storage.write(key: KEY_PASSWORD, value: password);
          var api = await RestServices().auth(
              login: login.replaceAll(RegExp(r'\D'), ''), password: password);

          if (api == 200) {
            GetProfile serviceProfile = await RestServices().getMyProfile();
            stompClient.activate();
            SharedPreferencesHelper.setSeen(true);
            if (serviceProfile.isClient == false) {
              Navigator.pop(context);
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.mainNavWorker, (route) => false);
            } else {
              Navigator.pop(context);
              await Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.mainNav, (route) => false);
            }
          } else {}
        }
      }
    }
  }

  _onEnableLocalAuth() async {
    await _storage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "true");
    if (!mounted) return;
  }

  _onTap(BuildContext context) async {
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      showDialog(
          useRootNavigator: false,
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.white,
                radius: 25,
                animating: true,
              ),
            );
          });
      var api = await RestServices().auth(
          login: login.replaceAll(RegExp(r'\D'), ''), password: password);

      if (api == 200) {
        Navigator.pop(context);
        _onFaceSubmit(context);
      }else{Navigator.pop(context);}

    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      showDialog(
          useRootNavigator: false,
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: AppColors.white,
                radius: 25,
                animating: true,
              ),
            );
          });
      var api = await RestServices().auth(
          login: login.replaceAll(RegExp(r'\D'), ''), password: password);

      if (api == 200) {
        Navigator.pop(context);
        _onFormSubmit(context);
      }else{Navigator.pop(context);}
    } else {
      if (_savePassword) {
        await _storage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "false");
        await _storage.write(
            key: KEY_USERNAME, value: login.replaceAll(RegExp(r'\D'), ''));
        await _storage.write(key: KEY_PASSWORD, value: password);
        showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: AppColors.white,
                  radius: 25,
                  animating: true,
                ),
              );
            });
        var api = await RestServices().auth(
            login: login.replaceAll(RegExp(r'\D'), ''), password: password);

        if (api == 200) {
          Navigator.pop(context);
          GetProfile serviceProfile = await RestServices().getMyProfile();
          SharedPreferencesHelper.setSeen(true);
          if (serviceProfile.isClient == false) {
            Navigator.pop(context);
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNavWorker, (route) => false);
          } else {
            Navigator.pop(context);
            await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.mainNav, (route) => false);
          }
        }else{
          Navigator.pop(context);
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HBox(12.h),
        Text(
          'Телефон',
          style: AppTextStyles.bodySecondary,
        ),
        HBox(12.h),
        Container(
          alignment: Alignment.center,
          height: 40.h,
          child: TextField(
            autocorrect: true,
            keyboardType: TextInputType.number,
            onChanged: (String val) {
              setState(() {
                login = val;
              });
            },
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: [maskFormatter],
            decoration: const InputDecoration(
              hintText: '+7 (777)-777-77-77',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              prefixIcon: Icon(Icons.phone_enabled_sharp),
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ),
        HBox(12.h),
        Text(
          'Пароль',
          style: AppTextStyles.bodySecondary,
        ),
        HBox(12.h),
        Container(
          alignment: Alignment.center,
          height: 40.h,
          child: TextField(
            autocorrect: true,
            onChanged: (String val) {
              setState(() {
                password = val;
              });
            },
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObsecure,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() => isObsecure = !isObsecure);
                },
                child: isObsecure
                    ? Icon(Icons.visibility_off, color: AppColors.primary)
                    : const Icon(Icons.visibility, color: AppColors.primary),
              ),
              fillColor: AppColors.white,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ),
        HBox(12.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangePasswordScreen(
                  isWorkers: widget.isWorkers ?? false,
                ),
              ),
            );
          },
          child: Text(
            'Забыли пароль?',
            style: AppTextStyles.bodySecondary,
          ),
        ),
        HBox(12.h),
        GestureDetector(
          onTap: () async {

            _onTap(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40.h,
            padding: EdgeInsets.all(4.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                color: AppColors.white),
            child: Text(
              'Войти',
              style: AppTextStyles.h18Regular
                  .copyWith(color: AppColors.blackGreyText, fontSize: 14.sp),
            ),
          ),
        ),
        HBox(12.h),
        Text(
          'При входе вы соглашаетесь с нашими Условиями использования',
          style: AppTextStyles.bodySecondary,
        ),
      ],
    );
  }
}

class SignUpScreen extends StatefulWidget {
  bool? isWorkers;
  SignUpScreen({Key? key, required this.isWorkers}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  bool _confirm = false;
  String mobilePhone = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  int levelClock = 120;
  bool showError = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );


  bool isMaskFormatterFilled(MaskTextInputFormatter maskFormatter, String value) {
    String unmaskedText = value;
    print(maskFormatter.getMask()?.length);
    print(unmaskedText);
    // Modify this condition as per your needs
    return unmaskedText.length == maskFormatter.getMask()?.length;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HBox(12.h),
                Text(
                  'Телефон',
                  style: AppTextStyles.bodySecondary,
                ),
                HBox(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4.w)
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    autocorrect: true,
                    keyboardType: TextInputType.number,
                    onChanged: (String val) {
                      setState(() {
                        mobilePhone = val;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Заполните номер телефона");
                      }
                      return null;
                    },
                    inputFormatters: [maskFormatter],
                    decoration: InputDecoration.collapsed(
                      hintText: '+7(777) 123-45-67',
                      hintStyle: AppTextStyles.body14Secondary.copyWith(
                          color: AppColors.primaryGray,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                HBox(8.h),
                Text(
                  'Имя',
                  style: AppTextStyles.bodySecondary,
                ),
                HBox(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4.w)
                  ),
                  height: 40.h,
                  child: TextFormField(
                    autocorrect: true,
                    onChanged: (String val) {
                      setState(() {
                        firstName = val;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Заполните ваше имя");
                      }
                      return null;
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Имя',
                      hintStyle: AppTextStyles.body14Secondary.copyWith(
                          color: AppColors.primaryGray,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                HBox(8.h),
                Text(
                  'Фамилия',
                  style: AppTextStyles.bodySecondary,
                ),
                HBox(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                    borderRadius: BorderRadius.circular(4.w)
                  ),
                  height: 40.h,
                  child: TextFormField(
                    onChanged: (String val) {
                      setState(() {
                        lastName = val;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Заполните фамилию");
                      }
                      return null;
                    },
                    autocorrect: true,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Фамилия',
                      hintStyle: AppTextStyles.body14Secondary.copyWith(
                          color: AppColors.primaryGray,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                HBox(8.h),
                Text(
                  'Пароль',
                  style: AppTextStyles.bodySecondary,
                ),
                HBox(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4.w)
                  ),
                  height: 40.h,
                  child: TextFormField(
                    autocorrect: true,
                    onChanged: (String val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                      if (value!.isEmpty) {
                        return ("Создайте пароль");
                      } else {
                        if (!regex.hasMatch(value)) {
                          setState(() {
                            showError = true;
                          });
                          return '';
                        } else {
                          setState(() {
                            showError = false;
                          });
                          return null;
                        }
                      }
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Пароль',
                      hintStyle: AppTextStyles.body14Secondary.copyWith(
                          color: AppColors.primaryGray,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                HBox(12.h),
                showError?
                Text(
                    '* Пароль должен содержать минимум 6 символов. Чтобы пароль получился супернадежным, добавьте заглавные и строчные буквы, цифры и специальные символы.',
                    style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primaryYellow)
                ):
                Text(
                    'Пароль должен содержать минимум 6 символов. Чтобы пароль получился супернадежным, добавьте заглавные и строчные буквы, цифры и специальные символы.',
                  style: AppTextStyles.bodySecondary
                ),
                HBox(17.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _confirm = !_confirm;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => const BorderSide(
                              width: 2.0, color: AppColors.white),
                        ),
                        checkColor: AppColors.primary,
                        activeColor: AppColors.white,
                        onChanged: (value) {
                          setState(() {
                            _confirm = !_confirm;
                          });
                        },
                        value: _confirm,
                      ),
                      Flexible(
                        child: Text(
                            "Я соглашаюсь с Условиями использования сервиса, а также с передачей и обработкой моих данных в REMONT.KZ.",
                            style: AppTextStyles.bodySecondary),
                      ),
                    ],
                  ),
                ),
                HBox(12.h),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final bool isFilled = isMaskFormatterFilled(maskFormatter, mobilePhone);
                      if (isFilled) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.white,
                                  radius: 25,
                                  animating: true,
                                ),
                              );
                            });
                        var api = await RestServices().registration(
                            email: email,
                            firstName: firstName,
                            lastName: lastName,
                            password: password,
                            username: mobilePhone.replaceAll(RegExp(r'\D'), ''),
                            isClients: widget.isWorkers != null
                                ? widget.isWorkers!
                                ? false
                                : true
                                : true);
                        if (api == 200) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PinCodePage(
                                      mobilePhone.replaceAll(RegExp(r'\D'), ''),
                                      password,
                                      widget.isWorkers,
                                      false)));
                        } else {
                          Navigator.pop(context);
                        }
                      }else{
                        Fluttertoast.showToast(
                            msg: 'Проверьте правильность заполнение номера телефона',
                            textColor: AppColors.blackGreyText,
                            backgroundColor: AppColors.white,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2);

                      }

                    } else {}
                  },
                  child: Container(
                    height: 40.h,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: AppColors.white),
                    child: Text(
                      'Зарегистрироваться',
                      style: AppTextStyles.h18Regular.copyWith(
                          color: AppColors.blackGreyText, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
