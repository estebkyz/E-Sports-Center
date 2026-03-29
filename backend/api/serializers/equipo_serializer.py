from rest_framework import serializers
from api.models import Equipo

class EquipoSerializer(serializers.ModelSerializer):
    nivel_calculado = serializers.SerializerMethodField()

    class Meta:
        model = Equipo
        fields = '__all__'

    def get_nivel_calculado(self, obj):
        # RF-04: Nivel calculado según puntos de trofeos
        puntos = obj.total_puntos_trofeos
        if puntos >= 1000: return 'elite'
        elif puntos >= 500: return 'oro'
        elif puntos >= 200: return 'plata'
        else: return 'bronce'
