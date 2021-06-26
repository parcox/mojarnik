# from django.contrib.auth.models import Permission
from rest_framework.viewsets import ModelViewSet
from accounts.serializers import CustomUserSerializer, ProfilMahasiswaSerializer, ProfilDosenSerializer
from accounts.models import CustomUser, ProfilMahasiswa, ProfilDosen
from rest_framework.authtoken.views import ObtainAuthToken 
from rest_framework.permissions import AllowAny
from rest_framework.authtoken.models import Token
from rest_framework.response import Response


# class CustomUserViewSet(ModelViewSet):
#     queryset = CustomUser.objects.order_by('pk')
#     serializer_class = CustomUserSerializer

class CustomUserViewSet(ModelViewSet):
    queryset = CustomUser.objects.order_by('pk')
    serializer_class = CustomUserSerializer
    http_method_names = ['get','patch']

    def get_queryset(self):
        role_id = self.request.query_params.get('role', None)
        if role_id is not None:
            try:
                self.queryset = self.queryset.filter(role=int(role_id))
            except Exception as e:
                print(e)
        return self.queryset


class ProfilMahasiswaViewSet(ModelViewSet):
    queryset = ProfilMahasiswa.objects.order_by('pk')
    serializer_class = ProfilMahasiswaSerializer
    http_method_names = ['get','patch']

    def get_queryset(self):
        user_id = self.request.query_params.get('user', None)
        if user_id is not None:
            try:
                self.queryset = self.queryset.filter(user=int(user_id))
            except Exception as e:
                print(e)
        return self.queryset


class ProfilDosenViewSet(ModelViewSet):
    queryset = ProfilDosen.objects.order_by('pk')
    serializer_class = ProfilDosenSerializer

class CustomObtainAuthToken(ObtainAuthToken):
    permission_classes = (AllowAny,)

    def post (self,request,*args,**kwargs):
        serializer = self.get_serializer(data = request.data)
        serializer.is_valid(raise_exception = True)
        user = serializer.validated_data["user"]
        token, created = Token.objects.get_or_create(user =user)

        return Response({"token":token.key,"user_id":user.id})

custom_obtain_auth_token = CustomObtainAuthToken.as_view()

