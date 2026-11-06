// lib/utils/ordenacao.dart
// Comparação de nomes em ordem alfabética:
//  - ignora maiúsculas/minúsculas e acentos ("Água" fica junto do "A")
//  - ordena números pelo valor ("Talhão 2" vem antes de "Talhão 10")

const _comAcento = 'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖòóôõöÙÚÛÜùúûüÇçÑñ';
const _semAcento = 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuCcNn';

String _normalizar(String s) {
  final b = StringBuffer();
  for (final r in s.trim().runes) {
    final c = String.fromCharCode(r);
    final i = _comAcento.indexOf(c);
    b.write(i >= 0 ? _semAcento[i] : c);
  }
  return b.toString().toLowerCase();
}

bool _ehNumero(String s) {
  final c = s.codeUnitAt(0);
  return c >= 48 && c <= 57;
}

int compararNomes(String a, String b) {
  final re = RegExp(r'\d+|\D+');
  final pa = re.allMatches(_normalizar(a)).map((m) => m.group(0)!).toList();
  final pb = re.allMatches(_normalizar(b)).map((m) => m.group(0)!).toList();
  final n = pa.length < pb.length ? pa.length : pb.length;
  for (var i = 0; i < n; i++) {
    final x = pa[i];
    final y = pb[i];
    int r;
    if (_ehNumero(x) && _ehNumero(y)) {
      final nx = BigInt.parse(x);
      final ny = BigInt.parse(y);
      r = nx.compareTo(ny);
    } else {
      r = x.compareTo(y);
    }
    if (r != 0) return r;
  }
  return pa.length.compareTo(pb.length);
}