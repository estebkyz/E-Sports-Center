from django.db import models

class Consola(models.Model):
    id               = models.AutoField(primary_key=True)
    numero_serie     = models.CharField(max_length=100, unique=True)
    nombre           = models.CharField(max_length=100)
    plataforma       = models.ForeignKey('Plataforma', on_delete=models.PROTECT)
    cantidad_total   = models.PositiveSmallIntegerField(default=1)
    direccion_ip     = models.GenericIPAddressField()
    mac_utp5         = models.CharField(max_length=17)   # formato AA:BB:CC:DD:EE:FF
    mac_inalambrica  = models.CharField(max_length=17)
    total_controles  = models.PositiveSmallIntegerField(default=0)

    class Meta:
        db_table = 'consola'

    def __str__(self):
        return f"{self.nombre} [{self.numero_serie}]"
