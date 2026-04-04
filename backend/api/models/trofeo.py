from django.db import models

class Trofeo(models.Model):
    id     = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=200)
    puntos = models.PositiveIntegerField()
    juego  = models.ForeignKey('Juego', on_delete=models.PROTECT, related_name='trofeos')
    def get_nombre(self):
        return self.nombre

    def set_nombre(self, nombre):
        self.nombre = nombre

    def get_puntos(self):
        return self.puntos

    def set_puntos(self, puntos):
        self.puntos = puntos

    class Meta:
        db_table = 'trofeo'

    def __str__(self):
        return f"{self.nombre} ({self.puntos} pts)"

class UsuarioTrofeo(models.Model):
    usuario      = models.ForeignKey('Usuario', on_delete=models.CASCADE)
    trofeo       = models.ForeignKey('Trofeo', on_delete=models.CASCADE)
    fecha_obtencion = models.DateField(auto_now_add=True)

    class Meta:
        db_table = 'usuario_trofeo'
        unique_together = ('usuario', 'trofeo')

class EquipoTrofeo(models.Model):
    equipo       = models.ForeignKey('Equipo', on_delete=models.CASCADE)
    trofeo       = models.ForeignKey('Trofeo', on_delete=models.CASCADE)
    fecha_obtencion = models.DateField(auto_now_add=True)

    class Meta:
        db_table = 'equipo_trofeo'
        unique_together = ('equipo', 'trofeo')
