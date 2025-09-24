import 'package:flutter/material.dart';
import '../menu/menu_items_builder.dart';
import '../../services/menu_action_service.dart';
import 'package:get/get.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => MenuActionService.handleMenuAction(value),
      itemBuilder: (BuildContext context) => MenuItemsBuilder.buildMenuItems(),
      icon: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}
