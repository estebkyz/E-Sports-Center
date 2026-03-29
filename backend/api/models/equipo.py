from django.db import models

class NivelEquipo(models.TextChoices):
    BRONCE = 'bronce', 'Bronce'
    PLATA  = 'plata',  'Plata'
    ORO    = 'oro',    'Oro'
    ELITE  = 'elite',  'Elite'

class Equipo(models.Model):
    id           = models.AutoField(primary_key=True)
    nombre       = models.CharField(max_length=100, unique=True)
    juego        = models.ForeignKey('Juego', on_delete=models.PROTECT, related_name='equipos')
    horas_juego  = models.PositiveIntegerField(default=0)
    nivel        = models.CharField(max_length=10, choices=NivelEquipo.choices, default='bronce')
    trofeos      = models.ManyToManyField('Trofeo', through='EquipoTrofeo', blank=True)

    @property
    def total_puntos_trofeos(self):
        return sum(
            ut.trofeo.puntos
            for miembro in self.atletas.all()
            for ut in miembro.usuariotrofeo_set.all()
        )

    class Meta:
        db_table = 'equipo'

    def __str__(self):
        return self.nombre
