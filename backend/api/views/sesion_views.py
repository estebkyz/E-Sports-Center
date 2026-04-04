from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from api.models import Sesion
from api.serializers import SesionSerializer

class SesionViewSet(viewsets.ModelViewSet):
    queryset           = Sesion.objects.all()
    serializer_class   = SesionSerializer

    @action(detail=True, methods=['post'], url_path='iniciar')
    def iniciar(self, request, pk=None):
        # Llama al método del modelo para arrancar la sesión y responde con el nuevo estado
        sesion = self.get_object()
        if sesion.iniciar_sesion():
            return Response({'detail': 'Sesión iniciada.', 'estado': sesion.estado, 'hora_real_inicio': sesion.hora_real_inicio})
        return Response(
            {'detail': 'Solo se pueden iniciar sesiones agendadas.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    @action(detail=True, methods=['post'], url_path='cancelar')
    def cancelar(self, request, pk=None):
        # Cancela la sesión; el motivo viene en el cuerpo del request
        sesion = self.get_object()
        motivo = request.data.get('motivo', 'Cancelado vía API')
        if sesion.cancelar_sesion(motivo):
            return Response({'detail': 'Sesión cancelada correctamente.', 'estado': sesion.estado})
        return Response(
            {'detail': 'Solo se pueden cancelar sesiones agendadas o activas.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    @action(detail=True, methods=['post'], url_path='cerrar')
    def cerrar(self, request, pk=None):
        # Cierra la sesión activa y devuelve las horas entrenadas junto con el XP generado
        sesion = self.get_object()
        if sesion.cerrar_sesion():
            return Response({
                'detail': 'Sesión cerrada.',
                'horas_entrenadas': sesion.duracion_horas(),
                'xp_asignados': sesion.puntos_xp_asignados,
                'estado': sesion.estado
            })
        return Response(
            {'detail': 'Solo se pueden cerrar sesiones activas.'},
            status=status.HTTP_400_BAD_REQUEST
        )
