import 'dialog_service.dart';

class MenuActionService {
  static void handleMenuAction(String value) {
    switch (value) {
      case 'profile':
        DialogService.showProfileDialog();
        break;
      case 'edit_profile':
        break;
      case 'logout':
        DialogService.showLogoutConfirmation();
        break;
    }
  }
}
