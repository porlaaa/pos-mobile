double numVal(dynamic v) =>
    v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0;

int intVal(dynamic v) =>
    v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

String greeting() =>
    DateTime.now().hour < 12
        ? 'Morning'
        : DateTime.now().hour < 17
        ? 'Afternoon'
        : 'Evening';
