import 'package:flutter/material.dart';
import 'package:nijaat_app/pages/about_us.dart';
import 'package:nijaat_app/pages/ai_chatbot_page.dart';
import 'package:nijaat_app/pages/article_page.dart';
import 'package:nijaat_app/pages/book_appointment_page.dart';
import 'package:nijaat_app/pages/my_records_page.dart';
import 'package:nijaat_app/pages/prescription_page.dart';
import 'package:nijaat_app/pages/profile_page.dart';
import 'package:nijaat_app/pages/reset_password_page.dart';
import 'package:nijaat_app/pages/upload_doc.dart';
import 'package:nijaat_app/routes/routes.dart';

import '../pages/Homepage/home_page.dart';
import '../pages/Homepage/splash_screen.dart';

Route<dynamic> getRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return buildRoute(const SplashScreen(), settings: settings);
    case AppRoutes.home:
      return buildRoute(const HomePage(), settings: settings);
    case AppRoutes.main:
      return buildRoute(const MainPage(), settings: settings);
    case AppRoutes.article:
      return buildRoute(const ArticlePage(), settings: settings);
    case AppRoutes.bookAppointment:
      return buildRoute(const BookAppointment(), settings: settings);
    case AppRoutes.myRecords:
      return buildRoute(const MyRecords(), settings: settings);
    case AppRoutes.prescription:
      return buildRoute(const Prescription(), settings: settings);
    case AppRoutes.uploadDoc:
      return buildRoute(const UploadDoc(), settings: settings);
    case AppRoutes.resetPassword:
      return buildRoute(const ResetPasswordPage(), settings: settings);
    case AppRoutes.profile:
      return buildRoute(const ProfilePage(), settings: settings);
    case AppRoutes.aboutUS:
      return buildRoute(const AboutUs(), settings: settings);
    case AppRoutes.aiPage:
      return buildRoute(const AiChatPage(), settings: settings);
    default:
      return buildRoute(const SplashScreen(), settings: settings);
  }
}

MaterialPageRoute buildRoute(Widget child, {RouteSettings? settings}) =>
    MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );