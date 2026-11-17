import 'package:flutter/material.dart';
import '../../../../l10n/locale.dart';
import '../../../core/widgets/app_icon.dart';
import '../view_models/community_view_model.dart';
import 'add_cell_member_page.dart';
import 'cell_pane.dart';

class CellMembersView extends StatefulWidget {
  const CellMembersView({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<CellMembersView> createState() => _CellMembersViewState();
}

class _CellMembersViewState extends State<CellMembersView> {
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final query = search.text.trim().toLowerCase();
    final members = model.members
        .where((m) => m.name.toLowerCase().contains(query))
        .toList();
    return CellPane(
      storageKey: 'members',
      model: model,
      footer: model.canManageMembers
          ? FilledButton.icon(
              onPressed: model.busy || model.plannerBusy || model.pickingPhoto
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => AddCellMemberPage(model: model),
                        ),
                      );
                    },
              icon: const AppIcon(Symbol.people, color: Colors.white, size: 20),
              label: Text(tr('Añadir integrante')),
            )
          : null,
      children: [
        TextField(
          key: const ValueKey('member-search'),
          controller: search,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            labelText: tr('Buscar integrante'),
            suffixIcon: search.text.isEmpty
                ? null
                : IconButton(
                    tooltip: tr('Limpiar búsqueda'),
                    onPressed: () {
                      search.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    },
                    icon: const AppIcon(Symbol.close, size: 20),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Text(tr('Integrantes'), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          '${model.members.length}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (members.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              tr(
                query.isEmpty
                    ? 'Aún no hay integrantes activos en esta célula.'
                    : 'No encontramos integrantes con ese nombre.',
              ),
            ),
          ),
        for (final member in members)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const AppIcon(Symbol.user, size: 22),
            title: Text(member.name),
            subtitle: member.birthday == null
                ? null
                : Text(displayDate(member.birthday!)),
          ),
      ],
    );
  }
}
