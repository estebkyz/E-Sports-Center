from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from api.models import Sesion, EstadoSesion
from api.serializers import SesionSerializer

XP_POR_HORA = 10  # Puntos de experiencia por hora entrenada

class SesionViewSet(viewsets.ModelViewSet):
    queryset           = Sesion.objects.all()
    serializer_class   = SesionSerializer

    @action(detail=True, methods=['post'], url_path='cancelar')
    def cancelar(self, request, pk=None):
        """RF-12 – Cancela una sesión agendada."""
        sesion = self.get_object()
        if sesion.estado not in [EstadoSesion.AGENDADA, EstadoSesion.ACTIVA]:
            return Response(
                {'detail': 'Solo se pueden cancelar sesiones agendadas o activas.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        sesion.estado = EstadoSesion.CANCELADA
        sesion.save()
        return Response({'detail': 'Sesión cancelada correctamente.', 'estado': sesion.estado})

    @action(detail=True, methods=['post'], url_path='cerrar')
    def cerrar(self, request, pk=None):
        """RF-13 – Cierra la sesión y asigna XP (RF-11)."""
        sesion = self.get_object()
        if sesion.estado != EstadoSesion.ACTIVA:
            # Note: allowing to close from agendada for basic testing in RF-13 if desired
            # But the SDD specifies "Solo se pueden cerrar sesiones activas." Let's stick to rule.
            return Response(
                {'detail': 'Solo se pueden cerrar sesiones activas.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        horas = sesion.duracion_horas()
        xp    = int(horas * XP_POR_HORA)
        sesion.puntos_xp_asignados = xp
        sesion.estado = EstadoSesion.CERRADA
        sesion.save()
        return Response({
            'detail': 'Sesión cerrada.',
            'horas_entrenadas': horas,
            'xp_asignados': xp,
            'estado': sesion.estado
        })
