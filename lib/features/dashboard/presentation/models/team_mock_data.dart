import 'package:life_insurance/core/core.dart' show PrototypeRole, PrototypeRoleId;

enum TeamScope { personal, total }

enum MdrtLane { all, qualified, inProgress }

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.code,
    required this.roleLabel,
    required this.ape,
    required this.fyp,
    required this.sfyp,
    required this.wtdFyp,
    required this.mdrtPct,
    required this.qualified,
    this.belowTarget = false,
    this.momDelta = '+6.2%',
  });

  final String id;
  final String name;
  final String code;
  final String roleLabel;
  final String ape;
  final String fyp;
  final String sfyp;
  final String wtdFyp;
  final double mdrtPct;
  final bool qualified;
  final bool belowTarget;
  final String momDelta;

  String get mdrtLabel => qualified ? 'Qualified' : 'In progress';

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class TeamLine {
  const TeamLine({
    required this.id,
    required this.name,
    required this.roleLabel,
    required this.faCount,
    required this.fypPct,
  });

  final String id;
  final String name;
  final String roleLabel;
  final int faCount;
  final String fypPct;
}

class TeamSnapshot {
  const TeamSnapshot({
    required this.personalCount,
    required this.groupCount,
    required this.hasIndirect,
    required this.apeActual,
    required this.apeTarget,
    required this.apePct,
    required this.fypActual,
    required this.fypTarget,
    required this.fypPct,
    required this.sfypActual,
    required this.sfypTarget,
    required this.sfypPct,
    required this.wtdActual,
    required this.wtdTarget,
    required this.wtdPct,
    required this.members,
    required this.groupLines,
  });

  final int personalCount;
  final int groupCount;
  final bool hasIndirect;
  final String apeActual;
  final String apeTarget;
  final String apePct;
  final String fypActual;
  final String fypTarget;
  final String fypPct;
  final String sfypActual;
  final String sfypTarget;
  final String sfypPct;
  final String wtdActual;
  final String wtdTarget;
  final String wtdPct;
  final List<TeamMember> members;
  final List<TeamLine> groupLines;

  String pulseSubtitle(TeamScope scope) {
    if (scope == TeamScope.total && hasIndirect) {
      return 'Total group · $groupCount FAs';
    }
    return 'Personal team · $personalCount FAs';
  }
}

/// Mock trees per preview role (docs/71). Display-only — no client math.
abstract final class TeamMockData {
  static TeamScope scope = TeamScope.personal;

  static TeamSnapshot get current => forRole(PrototypeRole.id);

  static TeamSnapshot forRole(PrototypeRoleId role) {
    switch (role) {
      case PrototypeRoleId.fa:
        return _empty;
      case PrototypeRoleId.teamLead:
        return _tl;
      case PrototypeRoleId.am:
        return _am;
      case PrototypeRoleId.sam:
        return _sam;
      case PrototypeRoleId.dm:
        return _dm;
    }
  }

  static TeamMember? memberById(String id) {
    for (final snap in [_tl, _am, _sam, _dm]) {
      for (final m in snap.members) {
        if (m.id == id) return m;
      }
    }
    return null;
  }

  static List<TeamMember> mdrtLane(MdrtLane lane) {
    final all = current.members;
    switch (lane) {
      case MdrtLane.all:
        return all;
      case MdrtLane.qualified:
        return all.where((m) => m.qualified).toList();
      case MdrtLane.inProgress:
        return all.where((m) => !m.qualified).toList();
    }
  }

  static const _empty = TeamSnapshot(
    personalCount: 0,
    groupCount: 0,
    hasIndirect: false,
    apeActual: '0.00',
    apeTarget: '0.00',
    apePct: '0%',
    fypActual: '0.00',
    fypTarget: '0.00',
    fypPct: '0%',
    sfypActual: '0.00',
    sfypTarget: '0.00',
    sfypPct: '0%',
    wtdActual: '0.00',
    wtdTarget: '0.00',
    wtdPct: '0%',
    members: [],
    groupLines: [],
  );

  static const _tlMembers = <TeamMember>[
    TeamMember(
      id: 'fa-htet',
      name: 'Mg Htet',
      code: 'YGN/FA/2022/0142',
      roleLabel: 'FA',
      ape: '4,820,000.00',
      fyp: '6,150,000.00',
      sfyp: '1,240,000.00',
      wtdFyp: '5,840,000.00',
      mdrtPct: 0.72,
      qualified: false,
    ),
    TeamMember(
      id: 'fa-aye',
      name: 'Daw Aye Aye',
      code: 'YGN/FA/2021/0088',
      roleLabel: 'FA',
      ape: '7,210,000.00',
      fyp: '9,400,000.00',
      sfyp: '2,100,000.00',
      wtdFyp: '8,960,000.00',
      mdrtPct: 1.04,
      qualified: true,
    ),
    TeamMember(
      id: 'fa-ko',
      name: 'Ko Min Thu',
      code: 'YGN/FA/2023/0210',
      roleLabel: 'FA',
      ape: '2,150,000.00',
      fyp: '2,480,000.00',
      sfyp: '420,000.00',
      wtdFyp: '2,310,000.00',
      mdrtPct: 0.31,
      qualified: false,
      belowTarget: true,
      momDelta: '-4.1%',
    ),
    TeamMember(
      id: 'fa-su',
      name: 'Ma Su Mon',
      code: 'YGN/FA/2020/0033',
      roleLabel: 'FA',
      ape: '5,640,000.00',
      fyp: '7,020,000.00',
      sfyp: '1,680,000.00',
      wtdFyp: '6,710,000.00',
      mdrtPct: 0.88,
      qualified: false,
    ),
  ];

  static const _tl = TeamSnapshot(
    personalCount: 4,
    groupCount: 4,
    hasIndirect: false,
    apeActual: '19,820,000.00',
    apeTarget: '22,000,000.00',
    apePct: '90%',
    fypActual: '25,050,000.00',
    fypTarget: '28,000,000.00',
    fypPct: '89%',
    sfypActual: '5,440,000.00',
    sfypTarget: '6,000,000.00',
    sfypPct: '91%',
    wtdActual: '23,820,000.00',
    wtdTarget: '26,500,000.00',
    wtdPct: '90%',
    members: _tlMembers,
    groupLines: [],
  );

  static const _amMembers = <TeamMember>[
    ..._tlMembers,
    TeamMember(
      id: 'fa-win',
      name: 'U Win Naing',
      code: 'YGN/FA/2019/0012',
      roleLabel: 'FA',
      ape: '8,900,000.00',
      fyp: '11,200,000.00',
      sfyp: '2,850,000.00',
      wtdFyp: '10,640,000.00',
      mdrtPct: 1.12,
      qualified: true,
      momDelta: '+11.0%',
    ),
    TeamMember(
      id: 'fa-nwe',
      name: 'Ma Nwe Nwe',
      code: 'YGN/FA/2024/0441',
      roleLabel: 'FA',
      ape: '1,640,000.00',
      fyp: '1,890,000.00',
      sfyp: '210,000.00',
      wtdFyp: '1,720,000.00',
      mdrtPct: 0.18,
      qualified: false,
      belowTarget: true,
      momDelta: '-8.4%',
    ),
  ];

  static const _am = TeamSnapshot(
    personalCount: 6,
    groupCount: 6,
    hasIndirect: false,
    apeActual: '30,360,000.00',
    apeTarget: '34,000,000.00',
    apePct: '89%',
    fypActual: '38,140,000.00',
    fypTarget: '42,000,000.00',
    fypPct: '91%',
    sfypActual: '8,500,000.00',
    sfypTarget: '9,200,000.00',
    sfypPct: '92%',
    wtdActual: '36,180,000.00',
    wtdTarget: '40,000,000.00',
    wtdPct: '90%',
    members: _amMembers,
    groupLines: [],
  );

  static const _sam = TeamSnapshot(
    personalCount: 3,
    groupCount: 18,
    hasIndirect: true,
    apeActual: '86,400,000.00',
    apeTarget: '92,000,000.00',
    apePct: '94%',
    fypActual: '108,200,000.00',
    fypTarget: '118,000,000.00',
    fypPct: '92%',
    sfypActual: '24,100,000.00',
    sfypTarget: '26,000,000.00',
    sfypPct: '93%',
    wtdActual: '102,500,000.00',
    wtdTarget: '112,000,000.00',
    wtdPct: '91%',
    members: _amMembers,
    groupLines: [
      TeamLine(
        id: 'am-1',
        name: 'Daw May Chan',
        roleLabel: 'AM',
        faCount: 6,
        fypPct: '91%',
      ),
      TeamLine(
        id: 'am-2',
        name: 'U Kyaw Zin',
        roleLabel: 'AM',
        faCount: 7,
        fypPct: '88%',
      ),
      TeamLine(
        id: 'am-3',
        name: 'Daw Hnin Ei',
        roleLabel: 'AM',
        faCount: 5,
        fypPct: '97%',
      ),
    ],
  );

  static const _dm = TeamSnapshot(
    personalCount: 2,
    groupCount: 42,
    hasIndirect: true,
    apeActual: '198,500,000.00',
    apeTarget: '220,000,000.00',
    apePct: '90%',
    fypActual: '248,600,000.00',
    fypTarget: '275,000,000.00',
    fypPct: '90%',
    sfypActual: '54,200,000.00',
    sfypTarget: '60,000,000.00',
    sfypPct: '90%',
    wtdActual: '236,400,000.00',
    wtdTarget: '260,000,000.00',
    wtdPct: '91%',
    members: _amMembers,
    groupLines: [
      TeamLine(
        id: 'sam-1',
        name: 'U Aung Myint',
        roleLabel: 'SAM',
        faCount: 18,
        fypPct: '92%',
      ),
      TeamLine(
        id: 'sam-2',
        name: 'Daw Thida',
        roleLabel: 'SAM',
        faCount: 24,
        fypPct: '87%',
      ),
    ],
  );
}
