class Mahasiswa {
    Mahasiswa({
        this.id,
        this.semester,
        this.nim,
        this.kelas,
        this.noAbsen,
        this.profilMahasiswaLengkap,
        this.user,
        this.prodi,
    });

    int id;
    String semester;
    String nim;
    String kelas;
    int noAbsen;
    bool profilMahasiswaLengkap;
    int user;
    int prodi;

    factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
        id: json["id"],
        semester: json["semester"],
        nim: json["nim"],
        kelas: json["kelas"],
        noAbsen: json["no_absen"],
        profilMahasiswaLengkap: json["profil_mahasiswa_lengkap"],
        user: json["user"],
        prodi: json["prodi"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "semester": semester,
        "nim": nim,
        "kelas": kelas,
        "no_absen": noAbsen,
        "profil_mahasiswa_lengkap": profilMahasiswaLengkap,
        "user": user,
        "prodi": prodi,
    };
}
