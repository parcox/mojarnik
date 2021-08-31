class Bookmarks {
    Bookmarks({
        this.id,
        this.halaman,
        this.tanggal,
        this.dokumen,
        this.user,
    });

    int id;
    int halaman;
    DateTime tanggal;
    int dokumen;
    int user;

    factory Bookmarks.fromJson(Map<String, dynamic> json) => Bookmarks(
        id: json["id"],
        halaman: json["halaman"],
        tanggal: DateTime.parse(json["tanggal"]),
        dokumen: json["dokumen"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "halaman": halaman,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "dokumen": dokumen,
        "user": user,
    };
}