class MataKuliah {
    MataKuliah({
        this.id,
        this.nama,
        this.kode,
        this.semester,
        this.sksTeori,
        this.sksPraktik,
        this.jamTeori,
        this.jamPraktik,
        this.programStudi,
        this.pengajar,
    });

    int id;
    String nama;
    String kode;
    String semester;
    int sksTeori;
    int sksPraktik;
    int jamTeori;
    int jamPraktik;
    int programStudi;
    int pengajar;

    factory MataKuliah.fromJson(Map<String, dynamic> json) => MataKuliah(
        id: json["id"],
        nama: json["nama"],
        kode: json["kode"],
        semester: json["semester"],
        sksTeori: json["sks_teori"],
        sksPraktik: json["sks_praktik"],
        jamTeori: json["jam_teori"],
        jamPraktik: json["jam_praktik"],
        programStudi: json["program_studi"],
        pengajar: json["pengajar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "kode": kode,
        "semester": semester,
        "sks_teori": sksTeori,
        "sks_praktik": sksPraktik,
        "jam_teori": jamTeori,
        "jam_praktik": jamPraktik,
        "program_studi": programStudi,
        "pengajar": pengajar,
    };
}