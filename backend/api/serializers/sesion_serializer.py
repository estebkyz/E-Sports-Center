from rest_framework import serializers
from api.models import Sesion

class SesionSerializer(serializers.ModelSerializer):
    duracion_horas = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model  = Sesion
        fields = '__all__'

    def get_duracion_horas(self, obj):
        return obj.duracion_horas()

    def validate(self, data):
        # Una sesión no puede tener equipo y atleta al mismo tiempo
        equipo = data.get('equipo')
        atleta = data.get('atleta')
        if equipo and atleta:
            raise serializers.ValidationError(
                "Una sesión no puede tener equipo y atleta simultáneamente."
            )
        if not equipo and not atleta:
            raise serializers.ValidationError(
                "La sesión debe tener un equipo o un atleta asignado."
            )
        return data
