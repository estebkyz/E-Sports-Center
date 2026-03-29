from rest_framework import viewsets
from api.models import Equipo
from api.serializers import EquipoSerializer

class EquipoViewSet(viewsets.ModelViewSet):
    queryset = Equipo.objects.all()
    serializer_class = EquipoSerializer
