from rest_framework import viewsets
from api.models import Juego
from api.serializers import JuegoSerializer

class JuegoViewSet(viewsets.ModelViewSet):
    queryset = Juego.objects.all()
    serializer_class = JuegoSerializer
