import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/locale.dart';
import '../../../../domain/models/weekly_meeting.dart';
import '../../../core/widgets/picker_header.dart';

enum MeetingDateAction { prepare }

class MeetingDateSheet extends StatefulWidget {
  const MeetingDateSheet({
    super.key,
    required this.date,
    required this.meetingDay,
    required this.canPrepare,
    this.recorded = false,
  });
  final DateTime date;
  final String meetingDay;
  final bool canPrepare, recorded;
  @override
  State<MeetingDateSheet> createState() => _MeetingDateSheetState();
}

class _MeetingDateSheetState extends State<MeetingDateSheet> {
  late DateTime selected = widget.date;
  void moveWeek(int offset) => setState(() {
    selected = meetingDateForWeek(
      startOfWeek(selected).add(Duration(days: offset * 7)),
      widget.meetingDay,
      DateTime.now(),
      allowFuture: true,
    );
  });
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PickerHeader(title: tr('Fecha del encuentro')),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(DateFormat.yMMMMEEEEd(appLocale).format(selected)),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => moveWeek(-1),
                        child: Text(tr('Anterior')),
                      ),
                      TextButton(
                        onPressed: () => moveWeek(1),
                        child: Text(tr('Siguiente')),
                      ),
                    ],
                  ),
                  CalendarDatePicker(
                    key: ValueKey(
                      '${selected.year}/${selected.month}/${selected.day}',
                    ),
                    initialDate: selected,
                    firstDate: DateTime(widget.date.year - 10),
                    lastDate: DateTime(widget.date.year + 10, 12, 31),
                    onDateChanged: (date) => setState(() => selected = date),
                  ),
                  if (widget.recorded) ...[
                    const SizedBox(height: 16),
                    Text(
                      tr(
                        'Esta semana tiene una reunión registrada. Para una nueva reunión, elige otra semana.',
                      ),
                    ),
                  ],
                  if (widget.canPrepare) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, MeetingDateAction.prepare),
                      child: Text(tr('Preparar próxima célula')),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(tr('Aplicar selección')),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(tr('Cancelar')),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
