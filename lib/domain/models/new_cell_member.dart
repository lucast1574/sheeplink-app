/// A cell roster record. This request never creates or invites an app user.
class NewCellMember {
  const NewCellMember({
    required this.name,
    this.email = '',
    this.age,
    this.birthday,
  });
  final String name, email;
  final int? age;
  final DateTime? birthday;

  Map<String, dynamic> forCell(String cellId) => {
    'cellId': cellId,
    'name': name.trim(),
    if (email.trim().isNotEmpty) 'email': email.trim(),
    if (age != null) 'age': age,
    if (birthday != null)
      'birthday':
          '${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}',
  };
}
