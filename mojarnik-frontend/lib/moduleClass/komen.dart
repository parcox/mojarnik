class Komentar {
    Komentar({
        this.id,
        this.comment,
        this.dokumen,
        this.user,
    });

    int id;
    String comment;
    int dokumen;
    int user;

    factory Komentar.fromJson(Map<String, dynamic> json) => Komentar(
        id: json["id"],
        comment: json["comment"],
        dokumen: json["dokumen"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "dokumen": dokumen,
        "user": user,
    };
}