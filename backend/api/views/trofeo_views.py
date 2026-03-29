from rest_framework import viewsets
from api.models import Trofeo
from api.serializers import TrofeoSerializer

class TrofeoViewSet(viewsets.ModelViewSet):
    queryset = Trofeo.objects.all()
    serializer_class = TrofeoSerializer
