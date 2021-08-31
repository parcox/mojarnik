from rest_framework.serializers import ModelSerializer
from emodul.models import EModul, EModulDetail, EModulAnnotation, EModulBookmark, EModulComment


class EModulSerializer(ModelSerializer):

    class Meta:
        model = EModul
        fields = '__all__'


class EModulDetailSerializer(ModelSerializer):

    class Meta:
        model = EModulDetail
        fields = '__all__'


class EModulAnnotationSerializer(ModelSerializer):

    class Meta:
        model = EModulAnnotation
        fields = '__all__'


class EModulBookmarkSerializer(ModelSerializer):

    class Meta:
        model = EModulBookmark
        fields = '__all__'


class EModulCommentSerializer(ModelSerializer):

    class Meta:
        model = EModulComment
        fields = '__all__'
