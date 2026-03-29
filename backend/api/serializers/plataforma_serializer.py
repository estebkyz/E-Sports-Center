from rest_framework import serializers
from api.models import Plataforma

class PlataformaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Plataforma
        fields = '__all__'
