from rest_framework.viewsets import ModelViewSet
from akademik.serializers import JurusanSerializer, ProgramStudiSerializer, MataKuliahSerializer
from akademik.models import Jurusan, ProgramStudi, MataKuliah


class JurusanViewSet(ModelViewSet):
    queryset = Jurusan.objects.order_by('pk')
    serializer_class = JurusanSerializer


class ProgramStudiViewSet(ModelViewSet):
    queryset = ProgramStudi.objects.order_by('pk')
    serializer_class = ProgramStudiSerializer


class MataKuliahViewSet(ModelViewSet):
    queryset = MataKuliah.objects.order_by('pk')
    serializer_class = MataKuliahSerializer
