import 'package:flutter/foundation.dart';

/// Prototype session role (docs/71). Resets to FA on logout. No Core API.
enum PrototypeRoleId { fa, teamLead, am, sam, dm }

abstract final class PrototypeRole {
  static final ValueNotifier<PrototypeRoleId> current =
      ValueNotifier(PrototypeRoleId.fa);

  static PrototypeRoleId get id => current.value;

  static void set(PrototypeRoleId next) => current.value = next;

  static void reset() => current.value = PrototypeRoleId.fa;

  static String get chipLabel {
    switch (id) {
      case PrototypeRoleId.fa:
        return 'FA';
      case PrototypeRoleId.teamLead:
        return 'TL';
      case PrototypeRoleId.am:
        return 'AM';
      case PrototypeRoleId.sam:
        return 'SAM';
      case PrototypeRoleId.dm:
        return 'DM';
    }
  }

  static String get previewTitle {
    switch (id) {
      case PrototypeRoleId.fa:
        return 'Financial Advisor';
      case PrototypeRoleId.teamLead:
        return 'Team Lead';
      case PrototypeRoleId.am:
        return 'Agency Manager';
      case PrototypeRoleId.sam:
        return 'Senior Agency Manager';
      case PrototypeRoleId.dm:
        return 'District Manager';
    }
  }

  static bool get canSell => true;

  static bool get canViewOwnKpis => true;

  /// Downline exists — Team pulse + hub (FR-02.3).
  static bool get canViewTeam => id != PrototypeRoleId.fa;

  /// SAM / DM have indirect lines → show Total Group.
  static bool get hasIndirect =>
      id == PrototypeRoleId.sam || id == PrototypeRoleId.dm;
}
