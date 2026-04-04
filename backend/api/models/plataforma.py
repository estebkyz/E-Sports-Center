from django.db import models

class Plataforma(models.Model):
    id     = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    marca  = models.CharField(max_length=100)
    def get_nombre(self):
        return self.nombre

    def set_nombre(self, nombre):
        self.nombre = nombre

    def get_marca(self):
        return self.marca

    def set_marca(self, marca):
        self.marca = marca

    class Meta:
        db_table = 'plataforma'
        ordering = ['id']

    def __str__(self):
        return f"{self.marca} {self.nombre}"
