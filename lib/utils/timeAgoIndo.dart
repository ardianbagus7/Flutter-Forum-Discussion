String timeAgoIndo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "Tahun" : "Tahun"}";
  if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "Bulan" : "Bulan"}";
  if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "Minggu" : "Minggu"}";
  if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "Hari" : "Hari"}";
  if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? "Jam" : "Jam"}";
  if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? "Menit" : "Menit"}";
  return "Baru sekarang";
}
