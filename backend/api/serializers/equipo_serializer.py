from rest_framework import serializers
from api.models import Equipo

class EquipoSerializer(serializers.ModelSerializer):
    nivel_calculado = serializers.SerializerMethodField()
    juego_nombre    = serializers.StringRelatedField(source='juego')

    class Meta:
        model = Equipo
        fields = '__all__'
        read_only_fields = ['nivel_calculado', 'juego_nombre']

    def get_nivel_calculado(self, obj):
        # Calcula el nivel según los puntos acumulados de trofeos de los jugadores del equipo
        puntos = obj.total_puntos_trofeos
        if puntos >= 1000: return 'elite'
        elif puntos >= 500: return 'oro'
        elif puntos >= 200: return 'plata'
        else: return 'bronce'
