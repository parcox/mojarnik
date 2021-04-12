from django.contrib import admin
from .models import Jurusan, ProgramStudi, MataKuliah


admin.site.site_header = "Modul Ajar Elektronik (Mojarnik) Admin"
admin.site.site_title = "Modul Ajar Elektronik (Mojarnik) Admin Portal"
admin.site.index_title = "Selamat datang di Mojarnik Backend"

@admin.register(ProgramStudi)
class ProgramStudiAdmin(admin.ModelAdmin):
    list_display = ['nama', 'kode', 'jenjang', 'jurusan']

class ProgramStudiInline(admin.TabularInline):
    model = ProgramStudi
    extra = 0

@admin.register(Jurusan)
class JurusanAdmin(admin.ModelAdmin):
    list_display = ['nama','ketua_jurusan']
    inlines = [ProgramStudiInline]

@admin.register(MataKuliah)
class MataKuliahAdmin(admin.ModelAdmin):
    list_display = ['nama', 'kode', 'semester', 'program_studi']

