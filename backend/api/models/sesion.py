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
