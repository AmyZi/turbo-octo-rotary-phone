import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/error_response.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class ApiChecker {
  /// When [clearSessionOnUnauthorized] is false, 401 shows an error only (no forced sign-in).
  static void checkApi(Response response, {bool clearSessionOnUnauthorized = true}) {
    if(response.statusCode == 401) {
      if (clearSessionOnUnauthorized) {
        Get.find<ConfigController>().removeSharedData();
        Get.offAll(()=> const SignInScreen());
      } else {
        showCustomSnackBar(_messageFromResponse(response));
      }
      return;
    }else if(response.statusCode == 403) {
      ErrorResponse errorResponse;
      errorResponse = ErrorResponse.fromJson(response.body);
      if(errorResponse.errors != null && errorResponse.errors!.isNotEmpty){
        showCustomSnackBar(errorResponse.errors![0].message!);
      }else{
        showCustomSnackBar(response.body['message']);
      }

    }else if(response.statusCode == 422) {
      ErrorResponse errorResponse;
      errorResponse = ErrorResponse.fromJson(response.body);
      if(errorResponse.errors != null && errorResponse.errors!.isNotEmpty){
        showCustomSnackBar(errorResponse.errors![0].message!);
      }else{
        showCustomSnackBar(response.body['message']);
      }

    }else if(response.statusCode == 500){
      showCustomSnackBar(response.statusText!);
    }else {
      showCustomSnackBar(response.statusText!);
    }
  }

  static String _messageFromResponse(Response response) {
    try {
      if (response.body != null && response.body is Map) {
        final body = response.body as Map<String, dynamic>;
        final errors = body['errors'];
        if (errors is List && errors.isNotEmpty) {
          final first = errors.first;
          if (first is Map && first['message'] != null) {
            return first['message'].toString();
          }
        }
        if (body['message'] != null) {
          return body['message'].toString();
        }
      }
    } catch (_) {}
    return response.statusText ?? 'Request failed';
  }
}
