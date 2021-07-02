from rest_framework.routers import SimpleRouter
from accounts import views


router = SimpleRouter()

router.register(r'customuser', views.CustomUserViewSet)
router.register(r'profilmahasiswa', views.ProfilMahasiswaViewSet)
router.register(r'profildosen', views.ProfilDosenViewSet)

urlpatterns = router.urls
