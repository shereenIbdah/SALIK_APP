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

  /// `  Salik `
  String get title {
    return Intl.message(
      '  Salik ',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Salik App`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to Salik App',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore and locate checkpoints easily on an interactive map for a seamless navigation experience.`
  String get welcomeDescription {
    return Intl.message(
      'Explore and locate checkpoints easily on an interactive map for a seamless navigation experience.',
      name: 'welcomeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Get Checkpoint Status`
  String get statusTitle {
    return Intl.message(
      'Get Checkpoint Status',
      name: 'statusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stay updated with real-time checkpoint conditions to plan your route efficiently and avoid delays.`
  String get statusDescription {
    return Intl.message(
      'Stay updated with real-time checkpoint conditions to plan your route efficiently and avoid delays.',
      name: 'statusDescription',
      desc: '',
      args: [],
    );
  }

  /// `Give Feedback`
  String get feedbackTitle {
    return Intl.message(
      'Give Feedback',
      name: 'feedbackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your input about checkpoint conditions to help others stay informed and improve route planning.`
  String get feedbackDescription {
    return Intl.message(
      'Share your input about checkpoint conditions to help others stay informed and improve route planning.',
      name: 'feedbackDescription',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get buttonContinue {
    return Intl.message(
      'Continue',
      name: 'buttonContinue',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcomeText {
    return Intl.message(
      'Welcome',
      name: 'welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Discover the checkpoints and roads ahead!`
  String get welcomeSubtitle {
    return Intl.message(
      'Discover the checkpoints and roads ahead!',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpButton {
    return Intl.message(
      'Sign Up',
      name: 'signUpButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signInButton {
    return Intl.message(
      'Sign In',
      name: 'signInButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get loginTitle {
    return Intl.message(
      'Login to your account',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone Number`
  String get emailPhoneLabel {
    return Intl.message(
      'Email or Phone Number',
      name: 'emailPhoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get noAccountText {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'noAccountText',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUpLink {
    return Intl.message(
      'Sign up',
      name: 'signUpLink',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Account`
  String get createAccount {
    return Intl.message(
      'Create Your Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone Number`
  String get emailPhone {
    return Intl.message(
      'Email or Phone Number',
      name: 'emailPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Select a city`
  String get selectCity {
    return Intl.message(
      'Select a city',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `Are you a frequent driver?`
  String get frequentDriverQuestion {
    return Intl.message(
      'Are you a frequent driver?',
      name: 'frequentDriverQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get fullNameValidation {
    return Intl.message(
      'Please enter your full name',
      name: 'fullNameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emailValidation {
    return Intl.message(
      'Please enter your email',
      name: 'emailValidation',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get passwordValidation {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'passwordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordValidation {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordValidation',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatchValidation {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatchValidation',
      desc: '',
      args: [],
    );
  }

  /// `Your email has been verified!`
  String get emailVerified {
    return Intl.message(
      'Your email has been verified!',
      name: 'emailVerified',
      desc: '',
      args: [],
    );
  }

  /// `Please check your email and click the verification link to complete the sign-up process.`
  String get checkEmail {
    return Intl.message(
      'Please check your email and click the verification link to complete the sign-up process.',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `Did not receive an email?`
  String get didNotReceiveEmail {
    return Intl.message(
      'Did not receive an email?',
      name: 'didNotReceiveEmail',
      desc: '',
      args: [],
    );
  }

  /// `You can resend in: {countdown} seconds`
  String resendCountdown(Object countdown) {
    return Intl.message(
      'You can resend in: $countdown seconds',
      name: 'resendCountdown',
      desc: '',
      args: [countdown],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Interactive Map`
  String get mapTitle {
    return Intl.message(
      'Interactive Map',
      name: 'mapTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine your location.`
  String get unableToDetermineLocation {
    return Intl.message(
      'Unable to determine your location.',
      name: 'unableToDetermineLocation',
      desc: '',
      args: [],
    );
  }

  /// `Routing enabled. Tap on the map to set your destination.`
  String get routingEnabledMessage {
    return Intl.message(
      'Routing enabled. Tap on the map to set your destination.',
      name: 'routingEnabledMessage',
      desc: '',
      args: [],
    );
  }

  /// `Search Checkpoint`
  String get searchCheckpoint {
    return Intl.message(
      'Search Checkpoint',
      name: 'searchCheckpoint',
      desc: '',
      args: [],
    );
  }

  /// `Enter checkpoint name`
  String get enterCheckpointName {
    return Intl.message(
      'Enter checkpoint name',
      name: 'enterCheckpointName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid name.`
  String get enterValidName {
    return Intl.message(
      'Enter a valid name.',
      name: 'enterValidName',
      desc: '',
      args: [],
    );
  }

  /// `Moved to {checkpointName}`
  String movedToCheckpoint(Object checkpointName) {
    return Intl.message(
      'Moved to $checkpointName',
      name: 'movedToCheckpoint',
      desc: '',
      args: [checkpointName],
    );
  }

  /// `Checkpoint not found.`
  String get checkpointNotFound {
    return Intl.message(
      'Checkpoint not found.',
      name: 'checkpointNotFound',
      desc: '',
      args: [],
    );
  }

  /// ` Checkpoints`
  String get showAllCheckpoints {
    return Intl.message(
      ' Checkpoints',
      name: 'showAllCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `Route to Destination`
  String get routeToDestination {
    return Intl.message(
      'Route to Destination',
      name: 'routeToDestination',
      desc: '',
      args: [],
    );
  }

  /// `Your Place`
  String get yourPlace {
    return Intl.message(
      'Your Place',
      name: 'yourPlace',
      desc: '',
      args: [],
    );
  }

  /// `Map Options`
  String get mapOptions {
    return Intl.message(
      'Map Options',
      name: 'mapOptions',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoint: {name}`
  String checkpoint(Object name) {
    return Intl.message(
      'Checkpoint: $name',
      name: 'checkpoint',
      desc: '',
      args: [name],
    );
  }

  /// `Cities and Checkpoints`
  String get citiesAndCheckpoints {
    return Intl.message(
      'Cities and Checkpoints',
      name: 'citiesAndCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `Add Checkpoint`
  String get addCheckpoint {
    return Intl.message(
      'Add Checkpoint',
      name: 'addCheckpoint',
      desc: '',
      args: [],
    );
  }

  /// `Contribute to the App`
  String get contribute {
    return Intl.message(
      'Contribute to the App',
      name: 'contribute',
      desc: '',
      args: [],
    );
  }

  /// `Accident Reports`
  String get accidentReports {
    return Intl.message(
      'Accident Reports',
      name: 'accidentReports',
      desc: '',
      args: [],
    );
  }

  /// `Accident News`
  String get accidentNews {
    return Intl.message(
      'Accident News',
      name: 'accidentNews',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Search for a city or checkpoint`
  String get searchForCityOrChckpoint {
    return Intl.message(
      'Search for a city or checkpoint',
      name: 'searchForCityOrChckpoint',
      desc: '',
      args: [],
    );
  }

  /// `Adding new checkpoint`
  String get addNewCheckpoint {
    return Intl.message(
      'Adding new checkpoint',
      name: 'addNewCheckpoint',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoint Name`
  String get checkpointName {
    return Intl.message(
      'Checkpoint Name',
      name: 'checkpointName',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get Longitude {
    return Intl.message(
      'Longitude',
      name: 'Longitude',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `New checkpoint added and associated with {city} `
  String checkpointAdded(Object city) {
    return Intl.message(
      'New checkpoint added and associated with $city ',
      name: 'checkpointAdded',
      desc: '',
      args: [city],
    );
  }

  /// `Contribute to the App`
  String get contributeTitle {
    return Intl.message(
      'Contribute to the App',
      name: 'contributeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Suggest an Idea`
  String get suggestIdea {
    return Intl.message(
      'Suggest an Idea',
      name: 'suggestIdea',
      desc: '',
      args: [],
    );
  }

  /// `Report an accident in a specific city`
  String get reportAccident {
    return Intl.message(
      'Report an accident in a specific city',
      name: 'reportAccident',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message(
      'Approve',
      name: 'approve',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Active Notifications fot city`
  String get activeNotifications {
    return Intl.message(
      'Active Notifications fot city',
      name: 'activeNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission`
  String get locationPermission {
    return Intl.message(
      'Location Permission',
      name: 'locationPermission',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordText {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Logout`
  String get logoutConfirmationTitle {
    return Intl.message(
      'Confirm Logout',
      name: 'logoutConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmationMessage {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while logging out: {error}`
  String logoutError(Object error) {
    return Intl.message(
      'An error occurred while logging out: $error',
      name: 'logoutError',
      desc: '',
      args: [error],
    );
  }

  /// `Convert language to Arabic`
  String get convertLanguage {
    return Intl.message(
      'Convert language to Arabic',
      name: 'convertLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Arabic`
  String get switchToArabic {
    return Intl.message(
      'Switch to Arabic',
      name: 'switchToArabic',
      desc: '',
      args: [],
    );
  }

  /// `تغيير اللغة إلى الإنجليزية`
  String get switchToEnglish {
    return Intl.message(
      'تغيير اللغة إلى الإنجليزية',
      name: 'switchToEnglish',
      desc: '',
      args: [],
    );
  }

  /// `How to Use Salik`
  String get guideTitle {
    return Intl.message(
      'How to Use Salik',
      name: 'guideTitle',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get end {
    return Intl.message(
      'End',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  /// `Please select a city`
  String get pleaseSelectCity {
    return Intl.message(
      'Please select a city',
      name: 'pleaseSelectCity',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoints between two cities`
  String get checkpointBetweenCities {
    return Intl.message(
      'Checkpoints between two cities',
      name: 'checkpointBetweenCities',
      desc: '',
      args: [],
    );
  }

  /// `Select the city you will exit from`
  String get selectCityToExit {
    return Intl.message(
      'Select the city you will exit from',
      name: 'selectCityToExit',
      desc: '',
      args: [],
    );
  }

  /// `Adapted city`
  String get adaptedcity {
    return Intl.message(
      'Adapted city',
      name: 'adaptedcity',
      desc: '',
      args: [],
    );
  }

  /// `Select the city you will go to`
  String get selectCityToEnter {
    return Intl.message(
      'Select the city you will go to',
      name: 'selectCityToEnter',
      desc: '',
      args: [],
    );
  }

  /// `Destination city`
  String get destinationCity {
    return Intl.message(
      'Destination city',
      name: 'destinationCity',
      desc: '',
      args: [],
    );
  }

  /// `Display Checkpoints`
  String get displayCheckpoints {
    return Intl.message(
      'Display Checkpoints',
      name: 'displayCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `City-to-City Checkpoints`
  String get cityToCityCheckpoints {
    return Intl.message(
      'City-to-City Checkpoints',
      name: 'cityToCityCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoints Added by User`
  String get checkpointAddedByUser {
    return Intl.message(
      'Checkpoints Added by User',
      name: 'checkpointAddedByUser',
      desc: '',
      args: [],
    );
  }

  /// `User Suggestions`
  String get userSuggestions {
    return Intl.message(
      'User Suggestions',
      name: 'userSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred! Please try again.`
  String get errorOccurred {
    return Intl.message(
      'An error occurred! Please try again.',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `No data available.`
  String get noDataAvailable {
    return Intl.message(
      'No data available.',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get Description {
    return Intl.message(
      'Description',
      name: 'Description',
      desc: '',
      args: [],
    );
  }

  /// `Reported from `
  String get ReportedAt {
    return Intl.message(
      'Reported from ',
      name: 'ReportedAt',
      desc: '',
      args: [],
    );
  }

  /// `Community Submissions`
  String get userReport {
    return Intl.message(
      'Community Submissions',
      name: 'userReport',
      desc: '',
      args: [],
    );
  }

  /// `Accident Reports`
  String get accidentReportss {
    return Intl.message(
      'Accident Reports',
      name: 'accidentReportss',
      desc: '',
      args: [],
    );
  }

  /// `Feedbacks History`
  String get feedbacksHistory {
    return Intl.message(
      'Feedbacks History',
      name: 'feedbacksHistory',
      desc: '',
      args: [],
    );
  }

  /// ` Set Destination`
  String get SetDestination {
    return Intl.message(
      ' Set Destination',
      name: 'SetDestination',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to set this location as your destination?`
  String get destinationConfirmation {
    return Intl.message(
      'Do you want to set this location as your destination?',
      name: 'destinationConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Get Route`
  String get getRoute {
    return Intl.message(
      'Get Route',
      name: 'getRoute',
      desc: '',
      args: [],
    );
  }

  /// `Remove Marker`
  String get RemoveMarker {
    return Intl.message(
      'Remove Marker',
      name: 'RemoveMarker',
      desc: '',
      args: [],
    );
  }

  /// `Press on the city name to view the checkpoints within its range`
  String get pressoncity {
    return Intl.message(
      'Press on the city name to view the checkpoints within its range',
      name: 'pressoncity',
      desc: '',
      args: [],
    );
  }

  /// `Best Way`
  String get bestWay {
    return Intl.message(
      'Best Way',
      name: 'bestWay',
      desc: '',
      args: [],
    );
  }

  /// `Another Way`
  String get anotherWay {
    return Intl.message(
      'Another Way',
      name: 'anotherWay',
      desc: '',
      args: [],
    );
  }

  /// `This process takes some time, please wait...`
  String get wait {
    return Intl.message(
      'This process takes some time, please wait...',
      name: 'wait',
      desc: '',
      args: [],
    );
  }

  /// `Search by checkpoint name`
  String get searchByName {
    return Intl.message(
      'Search by checkpoint name',
      name: 'searchByName',
      desc: '',
      args: [],
    );
  }

  /// `Checkpoint information`
  String get checkpointInfo {
    return Intl.message(
      'Checkpoint information',
      name: 'checkpointInfo',
      desc: '',
      args: [],
    );
  }

  /// ` Idea Name`
  String get ideaName {
    return Intl.message(
      ' Idea Name',
      name: 'ideaName',
      desc: '',
      args: [],
    );
  }

  /// `Enter the idea name`
  String get enterIdeaName {
    return Intl.message(
      'Enter the idea name',
      name: 'enterIdeaName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description`
  String get enterdescription {
    return Intl.message(
      'Enter a description',
      name: 'enterdescription',
      desc: '',
      args: [],
    );
  }

  /// `Submit Idea`
  String get submitIdea {
    return Intl.message(
      'Submit Idea',
      name: 'submitIdea',
      desc: '',
      args: [],
    );
  }

  /// `Salik Statistics`
  String get SalikStatistics {
    return Intl.message(
      'Salik Statistics',
      name: 'SalikStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Salik statistics and news`
  String get reports {
    return Intl.message(
      'Salik statistics and news',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Total number of checkpoints`
  String get totalNumberOfCheckpoints {
    return Intl.message(
      'Total number of checkpoints',
      name: 'totalNumberOfCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `Number of checkpoints in your city`
  String get numOfCheclpointsInCity {
    return Intl.message(
      'Number of checkpoints in your city',
      name: 'numOfCheclpointsInCity',
      desc: '',
      args: [],
    );
  }

  /// `Nearest checpoints`
  String get nearestCheckpoints {
    return Intl.message(
      'Nearest checpoints',
      name: 'nearestCheckpoints',
      desc: '',
      args: [],
    );
  }

  /// `Latest news about accidents:`
  String get lastNews {
    return Intl.message(
      'Latest news about accidents:',
      name: 'lastNews',
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
