from django.db import models

class Plataforma(models.Model):
    id     = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    marca  = models.CharField(max_length=100)

    class Meta:
        db_table = 'plataforma'

    def __str__(self):
        return f"{self.marca} {self.nombre}"
