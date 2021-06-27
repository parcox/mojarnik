from django.db import models
from django.utils.translation import ugettext as _
from django.contrib.auth import get_user_model
from django.conf import settings
from akademik.models import MataKuliah, Jurusan

User = get_user_model()


class EModul(models.Model):
    
    # nama = models.ForeignKey("akademik.Jurusan", verbose_name=_(
    #     'Nama_Jurusan'), on_delete=models.CASCADE,default=None, related_name='emodul')
    # prodi = models.ForeignKey("akademik.ProgramStudi", verbose_name=_(
    #     'Program Studi'), on_delete=models.CASCADE,default=None, related_name='emodul')
    mata_kuliah = models.ForeignKey("akademik.MataKuliah", verbose_name=_(
        'Mata kuliah'), on_delete=models.CASCADE, related_name='emodul')
    # semester = models.CharField(
    #     _("Semester"), choices=settings.SEMESTER, max_length=1)
    judul = models.CharField(_("Judul modul"), max_length=50)
    jumlah_modul = models.SmallIntegerField(
        _("Jumlah Modul"), null=True, blank=True)
    penulis = models.ForeignKey(User, verbose_name=_(
        "Uploader"), on_delete=models.CASCADE, null=True, blank=True, related_name='emodul')
    tanggal = models.DateField(verbose_name=_("Tanggal Upload"), auto_now=True)

    class Meta:
        verbose_name = 'eModul'
        verbose_name_plural = 'eModul'

    def __str__(self):
        return self.judul

class EModulDetail(models.Model):
    emodul = models.ForeignKey("EModul", verbose_name=_(
        "EModul"), on_delete=models.CASCADE, related_name='details')
    judul = models.CharField(_("Judul dokumen"), max_length=50)
    jumlah_halaman = models.SmallIntegerField(
        _("Jumlah halaman"), null=True, blank=True)
    # file = models.FileField(_("File"), upload_to=None, max_length=100)
    file = models.FileField(_("File"), null=True, blank=True, upload_to=None, max_length=100)

    class Meta:
        verbose_name = 'eModul detail'
        verbose_name_plural = 'eModul detail'

    def __str__(self):
        return self.judul

class EModulAnnotation(models.Model):
    dokumen = models.ForeignKey("EModulDetail", verbose_name=_(
        "EModul"), on_delete=models.CASCADE, related_name='annotations')
    user = models.ForeignKey(User, verbose_name=_(
        "Pengguna"), on_delete=models.CASCADE, related_name='annotations')
    halaman = models.PositiveSmallIntegerField(_("Halaman"))
    text = models.TextField(_("Text anotasi"))

    class Meta:
        verbose_name = 'eModul annotation'
        verbose_name_plural = 'eModul annotation'

    def __str__(self):
        return f'{self.emodul.judul} {self.user.username}'


class EModulBookmark(models.Model):
    # mata_kuliah = models.ForeignKey("akademik.MataKuliah", verbose_name=_(
    #     'Mata kuliah'), on_delete=models.CASCADE, related_name='bookmarks')
    dokumen = models.ForeignKey("EModulDetail", verbose_name=_(
        "EModul"), on_delete=models.CASCADE, related_name='bookmarks')
    user = models.ForeignKey(User, verbose_name=_(
        "Pengguna"), on_delete=models.CASCADE, related_name='bookmarks')
    halaman = models.PositiveSmallIntegerField(_("Halaman"))
    tanggal = models.DateField(verbose_name=_("Tanggal Bookmark"), auto_now=True)

    class Meta:
        verbose_name = 'eModul bookmark'
        verbose_name_plural = 'eModul bookmark'

    def __str__(self):
        return f'{self.dokumen.judul} {self.user.username}'


class EModulComment(models.Model):
    dokumen = models.ForeignKey("EModulDetail", verbose_name=_(
        "EModul"), on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(User, verbose_name=_(
        "Pengguna"), on_delete=models.CASCADE, related_name='comments')
    comment = models.TextField(_("Komentar"))

    class Meta:
        verbose_name = 'eModul comment'
        verbose_name_plural = 'eModul comment'

    def __str__(self):
        return f'{self.emodul.judul} {self.user.username}'
