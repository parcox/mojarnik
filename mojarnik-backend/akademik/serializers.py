from rest_framework.serializers import ModelSerializer
from akademik.models import Jurusan, ProgramStudi, MataKuliah


class JurusanSerializer(ModelSerializer):

    class Meta:
        model = Jurusan
        fields = '__all__'


class ProgramStudiSerializer(ModelSerializer):

    class Meta:
        model = ProgramStudi
        fields = '__all__'


class MataKuliahSerializer(ModelSerializer):

    class Meta:
        model = MataKuliah
        fields = '__all__'
