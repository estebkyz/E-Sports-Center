from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from api.models import Usuario, Trofeo
from api.serializers import UsuarioSerializer

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioSerializer

    @action(detail=True, methods=['post'], url_path='trofeos')
    def asignar_trofeo(self, request, pk=None):
        """RF-03: Asigna un trofeo al usuario."""
        usuario = self.get_object()
        trofeo_id = request.data.get('trofeo_id')
        try:
            trofeo = Trofeo.objects.get(id=trofeo_id)
            usuario.trofeos.add(trofeo)
            return Response({'detail': 'Trofeo asignado.'}, status=status.HTTP_200_OK)
        except Trofeo.DoesNotExist:
            return Response({'detail': 'Trofeo no encontrado.'}, status=status.HTTP_400_BAD_REQUEST)
