enum OrderOption {
  dateModified,
  dateCreated;

  String get name {
    return switch (this) {
      OrderOption.dateModified => 'Ngày sửa',
      OrderOption.dateCreated => 'Ngày tạo',
    };
  }
}