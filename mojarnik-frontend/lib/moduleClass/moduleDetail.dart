class ModuleDetail {
    ModuleDetail({
        this.id,
        this.judul,
        this.jumlahHalaman,
        this.file,
        this.emodul,
    });

    int id;
    String judul;
    int jumlahHalaman;
    String file;
    int emodul;

    factory ModuleDetail.fromJson(Map<String, dynamic> json) => ModuleDetail(
        id: json["id"],
        judul: json["judul"],
        jumlahHalaman: json["jumlah_halaman"],
        file: json["file"],
        emodul: json["emodul"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "jumlah_halaman": jumlahHalaman,
        "file": file,
        "emodul": emodul,
    };
}