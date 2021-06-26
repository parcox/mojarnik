from django.contrib.auth.models import AbstractUser
from django.db import models
from phonenumber_field.modelfields import PhoneNumberField
from django.utils.translation import ugettext as _
from django.db.models.signals import post_save
from rest_framework.authtoken.models import Token
from django.dispatch import receiver
# from akademik.models import ProgramStudi
from django.conf import settings


class CustomUser(AbstractUser):
    MAHASISWA = 1
    DOSEN = 2
    PRIA = 1
    WANITA = 2
    ROLE_CHOICES = (
        (MAHASISWA, 'Mahasiswa'),
        (DOSEN, 'Dosen'),
    )
    GENDER =(
        (PRIA, 'Pria'),
        (WANITA, 'Wanita'),
    )
    DEFAULT_FOTO_PROFIL = 'images/foto_profil/default.jpg'
    # untuk autocreate account mahasiswa dari front end app
    role = models.PositiveSmallIntegerField(
        'Role', choices=ROLE_CHOICES, default=MAHASISWA)
    gender = models.PositiveSmallIntegerField(
        'Gender', choices=GENDER, default=PRIA)
    no_hp = PhoneNumberField(
        'Nomor HP/WA', help_text='Gunakan format internasional (+628XXXXXX)', default='+62123456789')
    foto = models.ImageField(
        'Foto', upload_to="images/foto_profil/", default=DEFAULT_FOTO_PROFIL, null=True, blank=True)
    profil_user_lengkap = models.BooleanField(
        'Profil user lengkap', default=False)

    def __str__(self):
        return self.username

    def is_mahasiswa(self):
        return self.role == self.MAHASISWA

    def is_dosen(self):
        return self.role == self.DOSEN


class ProfilMahasiswa(models.Model):
    user = models.OneToOneField(
        CustomUser, on_delete=models.CASCADE, null=True, related_name='profil_mahasiswa')
    prodi = models.ForeignKey('akademik.ProgramStudi', verbose_name=_(
        "Program studi"), on_delete=models.CASCADE, null=True, blank=True)
    semester = models.CharField(
        'Semester', choices=settings.SEMESTER, max_length=5, null=True, blank=True)
    kelas = models.CharField(
        'Kelas', max_length=5, null=True, blank=True)
    no_absen = models.PositiveSmallIntegerField(
        'No. Absen', null=True, blank=True)
    profil_mahasiswa_lengkap = models.BooleanField(
        'Profil mahasiswa lengkap', default=False)

    class Meta:
        verbose_name = 'profil mahasiswa'
        verbose_name_plural = 'profil mahasiswa'

    def __str__(self):
        return self.user.username


class ProfilDosen(models.Model):
    user = models.OneToOneField(
        CustomUser, on_delete=models.CASCADE, null=True, related_name='profil_dosen')
    nidn = models.CharField(_("NIDN"), max_length=12)

    class Meta:
        verbose_name = 'profil dosen'
        verbose_name_plural = 'profil dosen'

    def __str__(self):
        return self.user.username


@receiver(post_save, sender=CustomUser)
def create_or_update_user_profile(sender, instance, created, **kwargs):
    if instance.role == CustomUser.MAHASISWA:
        ProfilMahasiswa.objects.get_or_create(user=instance)
        instance.profil_mahasiswa.save()
    elif instance.role == CustomUser.DOSEN:
        ProfilDosen.objects.get_or_create(user=instance)
        instance.profil_dosen.save()

    if created:
        Token.objects.create(user=instance)
