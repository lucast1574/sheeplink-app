import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/community.dart';
import '../../../../domain/models/new_cell_member.dart';
import '../../../../data/services/api_client.dart';
import '../../../../l10n/locale.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/feedback_panel.dart';
import '../view_models/community_view_model.dart';

class AddCellMemberPage extends StatefulWidget {
  const AddCellMemberPage({super.key, required this.model});
  final CommunityViewModel model;
  @override
  State<AddCellMemberPage> createState() => _AddCellMemberPageState();
}

class _AddCellMemberPageState extends State<AddCellMemberPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final age = TextEditingController();
  DateTime? birthday;
  bool saving = false, allowExit = false;
  String? error;
  bool get dirty =>
      name.text.isNotEmpty ||
      email.text.isNotEmpty ||
      age.text.isNotEmpty ||
      birthday != null;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    age.dispose();
    super.dispose();
  }

  Future<void> leave([Member? created]) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (created == null) {
      if (saving) return;
      if (dirty &&
          !await confirmDiscard(
            context,
            message: tr(
              'Si sales ahora, perderás los datos de este integrante.',
            ),
          )) {
        return;
      }
    }
    if (!mounted) return;
    setState(() => allowExit = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.pop(context, created);
  }

  Future<void> chooseBirthday() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: birthday ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: DateTime(now.year, now.month, now.day),
      cancelText: tr('Cancelar'),
    );
    if (selected != null && mounted) setState(() => birthday = selected);
  }

  Future<void> save() async {
    if (saving) return;
    if (!form.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      Scrollable.ensureVisible(form.currentContext!, alignment: 0);
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final created = await widget.model.addMember(
        NewCellMember(
          name: name.text.trim(),
          email: email.text.trim(),
          age: age.text.trim().isEmpty ? null : int.parse(age.text.trim()),
          birthday: birthday,
        ),
      );
      await leave(created);
    } catch (e) {
      if (mounted) setState(() => error = friendlyError(e));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: allowExit || (!dirty && !saving),
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) leave();
    },
    child: Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.textScalerOf(
          context,
        ).scale(56).clamp(56.0, 112.0).toDouble(),
        title: Text(tr('Añadir integrante'), maxLines: 2, softWrap: true),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: leave,
          icon: const RotatedBox(quarterTurns: 2, child: AppIcon(Symbol.arrow)),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null) ...[
                FeedbackPanel(error!, error: true),
                const SizedBox(height: 16),
              ],
              FilledButton(
                onPressed: saving ? null : save,
                child: Text(tr(saving ? 'Guardando…' : 'Guardar integrante')),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: saving ? null : leave,
                child: Text(tr('Cancelar')),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: form,
                  onChanged: () => setState(() {}),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.model.cell?.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(
                          'Registra sus datos para la asistencia. No se crea una cuenta ni se envía una invitación.',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _MemberField(
                        label: tr('Nombre completo'),
                        child: TextFormField(
                          key: const ValueKey('new-member-name'),
                          controller: name,
                          readOnly: saving,
                          maxLength: 150,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? tr('Escribe el nombre del integrante.')
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _MemberField(
                        label: tr('Correo electrónico (opcional)'),
                        child: TextFormField(
                          key: const ValueKey('new-member-email'),
                          controller: email,
                          readOnly: saving,
                          maxLength: 254,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          autocorrect: false,
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) =>
                              value == null ||
                                  value.trim().isEmpty ||
                                  RegExp(
                                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                  ).hasMatch(value.trim())
                              ? null
                              : tr(
                                  'Introduce un correo válido o deja el campo vacío.',
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _MemberField(
                        label: tr('Edad (opcional)'),
                        child: TextFormField(
                          key: const ValueKey('new-member-age'),
                          controller: age,
                          readOnly: saving,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecoration(counterText: ''),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final number = int.tryParse(value.trim());
                            return number != null &&
                                    number >= 0 &&
                                    number <= 120
                                ? null
                                : tr('La edad debe estar entre 0 y 120 años.');
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(tr('Cumpleaños (opcional)')),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: saving ? null : chooseBirthday,
                        icon: const AppIcon(Symbol.calendar, size: 20),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            birthday == null
                                ? tr('Elegir cumpleaños')
                                : DateFormat.yMMMd(appLocale).format(birthday!),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      if (birthday != null)
                        TextButton(
                          onPressed: saving
                              ? null
                              : () => setState(() => birthday = null),
                          child: Text(tr('Quitar cumpleaños')),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _MemberField extends StatelessWidget {
  const _MemberField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ExcludeSemantics(child: Text(label)),
      const SizedBox(height: 8),
      Semantics(label: label, child: child),
    ],
  );
}
