from django.db import models

class CalificacionESRB(models.TextChoices):
    E    = 'E',    'Everyone'
    E10  = 'E10+', 'Everyone 10+'
    T    = 'T',    'Teen'
    M    = 'M',    'Mature 17+'
    AO   = 'AO',   'Adults Only 18+'
    RP   = 'RP',   'Rating Pending'

class TipoJuego(models.TextChoices):
    FISICO  = 'fisico',  'Físico'
    DIGITAL = 'digital', 'Digital'

class Juego(models.Model):
    id                = models.AutoField(primary_key=True)
    nombre            = models.CharField(max_length=200)
    calificacion_esrb = models.CharField(max_length=5, choices=CalificacionESRB.choices)
    estudio           = models.CharField(max_length=200)
    plataformas       = models.ManyToManyField('Plataforma', related_name='juegos', db_table='juego_plataforma')
    num_jugadores     = models.PositiveSmallIntegerField()
    tipo              = models.CharField(max_length=10, choices=TipoJuego.choices)
    existencias       = models.PositiveIntegerField(default=0)
    def get_nombre(self):
        return self.nombre

    def set_nombre(self, nombre):
        self.nombre = nombre

    def get_existencias(self):
        return self.existencias

    def set_existencias(self, existencias):
        self.existencias = existencias

    class Meta:
        db_table = 'juego'
        ordering = ['id']

    def registrar_existencia(self, cantidad=1):
        # Suma la cantidad recibida al inventario del juego y guarda
        self.existencias += cantidad
        self.save()

    def __str__(self):
        return self.nombre
