extension IndexOfElements<T> on List<T> {
  int indexOfElements(List<T> elements, [int start = 0]) {
    if (elements.isEmpty) return -1;
    var end = length - elements.length;
    if (start > end) return -1;
    var first = elements.first;
    var pos = start;
    while (true) {
      pos = indexOf(first, pos);
      if (pos < 0 || pos > end) return -1;
      for (var i = 1; i < elements.length; i++) {
        if (this[pos + i] != elements[i]) {
          pos++;
          continue;
        }
      }
      return pos;
    }
  }
}
