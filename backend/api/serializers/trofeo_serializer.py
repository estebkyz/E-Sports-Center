from rest_framework import serializers
from api.models import Trofeo

class TrofeoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trofeo
        fields = '__all__'
