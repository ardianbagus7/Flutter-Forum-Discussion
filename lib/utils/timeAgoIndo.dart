String timeAgoIndo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "Tahun" : "Tahun"} lalu";
  if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "Bulan" : "Bulan"} lalu";
  if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "Minggu" : "Minggu"} lalu";
  if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "Hari" : "Hari"} lalu";
  if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? "Jam" : "Jam"} lalu";
  if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? "Menit" : "Menit"} lalu";
  return "Baru sekarang";
}
