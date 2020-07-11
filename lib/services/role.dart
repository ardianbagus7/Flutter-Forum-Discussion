class Role {
  static int _developer = 6;
  static int _admin = 5;
  static int _dosen = 4;
  static int _alumni = 3;

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
  static int get alumni => _alumni;
  static int get dosen => _dosen;
  static List get roleName => _roleName;
}
