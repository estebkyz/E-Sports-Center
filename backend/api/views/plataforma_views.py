from rest_framework import viewsets
from api.models import Plataforma
from api.serializers import PlataformaSerializer

class PlataformaViewSet(viewsets.ModelViewSet):
    queryset = Plataforma.objects.all()
    serializer_class = PlataformaSerializer
