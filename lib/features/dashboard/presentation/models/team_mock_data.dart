import 'package:life_insurance/core/core.dart' show PrototypeRole, PrototypeRoleId;

enum TeamScope { personal, total }

enum MdrtLane { all, qualified, inProgress, notYet }

enum TeamBadgeKind { qualified, inProgress, notYet, belowTarget, onTrack }

class TeamLineArgs {
  const TeamLineArgs({this.lineId, this.title, this.breadcrumb});

  final String? lineId;
  final String? title;
  final String? breadcrumb;
}

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
    this.lineId = '',
    this.actualCompact = '',
    this.targetCompact = '',
    this.achievement = 0,
    this.apeTarget = '',
    this.fypTarget = '',
    this.sfypTarget = '',
    this.wtdTarget = '',
    this.mdrtOfTarget = '',
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
  final String lineId;
  final String actualCompact;
  final String targetCompact;
  final double achievement;
  final String apeTarget;
  final String fypTarget;
  final String sfypTarget;
  final String wtdTarget;
  final String mdrtOfTarget;

  String get mdrtLabel => qualified ? 'Qualified' : 'In progress';

  double get ringValue {
    if (achievement > 0) return achievement.clamp(0.0, 1.0);
    return mdrtPct.clamp(0.0, 1.0);
  }

  String get achievementLabel => '${(ringValue * 100).round()}%';

  TeamBadgeKind get badgeKind {
    if (qualified) return TeamBadgeKind.qualified;
    if (belowTarget) return TeamBadgeKind.belowTarget;
    if (mdrtPct < 0.35) return TeamBadgeKind.notYet;
    if (mdrtPct >= 0.65) return TeamBadgeKind.inProgress;
    return TeamBadgeKind.onTrack;
  }

  bool get isNotYet => !qualified && mdrtPct < 0.35;

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
    this.region = '',
    this.actual = '',
    this.target = '',
    this.pctValue = 0,
  });

  final String id;
  final String name;
  final String roleLabel;
  final int faCount;
  final String fypPct;
  final String region;
  final String actual;
  final String target;
  final double pctValue;

  double get barValue => pctValue > 0 ? pctValue : _parse(fypPct);

  static double _parse(String pct) {
    final n = double.tryParse(pct.replaceAll('%', '').trim());
    if (n == null) return 0;
    return n > 1 ? n / 100 : n;
  }
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
    this.overallPct = 0,
    this.overallActual = '',
    this.overallTarget = '',
    this.momDelta = '+12.5%',
    this.samCount = 0,
    this.amCount = 0,
    this.faCount = 0,
    this.mdrtQualified = 0,
    this.showSam = false,
    this.showAm = false,
    this.ownOverallPct = 0.71,
    this.ownFyp = '8,400,000.00',
    this.ownApe = '6,200,000.00',
    this.ownMdrt = '64%',
    this.ownNewPolicies = '4',
    this.ownActivePolicies = '20',
    this.ownApeTarget = '8,700,000.00',
    this.ownFypTarget = '11,800,000.00',
    this.ownSfyp = '1,680,000.00',
    this.ownSfypTarget = '2,400,000.00',
    this.ownWtd = '7,980,000.00',
    this.ownWtdTarget = '11,200,000.00',
    this.ownApePct = '71%',
    this.ownFypPct = '71%',
    this.ownSfypPct = '70%',
    this.ownWtdPct = '71%',
    this.ownActualCompact = '8.4M',
    this.ownTargetCompact = '11.8M',
    this.ownMomDelta = '+4.2%',
    this.ownMdrtPct = 0.64,
    this.ownMdrtQualified = false,
    this.periodLabel = '14 Aug 2026',
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
  final double overallPct;
  final String overallActual;
  final String overallTarget;
  final String momDelta;
  final int samCount;
  final int amCount;
  final int faCount;
  final int mdrtQualified;
  final bool showSam;
  final bool showAm;
  final double ownOverallPct;
  final String ownFyp;
  final String ownApe;
  final String ownMdrt;
  final String ownNewPolicies;
  final String ownActivePolicies;
  final String ownApeTarget;
  final String ownFypTarget;
  final String ownSfyp;
  final String ownSfypTarget;
  final String ownWtd;
  final String ownWtdTarget;
  final String ownApePct;
  final String ownFypPct;
  final String ownSfypPct;
  final String ownWtdPct;
  final String ownActualCompact;
  final String ownTargetCompact;
  final String ownMomDelta;
  final double ownMdrtPct;
  final bool ownMdrtQualified;
  final String periodLabel;

  String pulseSubtitle(TeamScope scope) {
    if (scope == TeamScope.total && hasIndirect) {
      return 'Total group · $groupCount FAs';
    }
    return 'Personal team · $personalCount FAs';
  }
}

/// Mock trees per preview role (docs/71 · 72). Display-only — no client math.
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

  static TeamLine? lineById(String id) {
    for (final snap in [_sam, _dm]) {
      for (final line in snap.groupLines) {
        if (line.id == id) return line;
      }
    }
    return null;
  }

  static List<TeamMember> membersForLine(String? lineId) {
    final all = List<TeamMember>.from(current.members)
      ..sort((a, b) => b.ringValue.compareTo(a.ringValue));
    if (lineId == null || lineId.isEmpty) return all;
    final filtered = all.where((m) => m.lineId == lineId).toList();
    return filtered.isEmpty ? all : filtered;
  }

  static List<TeamMember> mdrtLane(MdrtLane lane) {
    final all = current.members;
    switch (lane) {
      case MdrtLane.all:
        return all;
      case MdrtLane.qualified:
        return all.where((m) => m.qualified).toList();
      case MdrtLane.inProgress:
        return all
            .where((m) => m.badgeKind == TeamBadgeKind.inProgress)
            .toList();
      case MdrtLane.notYet:
        return all.where((m) => m.isNotYet).toList();
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
      lineId: 'am-1',
      ape: '4,820,000.00',
      apeTarget: '5,500,000.00',
      fyp: '6,150,000.00',
      fypTarget: '7,000,000.00',
      sfyp: '1,240,000.00',
      sfypTarget: '1,500,000.00',
      wtdFyp: '5,840,000.00',
      wtdTarget: '6,600,000.00',
      mdrtPct: 0.72,
      achievement: 0.87,
      actualCompact: '6.2M',
      targetCompact: '7.0M',
      qualified: false,
      mdrtOfTarget: '72%',
    ),
    TeamMember(
      id: 'fa-aye',
      name: 'Daw Aye Aye',
      code: 'YGN/FA/2021/0088',
      roleLabel: 'FA',
      lineId: 'am-1',
      ape: '7,210,000.00',
      apeTarget: '7,800,000.00',
      fyp: '9,400,000.00',
      fypTarget: '10,000,000.00',
      sfyp: '2,100,000.00',
      sfypTarget: '2,200,000.00',
      wtdFyp: '8,960,000.00',
      wtdTarget: '9,500,000.00',
      mdrtPct: 1.04,
      achievement: 0.92,
      actualCompact: '18.5M',
      targetCompact: '20.0M',
      qualified: true,
      mdrtOfTarget: '108%',
      momDelta: '+9.4%',
    ),
    TeamMember(
      id: 'fa-ko',
      name: 'Ko Min Thu',
      code: 'YGN/FA/2023/0210',
      roleLabel: 'FA',
      lineId: 'am-2',
      ape: '2,150,000.00',
      apeTarget: '4,000,000.00',
      fyp: '2,480,000.00',
      fypTarget: '4,800,000.00',
      sfyp: '420,000.00',
      sfypTarget: '800,000.00',
      wtdFyp: '2,310,000.00',
      wtdTarget: '4,500,000.00',
      mdrtPct: 0.31,
      achievement: 0.52,
      actualCompact: '2.5M',
      targetCompact: '4.8M',
      qualified: false,
      belowTarget: true,
      momDelta: '-4.1%',
      mdrtOfTarget: '31%',
    ),
    TeamMember(
      id: 'fa-su',
      name: 'Ma Su Mon',
      code: 'YGN/FA/2020/0033',
      roleLabel: 'FA',
      lineId: 'am-1',
      ape: '5,640,000.00',
      apeTarget: '6,200,000.00',
      fyp: '7,020,000.00',
      fypTarget: '8,000,000.00',
      sfyp: '1,680,000.00',
      sfypTarget: '1,900,000.00',
      wtdFyp: '6,710,000.00',
      wtdTarget: '7,600,000.00',
      mdrtPct: 0.88,
      achievement: 0.88,
      actualCompact: '7.0M',
      targetCompact: '8.0M',
      qualified: false,
      mdrtOfTarget: '88%',
    ),
  ];

  static const _tl = TeamSnapshot(
    personalCount: 4,
    groupCount: 4,
    hasIndirect: false,
    overallPct: 0.90,
    overallActual: '25.1M',
    overallTarget: '28.0M',
    momDelta: '+8.1%',
    faCount: 4,
    mdrtQualified: 1,
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
      lineId: 'am-2',
      ape: '8,900,000.00',
      apeTarget: '9,200,000.00',
      fyp: '11,200,000.00',
      fypTarget: '12,000,000.00',
      sfyp: '2,850,000.00',
      sfypTarget: '3,000,000.00',
      wtdFyp: '10,640,000.00',
      wtdTarget: '11,400,000.00',
      mdrtPct: 1.12,
      achievement: 0.93,
      actualCompact: '11.2M',
      targetCompact: '12.0M',
      qualified: true,
      momDelta: '+11.0%',
      mdrtOfTarget: '112%',
    ),
    TeamMember(
      id: 'fa-nwe',
      name: 'Ma Nwe Nwe',
      code: 'YGN/FA/2024/0441',
      roleLabel: 'FA',
      lineId: 'am-3',
      ape: '1,640,000.00',
      apeTarget: '3,800,000.00',
      fyp: '1,890,000.00',
      fypTarget: '4,200,000.00',
      sfyp: '210,000.00',
      sfypTarget: '700,000.00',
      wtdFyp: '1,720,000.00',
      wtdTarget: '4,000,000.00',
      mdrtPct: 0.18,
      achievement: 0.45,
      actualCompact: '1.9M',
      targetCompact: '4.2M',
      qualified: false,
      belowTarget: true,
      momDelta: '-8.4%',
      mdrtOfTarget: '18%',
    ),
  ];

  static const _am = TeamSnapshot(
    personalCount: 6,
    groupCount: 6,
    hasIndirect: false,
    overallPct: 0.91,
    overallActual: '38.1M',
    overallTarget: '42.0M',
    momDelta: '+6.4%',
    faCount: 6,
    mdrtQualified: 2,
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
    overallPct: 0.92,
    overallActual: '108.2M',
    overallTarget: '118.0M',
    momDelta: '+9.8%',
    amCount: 3,
    faCount: 18,
    mdrtQualified: 4,
    showAm: true,
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
        region: 'Yangon',
        faCount: 6,
        fypPct: '91%',
        actual: '38.4M',
        target: '42.0M',
        pctValue: 0.91,
      ),
      TeamLine(
        id: 'am-2',
        name: 'U Kyaw Zin',
        roleLabel: 'AM',
        region: 'Mandalay',
        faCount: 7,
        fypPct: '88%',
        actual: '36.1M',
        target: '41.0M',
        pctValue: 0.88,
      ),
      TeamLine(
        id: 'am-3',
        name: 'Daw Hnin Ei',
        roleLabel: 'AM',
        region: 'Nay Pyi Taw',
        faCount: 5,
        fypPct: '97%',
        actual: '33.7M',
        target: '35.0M',
        pctValue: 0.97,
      ),
    ],
  );

  static const _dm = TeamSnapshot(
    personalCount: 2,
    groupCount: 42,
    hasIndirect: true,
    overallPct: 0.78,
    overallActual: '125.4M',
    overallTarget: '160.0M',
    momDelta: '+12.5%',
    samCount: 3,
    amCount: 8,
    faCount: 24,
    mdrtQualified: 8,
    showSam: true,
    showAm: true,
    apeActual: '83,000,000.00',
    apeTarget: '106,000,000.00',
    apePct: '78%',
    fypActual: '125,400,000.00',
    fypTarget: '160,000,000.00',
    fypPct: '78%',
    sfypActual: '54,200,000.00',
    sfypTarget: '71,300,000.00',
    sfypPct: '76%',
    wtdActual: '32,600,000.00',
    wtdTarget: '51,700,000.00',
    wtdPct: '63%',
    members: _amMembers,
    groupLines: [
      TeamLine(
        id: 'sam-1',
        name: 'U Aung Myint',
        roleLabel: 'SAM',
        region: 'Yangon',
        faCount: 18,
        fypPct: '82%',
        actual: '38.4M',
        target: '46.0M',
        pctValue: 0.82,
      ),
      TeamLine(
        id: 'sam-2',
        name: 'Daw Thida',
        roleLabel: 'SAM',
        region: 'Mandalay',
        faCount: 24,
        fypPct: '87%',
        actual: '87.0M',
        target: '100.0M',
        pctValue: 0.87,
      ),
    ],
  );
}
