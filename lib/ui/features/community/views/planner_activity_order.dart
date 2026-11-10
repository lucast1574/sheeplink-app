List<Map<String, dynamic>> orderPlannerActivities(
  List<Map<String, dynamic>> items,
) {
  const names = ['rompehielo', 'dinámica 1', 'dinámica 2'];
  final optional = <Map<String, dynamic>>[];
  for (final name in names) {
    optional.addAll(
      items.where(
        (item) => item['title'].toString().trim().toLowerCase() == name,
      ),
    );
  }
  final rest = items.where((item) => !optional.contains(item)).toList();
  final welcome = rest.indexWhere(
    (item) => item['title'].toString().trim().toLowerCase() == 'bienvenida',
  );
  rest.insertAll(welcome < 0 ? 0 : welcome + 1, optional);
  return rest;
}
