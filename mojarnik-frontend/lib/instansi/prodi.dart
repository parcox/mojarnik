class Prodi {
    Prodi({
        this.id,
        this.nama,
        this.kode,
        this.jenjang,
        this.psdku,
        this.jurusan,
        this.ketuaProdi,
    });

    int id;
    String nama;
    String kode;
    String jenjang;
    bool psdku;
    int jurusan;
    dynamic ketuaProdi;

    factory Prodi.fromJson(Map<String, dynamic> json) => Prodi(
        id: json["id"],
        nama: json["nama"],
        kode: json["kode"],
        jenjang: json["jenjang"],
        psdku: json["psdku"],
        jurusan: json["jurusan"],
        ketuaProdi: json["ketua_prodi"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "kode": kode,
        "jenjang": jenjang,
        "psdku": psdku,
        "jurusan": jurusan,
        "ketua_prodi": ketuaProdi,
    };
}