extension ListDeepContains on List<String> {
  bool deepContains(String term) =>
      contains(term) || this.any((element) => element.contains(term));
}