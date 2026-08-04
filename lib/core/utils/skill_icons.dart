import 'package:flutter/material.dart';

/// Allowed `SkillItem.iconKey` values and their rendered icon. Shared
/// between the public skills widget and the admin Skills workspace so the
/// admin's icon picker always matches what actually renders.
const List<String> kSkillIconKeys = [
  'fire',
  'code',
  'phone_android',
  'language',
  'palette',
  'javascript',
  'database',
  'cloud',
  'terminal',
  'layers',
  'bolt',
  'star',
];

IconData iconForSkillKey(String key) {
  switch (key) {
    case 'fire':
      return Icons.local_fire_department;
    case 'code':
      return Icons.code;
    case 'phone_android':
      return Icons.phone_android;
    case 'language':
      return Icons.language;
    case 'palette':
      return Icons.palette;
    case 'javascript':
      return Icons.javascript;
    case 'database':
      return Icons.storage;
    case 'cloud':
      return Icons.cloud;
    case 'terminal':
      return Icons.terminal;
    case 'layers':
      return Icons.layers;
    case 'bolt':
      return Icons.bolt;
    case 'star':
      return Icons.star;
    default:
      return Icons.code;
  }
}
