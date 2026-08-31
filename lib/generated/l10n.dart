// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Page`
  String get page {
    return Intl.message(
      'Page',
      name: 'page',
      desc: '',
      args: [],
    );
  }

  /// `Pages`
  String get pages {
    return Intl.message(
      'Pages',
      name: 'pages',
      desc: '',
      args: [],
    );
  }

  /// `The page`
  String get the_page {
    return Intl.message(
      'The page',
      name: 'the_page',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get bottom_nav_bar_home {
    return Intl.message(
      'Home',
      name: 'bottom_nav_bar_home',
      desc: '',
      args: [],
    );
  }

  /// `My Library`
  String get bottom_nav_bar_my_library {
    return Intl.message(
      'My Library',
      name: 'bottom_nav_bar_my_library',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get bottom_nav_bar_favorites {
    return Intl.message(
      'Favorites',
      name: 'bottom_nav_bar_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get bottom_nav_bar_settings {
    return Intl.message(
      'Settings',
      name: 'bottom_nav_bar_settings',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get home_page_title1 {
    return Intl.message(
      'Welcome',
      name: 'home_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `Turn your books into\n audiobooks`
  String get home_page_title2 {
    return Intl.message(
      'Turn your books into\n audiobooks',
      name: 'home_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `Upload a book or photograph its pages\n and listen to it anytime`
  String get home_page_title3 {
    return Intl.message(
      'Upload a book or photograph its pages\n and listen to it anytime',
      name: 'home_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `Upload PDF file`
  String get home_page_title4 {
    return Intl.message(
      'Upload PDF file',
      name: 'home_page_title4',
      desc: '',
      args: [],
    );
  }

  /// `Photograph book pages`
  String get home_page_title5 {
    return Intl.message(
      'Photograph book pages',
      name: 'home_page_title5',
      desc: '',
      args: [],
    );
  }

  /// `Upload PDF file`
  String get upload_pdf_page_app_bar {
    return Intl.message(
      'Upload PDF file',
      name: 'upload_pdf_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Drag a PDF file here\n or click to choose`
  String get upload_pdf_page_title1 {
    return Intl.message(
      'Drag a PDF file here\n or click to choose',
      name: 'upload_pdf_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `Choose file`
  String get upload_pdf_page_title2 {
    return Intl.message(
      'Choose file',
      name: 'upload_pdf_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `Book information`
  String get upload_pdf_page_title3 {
    return Intl.message(
      'Book information',
      name: 'upload_pdf_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `Book title`
  String get upload_pdf_page_title4 {
    return Intl.message(
      'Book title',
      name: 'upload_pdf_page_title4',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get uplaod_pdf_page_title5 {
    return Intl.message(
      'Author',
      name: 'uplaod_pdf_page_title5',
      desc: '',
      args: [],
    );
  }

  /// `Number of pages`
  String get uplaod_pdf_page_title6 {
    return Intl.message(
      'Number of pages',
      name: 'uplaod_pdf_page_title6',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get upload_pdf_page_title7 {
    return Intl.message(
      'Next',
      name: 'upload_pdf_page_title7',
      desc: '',
      args: [],
    );
  }

  /// `Photograph book pages`
  String get capture_book_pages_page_app_bar {
    return Intl.message(
      'Photograph book pages',
      name: 'capture_book_pages_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Creating a PDF from the captured pages...`
  String get capture_book_pages_page_loading {
    return Intl.message(
      'Creating a PDF from the captured pages...',
      name: 'capture_book_pages_page_loading',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing_page_app_bar {
    return Intl.message(
      'Processing',
      name: 'processing_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Extracting text from the book...`
  String get processing_page_title1 {
    return Intl.message(
      'Extracting text from the book...',
      name: 'processing_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `This may take a few minutes`
  String get processing_page_title2 {
    return Intl.message(
      'This may take a few minutes',
      name: 'processing_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `Please do not close the app`
  String get processing_page_title3 {
    return Intl.message(
      'Please do not close the app',
      name: 'processing_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `Read text`
  String get pdf_view_page_app_bar {
    return Intl.message(
      'Read text',
      name: 'pdf_view_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Audio file completed`
  String get pdf_view_page_app_toast_title1 {
    return Intl.message(
      'Audio file completed',
      name: 'pdf_view_page_app_toast_title1',
      desc: '',
      args: [],
    );
  }

  /// `Speech generated successfully`
  String get pdf_view_page_app_toast_description1 {
    return Intl.message(
      'Speech generated successfully',
      name: 'pdf_view_page_app_toast_description1',
      desc: '',
      args: [],
    );
  }

  /// `Creating the audio file...`
  String get pdf_view_page_loading {
    return Intl.message(
      'Creating the audio file...',
      name: 'pdf_view_page_loading',
      desc: '',
      args: [],
    );
  }

  /// `Audio file created`
  String get pdf_view_page_app_toast_title2 {
    return Intl.message(
      'Audio file created',
      name: 'pdf_view_page_app_toast_title2',
      desc: '',
      args: [],
    );
  }

  /// `Audio file created successfully`
  String get pdf_view_page_app_toast_description2 {
    return Intl.message(
      'Audio file created successfully',
      name: 'pdf_view_page_app_toast_description2',
      desc: '',
      args: [],
    );
  }

  /// `Listen to the text`
  String get pdf_view_page_title1 {
    return Intl.message(
      'Listen to the text',
      name: 'pdf_view_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `Listen to the entire book`
  String get pdf_view_page_title2 {
    return Intl.message(
      'Listen to the entire book',
      name: 'pdf_view_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get pdf_view_page_title3 {
    return Intl.message(
      'Previous',
      name: 'pdf_view_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `My library`
  String get my_library_page_app_bar {
    return Intl.message(
      'My library',
      name: 'my_library_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Not Completed`
  String get my_library_page_tab1 {
    return Intl.message(
      'Not Completed',
      name: 'my_library_page_tab1',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get my_library_page_tab2 {
    return Intl.message(
      'Completed',
      name: 'my_library_page_tab2',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get my_library_page_tab3 {
    return Intl.message(
      'All',
      name: 'my_library_page_tab3',
      desc: '',
      args: [],
    );
  }

  /// `Search for a book`
  String get my_library_page_title1 {
    return Intl.message(
      'Search for a book',
      name: 'my_library_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `No saved books`
  String get my_library_page_title2 {
    return Intl.message(
      'No saved books',
      name: 'my_library_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `No completed books`
  String get my_library_page_title3 {
    return Intl.message(
      'No completed books',
      name: 'my_library_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `No incomplete books`
  String get my_library_page_title4 {
    return Intl.message(
      'No incomplete books',
      name: 'my_library_page_title4',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites_page_app_bar {
    return Intl.message(
      'Favorites',
      name: 'favorites_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `No favorite books`
  String get favorites_page_title1 {
    return Intl.message(
      'No favorite books',
      name: 'favorites_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_page_app_bar {
    return Intl.message(
      'Settings',
      name: 'settings_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `Voice used`
  String get settings_page_title1 {
    return Intl.message(
      'Voice used',
      name: 'settings_page_title1',
      desc: '',
      args: [],
    );
  }

  /// `Voice 1`
  String get settings_page_title1_value1 {
    return Intl.message(
      'Voice 1',
      name: 'settings_page_title1_value1',
      desc: '',
      args: [],
    );
  }

  /// `Voice 2`
  String get settings_page_title1_value2 {
    return Intl.message(
      'Voice 2',
      name: 'settings_page_title1_value2',
      desc: '',
      args: [],
    );
  }

  /// `Voice 3`
  String get settings_page_title1_value3 {
    return Intl.message(
      'Voice 3',
      name: 'settings_page_title1_value3',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settings_page_title2 {
    return Intl.message(
      'Theme',
      name: 'settings_page_title2',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get settings_page_title2_value1 {
    return Intl.message(
      'System',
      name: 'settings_page_title2_value1',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settings_page_title2_value2 {
    return Intl.message(
      'Light',
      name: 'settings_page_title2_value2',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settings_page_title2_value3 {
    return Intl.message(
      'Dark',
      name: 'settings_page_title2_value3',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settings_page_title3 {
    return Intl.message(
      'Language',
      name: 'settings_page_title3',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get settings_page_title3_value1 {
    return Intl.message(
      'Arabic',
      name: 'settings_page_title3_value1',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get settings_page_title3_value2 {
    return Intl.message(
      'English',
      name: 'settings_page_title3_value2',
      desc: '',
      args: [],
    );
  }

  /// `About the app`
  String get settings_page_title4 {
    return Intl.message(
      'About the app',
      name: 'settings_page_title4',
      desc: '',
      args: [],
    );
  }

  /// `About the app`
  String get about_app_page_app_bar {
    return Intl.message(
      'About the app',
      name: 'about_app_page_app_bar',
      desc: '',
      args: [],
    );
  }

  /// `The app lets you photograph book pages or select images from the gallery, then automatically merge them into a PDF with suitable quality while preserving page dimensions. It also supports text extraction (OCR) from the pages to convert the content into copyable, searchable text, making it easy to review notes, summaries, and documents quickly. We strive for a simple and fast experience while protecting your data privacy.`
  String get about_app_page_title1 {
    return Intl.message(
      'The app lets you photograph book pages or select images from the gallery, then automatically merge them into a PDF with suitable quality while preserving page dimensions. It also supports text extraction (OCR) from the pages to convert the content into copyable, searchable text, making it easy to review notes, summaries, and documents quickly. We strive for a simple and fast experience while protecting your data privacy.',
      name: 'about_app_page_title1',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
