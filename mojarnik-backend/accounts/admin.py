from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin

from .forms import CustomUserCreationForm, CustomUserChangeForm
from .models import CustomUser, ProfilMahasiswa

class InlineProfilMahasiswa(admin.StackedInline):
    model = ProfilMahasiswa
    can_delete = False
    max_num = 1
    min_num = 1
    readonly_fields = ['profil_mahasiswa_lengkap', ]

    def get_formset(self, request, obj=None, **kwargs):
        # Tampilkan help_text pada calculated field
        help_texts = {
            'profil_mahasiswa_lengkap': 'True jika prodi, semester, kelas, dan no. absen sudah diisi.'}
        kwargs.update({'help_texts': help_texts})

        return super(InlineProfilMahasiswa, self).get_formset(request, obj, **kwargs)

# class CustomUserAdmin(UserAdmin):
#     add_form = CustomUserCreationForm
#     form = CustomUserChangeForm
#     model = CustomUser
#     list_display = ['email', 'username',]

class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    add_fieldsets = (  # Tambah user baru
        (None, {
            # 'fields': ('username', 'email', 'role', 'password1', 'password2')}
            'fields': ('username', 'first_name','last_name', 'foto', 'role', 'gender', 'no_hp', 'password1', 'password2')}
         ),
    )
    form = CustomUserChangeForm
    model = CustomUser
    list_display = ['username', 'no_hp', 'role', 'profil_user_lengkap', ]
    readonly_fields = []
    # inlines = [InlineProfilDosen, InlineProfilMahasiswa]
    inlines = []
    fieldsets = (
        *UserAdmin.fieldsets,
        ('Profil Pengguna',
         {
             "fields": (
                 'role', 'no_hp','profil_user_lengkap',
             ),
         }),
    )

    def get_readonly_fields(self, request, obj=None):  # disable role edit
        if obj:
            return ['role', 'profil_user_lengkap', ]

        return self.readonly_fields

    # inline pada saat mengedit customuser, akan sesuai dengan role
    def get_form(self, request, obj=None, change=False, **kwargs):
        if obj:  # pas edit object
            self.inlines = []
            if obj.is_mahasiswa():
                self.inlines = [InlineProfilMahasiswa, ]
           

        # Tampilkan help_text pada calculated field
        help_texts = {
            'profil_user_lengkap': 'True jika nama depan, nama belakang, no. HP, dan foto sudah diisi.'}
        kwargs.update({'help_texts': help_texts})

        return super(CustomUserAdmin, self).get_form(request, obj, **kwargs)

admin.site.register(CustomUser, CustomUserAdmin)