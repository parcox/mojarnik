class Jurusan {
    Jurusan({
        this.id,
        this.nama,
        this.ketuaJurusan,
    });

    int id;
    String nama;
    dynamic ketuaJurusan;

    factory Jurusan.fromJson(Map<String, dynamic> json) => Jurusan(
        id: json["id"],
        nama: json["nama"],
        ketuaJurusan: json["ketua_jurusan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "ketua_jurusan": ketuaJurusan,
    };
}