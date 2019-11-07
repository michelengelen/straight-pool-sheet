import 'package:flutter/material.dart';
import 'package:sps/generated/i18n.dart';

/// Possible errors:
///   - "ERROR_INVALID_EMAIL"
///   - "ERROR_WRONG_PASSWORD"
///   - "ERROR_USER_NOT_FOUND"
///   - "ERROR_USER_DISABLED"
///   - "ERROR_TOO_MANY_REQUESTS"
///   - "ERROR_INVALID_CREDENTIAL"
///   - "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL"
///   - "ERROR_OPERATION_NOT_ALLOWED"
///   - "ERROR_CANCELLED_BY_USER"
///   - "ERROR_CRITICAL"
///   - "ERROR_UNDEFINED" (this is the default)

String getAuthErrorMessage(BuildContext context, String type) {
  switch (type) {
    case 'ERROR_INVALID_EMAIL':
      return S.of(context).ERROR_INVALID_EMAIL;
      break;
    case 'ERROR_WRONG_PASSWORD':
      return S.of(context).ERROR_WRONG_PASSWORD;
      break;
    case 'ERROR_USER_NOT_FOUND':
      return S.of(context).ERROR_USER_NOT_FOUND;
      break;
    case 'ERROR_USER_DISABLED':
      return S.of(context).ERROR_USER_DISABLED;
      break;
    case 'ERROR_TOO_MANY_REQUESTS':
      return S.of(context).ERROR_TOO_MANY_REQUESTS;
      break;
    case 'ERROR_INVALID_CREDENTIAL':
      return S.of(context).ERROR_INVALID_CREDENTIAL;
      break;
    case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
      return S.of(context).ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL;
      break;
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return S.of(context).ERROR_OPERATION_NOT_ALLOWED;
      break;
    case 'ERROR_CANCELLED_BY_USER':
      return S.of(context).ERROR_CANCELLED_BY_USER;
      break;
    case 'ERROR_CRITICAL':
      return S.of(context).ERROR_CRITICAL;
      break;
    case 'ERROR_UNDEFINED':
    default:
      return S.of(context).ERROR_UNDEFINED;
      break;
  }
}

String getProviderName(String providerURL) {
  switch (providerURL) {
    case 'facebook.com':
      return 'facebook';
      break;
    case 'google.com':
      return 'google';
      break;
    default:
      return null;
      break;
  }
}