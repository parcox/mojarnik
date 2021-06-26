from rest_framework.routers import SimpleRouter
from emodul import views


router = SimpleRouter()

router.register(r'emodul', views.EModulViewSet)
router.register(r'emoduldetail', views.EModulDetailViewSet)
router.register(r'emodulannotation', views.EModulAnnotationViewSet)
router.register(r'emodulbookmark', views.EModulBookmarkViewSet)
router.register(r'emodulcomment', views.EModulCommentViewSet)

urlpatterns = router.urls
