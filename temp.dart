void main() {
  final initial = [1, 3, 7, 12];
  final x = 4;

  final result = initial.map((current)=> current * x).toList();
  print(result);
}
