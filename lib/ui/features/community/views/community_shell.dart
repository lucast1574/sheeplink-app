import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../data/services/notification_service.dart';
import '../view_models/community_view_model.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../../profile/views/profile_view.dart';
import 'attendance_view.dart';
import 'today_view.dart';

class CommunityShell extends StatefulWidget {
  const CommunityShell({
    super.key,
    required this.model,
    required this.notifications,
  });
  final CommunityViewModel model;
  final NotificationService notifications;
  @override
  State<CommunityShell> createState() => _CommunityShellState();
}

class _CommunityShellState extends State<CommunityShell>
    with WidgetsBindingObserver {
  int tab = 0;
  String? _roster;
  bool _offering = false;
  final _scroll = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.model.addListener(sync);
    widget.notifications.destination.addListener(openNotice);
    sync();
  }

  void sync() {
    final model = widget.model;
    if (model.session == null || model.busy) return;
    final signature =
        '${DateTime.now().day}:${model.personal.assignments.map((a) => '${a.id}/${a.confirmation}/${a.blocked}/${a.date}/${a.time}').join(',')}:${model.session!.id}:${model.cell?.id}:${model.members.map((m) => '${m.id}/${m.birthday}').join(',')}';
    if (signature == _roster) return;
    _roster = signature;
    widget.notifications.synchronize(
      model.members,
      model.cell?.timezone ?? 'America/Lima',
      assignments: model.personal.assignments,
    );
    if (!_offering) {
      _offering = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => offerNotifications());
    }
  }

  Future<void> offerNotifications() async {
    try {
      if (!await widget.notifications.shouldOffer() || !mounted) return;
      await widget.notifications.markPromptSeen();
      if (!mounted) return;
      final activate = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mantente cerca de tu comunidad'),
          content: const Text(
            'Te avisamos de los cumpleaños y de tus turnos de servicio: el día anterior y el mismo día. Puedes elegir los avisos en tu perfil.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ahora no'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Activar'),
            ),
          ],
        ),
      );
      if (activate == true && mounted) {
        await widget.notifications.enable(
          widget.model.members,
          widget.model.cell?.timezone ?? 'America/Lima',
          assignments: widget.model.personal.assignments,
        );
      }
    } finally {
      _offering = false;
    }
  }

  void openNotice() {
    if (mounted) {
      setState(() => tab = 0);
      widget.notifications.destination.value = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !widget.model.dirty &&
        !widget.model.pickingPhoto &&
        !widget.model.busy) {
      widget.model.refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.model.removeListener(sync);
    widget.notifications.destination.removeListener(openNotice);
    _scroll.dispose();
    super.dispose();
  }

  void select(int index) {
    setState(() => tab = index);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return PopScope(
      canPop: !model.dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await confirmDiscard(context).then((discard) {
            if (discard && context.mounted) SystemNavigator.pop();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/brand/mark.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF164F3B),
                  BlendMode.srcIn,
                ),
                width: 28,
                height: 28,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: 10),
              const Text(
                'SheepLink',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              if (model.dirty && !await confirmDiscard(context)) return;
              await model.refresh();
              _roster = null;
              sync();
            },
            child: ListView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (model.busy)
                          const LinearProgressIndicator(minHeight: 2),
                        if (model.error != null) ...[
                          FeedbackPanel(
                            model.error!,
                            error: true,
                            action: TextButton(
                              onPressed: model.busy
                                  ? null
                                  : () => model.refresh(),
                              child: const Text('Reintentar'),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (model.notice != null) ...[
                          FeedbackPanel(model.notice!),
                          const SizedBox(height: 16),
                        ],
                        switch (tab) {
                          0 => TodayView(
                            model: model,
                            onAttendance: () => select(1),
                          ),
                          1 => AttendanceView(model: model),
                          _ => ProfileView(
                            model: model,
                            notifications: widget.notifications,
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: select,
          destinations: const [
            NavigationDestination(icon: AppIcon(Symbol.home), label: 'Hoy'),
            NavigationDestination(
              icon: AppIcon(Symbol.people),
              label: 'Mi célula',
            ),
            NavigationDestination(icon: AppIcon(Symbol.user), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
