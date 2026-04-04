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

    def calcular_nivel(self):
        # Suma los puntos de todos los trofeos de los atletas y actualiza el nivel en la BD
        puntos = self.total_puntos_trofeos
        if puntos >= 2000:
            self.nivel = NivelEquipo.ELITE
        elif puntos >= 1000:
            self.nivel = NivelEquipo.ORO
        elif puntos >= 500:
            self.nivel = NivelEquipo.PLATA
        else:
            self.nivel = NivelEquipo.BRONCE
        self.save()

    def asignar_atleta(self, usuario):
        # Asocia un atleta a este equipo y recalcula el nivel
        usuario.equipo = self
        usuario.save()
        self.calcular_nivel()
    def get_nombre(self):
        return self.nombre

    def set_nombre(self, nombre):
        self.nombre = nombre
        
    def get_nivel(self):
        return self.nivel

    def set_nivel(self, nivel):
        self.nivel = nivel

    class Meta:
        db_table = 'equipo'
        ordering = ['id']

    def __str__(self):
        return self.nombre
