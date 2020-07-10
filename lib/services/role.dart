class Role {
  static int _developer = 6;
  static int _admin = 5;

  static List _roleName = [
    'Guest',
    'Mahasiswa Aktif',
    'Fungsionaris',
    'Alumni',
    'Dosen',
    'Admin',
    'Developer'
  ];

  static int get developer => _developer;
  static int get admin => _admin;
  static List get roleName => _roleName;
}
