from django.conf import settings
from django.contrib import admin
from django.urls import path, include
from accounts.views import custom_obtain_auth_token

urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('allauth.urls')),
    path('', include('pages.urls')),
    path('api/accounts/', include('accounts.urls')),  
    path('api/akademik/', include('akademik.urls')),    
    path('api/emodul/', include('emodul.urls')),  
    path('api/token-auth/', custom_obtain_auth_token),  
]

if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
] + urlpatterns
