List<ProgressCount> generateList(int total) {
  return List<ProgressCount>.generate(total,
      (int currentIteration) => ProgressCount(currentIteration + 1, total));
}

void longRunningFunction(int i) {
  var val = generateList(i).reduce((pc1, pc2) => ProgressCount(
      pc1.currentIteration + pc2.currentIteration, pc1.total + pc2.total));
  print(val);
}

class ProgressCount {
  final int currentIteration;
  final int total;

  ProgressCount(this.currentIteration, this.total);

  @override
  String toString() {
    return "$currentIteration of $total";
  }

  bool get isLast => currentIteration == total;

  double get ratio => currentIteration / total;
}
