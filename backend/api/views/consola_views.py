from rest_framework import viewsets
from api.models import Consola
from api.serializers import ConsolaSerializer

class ConsolaViewSet(viewsets.ModelViewSet):
    queryset = Consola.objects.all()
    serializer_class = ConsolaSerializer
