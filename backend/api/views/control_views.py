from rest_framework import viewsets
from api.models import Control
from api.serializers import ControlSerializer

class ControlViewSet(viewsets.ModelViewSet):
    queryset = Control.objects.all()
    serializer_class = ControlSerializer
