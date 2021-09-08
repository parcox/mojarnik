class Modules {
  Modules({
    this.id,
    this.judul,
    this.jumlahModul,
    this.tanggal,
    this.mataKuliah,
  });

  int id;
  String judul;
  int jumlahModul;
  DateTime tanggal;
  int mataKuliah;

  factory Modules.fromJson(Map<String, dynamic> json) => Modules(
        id: json["id"] == null ? null : json["id"],
        judul: json["judul"] == null ? null : json["judul"],
        jumlahModul: json["jumlah_modul"] == null ? null : json["jumlah_modul"],
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        mataKuliah: json["mata_kuliah"] == null ? null : json["mata_kuliah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "judul": judul == null ? null : judul,
        "jumlah_modul": jumlahModul == null ? null : jumlahModul,
        "tanggal": tanggal == null
            ? null
            : "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "mata_kuliah": mataKuliah == null ? null : mataKuliah,
      };
}
