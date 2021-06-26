from django.contrib import admin
from .models import EModul, EModulComment, EModulDetail, EModulBookmark, EModulAnnotation

@admin.register(EModul)
class EModulAdmin(admin.ModelAdmin):
    list_display = ['judul', 'mata_kuliah', 'penulis','tanggal']

@admin.register(EModulDetail)
class EModulDetailAdmin(admin.ModelAdmin):
    list_display = ['emodul', 'judul', 'jumlah_halaman', 'file']

@admin.register(EModulAnnotation)
class EModulAnnotationAdmin(admin.ModelAdmin):
    list_display = ['dokumen', 'user', 'halaman', 'text']

@admin.register(EModulBookmark)
class EModulBookmarkAdmin(admin.ModelAdmin):
    list_display = ['dokumen', 'user', 'halaman']

@admin.register(EModulComment)
class EModulCommentAdmin(admin.ModelAdmin):
    list_display = ['dokumen', 'user', 'comment']




