from django.db import models

class EstadoSesion(models.TextChoices):
    AGENDADA  = 'agendada',  'Agendada'
    ACTIVA    = 'activa',    'Activa'
    CERRADA   = 'cerrada',   'Cerrada'
    CANCELADA = 'cancelada', 'Cancelada'

class Sesion(models.Model):
    id                = models.AutoField(primary_key=True)
    fecha_agendamiento= models.DateField()
    hora_inicio       = models.TimeField()
    hora_fin          = models.TimeField()
    juego             = models.ForeignKey('Juego', on_delete=models.PROTECT)
    arbitro           = models.ForeignKey(
        'Usuario', on_delete=models.PROTECT, related_name='sesiones_arbitradas'
    )
    equipo            = models.ForeignKey(
        'Equipo', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='sesiones'
    )
    atleta            = models.ForeignKey(
        'Usuario', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='sesiones_como_atleta'
    )
    estado            = models.CharField(
        max_length=10, choices=EstadoSesion.choices, default='agendada'
    )
    puntos_xp_asignados = models.PositiveIntegerField(default=0)
    hora_real_inicio    = models.TimeField(null=True, blank=True)
    motivo_cancelacion  = models.CharField(max_length=255, null=True, blank=True)

    def iniciar_sesion(self):
        # Cambia el estado a activa y guarda la hora real en que arrancó
        from django.utils import timezone
        if self.estado == EstadoSesion.AGENDADA:
            self.estado = EstadoSesion.ACTIVA
            self.hora_real_inicio = timezone.localtime().time()
            self.save()
            return True
        return False

    def cancelar_sesion(self, motivo):
        # Solo se puede cancelar si está agendada o activa; guarda el motivo
        if self.estado in [EstadoSesion.AGENDADA, EstadoSesion.ACTIVA]:
            self.estado = EstadoSesion.CANCELADA
            self.motivo_cancelacion = motivo
            self.save()
            return True
        return False

    def cerrar_sesion(self):
        # Calcula los puntos XP según las horas y cierra la sesión
        if self.estado == EstadoSesion.ACTIVA:
            XP_POR_HORA = 10
            horas = self.duracion_horas()
            self.puntos_xp_asignados = int(horas * XP_POR_HORA)
            self.estado = EstadoSesion.CERRADA
            self.save()
            return True
        return False
    def get_estado(self):
        return self.estado

    def set_estado(self, estado):
        self.estado = estado

    def get_fecha_agendamiento(self):
        return self.fecha_agendamiento

    def set_fecha_agendamiento(self, fecha):
        self.fecha_agendamiento = fecha

    class Meta:
        db_table = 'sesion'
        constraints = [
            models.CheckConstraint(
                check=(
                    models.Q(equipo__isnull=False, atleta__isnull=True) |
                    models.Q(equipo__isnull=True, atleta__isnull=False)
                ),
                name='sesion_equipo_o_atleta'
            )
        ]

    def duracion_horas(self):
        from datetime import datetime, date
        inicio = datetime.combine(date.today(), self.hora_inicio)
        fin    = datetime.combine(date.today(), self.hora_fin)
        return (fin - inicio).seconds / 3600

    def __str__(self):
        return f"Sesión #{self.id} – {self.estado}"
