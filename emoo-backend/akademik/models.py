from django.db import models
from django.utils.translation import ugettext as _
from django.contrib.auth import get_user_model
from django.conf import settings


User = get_user_model()


class Jurusan(models.Model):
    nama = models.CharField(_("Nama jurusan"), max_length=50)
    ketua_jurusan = models.OneToOneField(User, verbose_name=_(
        "Ketua jurusan"), on_delete=models.CASCADE, null=True, blank=True)

    class Meta:
        verbose_name = 'jurusan'
        verbose_name_plural = 'jurusan'

    def __str__(self):
        return self.user.nama


class ProgramStudi(models.Model):
    nama = models.CharField(_("Nama program studi"), max_length=50)
    kode = models.CharField(_("Kode"), max_length=50)
    jenjang = models.CharField(
        _("Jenjang"), choices=settings.JENJANG, max_length=10)
    jurusan = models.ForeignKey("Jurusan", verbose_name=_(
        "Jurusan"), on_delete=models.CASCADE, related_name='jurusan_prodi')
    ketua_prodi = models.OneToOneField(User, verbose_name=_(
        "Ketua program studi"), on_delete=models.CASCADE, null=True, blank=True)
    psdku = models.BooleanField(_("Prodi di luar kampus utama"))

    class Meta:
        verbose_name = 'program studi'
        verbose_name_plural = 'program studi'

    def __str__(self):
        return self.nama


class MataKuliah(models.Model):
    nama = models.CharField(_("Nama mata kuliah"), max_length=50)
    kode = models.CharField(_("Kode"), max_length=50, null=True, blank=True)
    semester = models.CharField(
        _("Semester"), choices=settings.SEMESTER, max_length=1)
    program_studi = models.ForeignKey("ProgramStudi", verbose_name=_("Program studi"), on_delete=models.CASCADE, null=True)
    # TODO: tambah pembatas nilai minimum dan maksimum untuk field sks dan jam
    sks_teori = models.PositiveSmallIntegerField(
        _("Jumlah SKS teori"), null=True, blank=True)
    sks_praktik = models.PositiveSmallIntegerField(
        _("Jumlah SKS praktik"), null=True, blank=True)
    jam_teori = models.PositiveSmallIntegerField(
        _("Jumlah jam teori"), null=True, blank=True)
    jam_praktik = models.PositiveSmallIntegerField(
        _("Jumlah jam praktik"), null=True, blank=True)

    class Meta:
        verbose_name = 'mata kuliah'
        verbose_name_plural = 'mata kuliah'

    def __str__(self):
        return self.nama
