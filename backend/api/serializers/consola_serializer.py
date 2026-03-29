from rest_framework import serializers
from api.models import Consola

class ConsolaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Consola
        fields = '__all__'
