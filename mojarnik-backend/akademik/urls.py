from rest_framework.routers import SimpleRouter
from akademik import views


router = SimpleRouter()

router.register(r'jurusan', views.JurusanViewSet)
router.register(r'programstudi', views.ProgramStudiViewSet)
router.register(r'matakuliah', views.MataKuliahViewSet)

urlpatterns = router.urls
