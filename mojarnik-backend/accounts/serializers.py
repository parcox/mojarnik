from rest_framework.serializers import ModelSerializer
from accounts.models import CustomUser, ProfilMahasiswa, ProfilDosen


class CustomUserSerializer(ModelSerializer):

    class Meta:
        model = CustomUser
        fields = '__all__'


class ProfilMahasiswaSerializer(ModelSerializer):

    class Meta:
        model = ProfilMahasiswa
        fields = '__all__'


class ProfilDosenSerializer(ModelSerializer):

    class Meta:
        model = ProfilDosen
        fields = '__all__'
