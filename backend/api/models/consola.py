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

    def registrar_entrada(self, cantidad=1):
        # Suma unidades cuando llegan nuevas consolas al centro
        self.cantidad_total += cantidad
        self.save()

    def registrar_salida(self, cantidad=1):
        # Resta unidades solo si hay suficiente stock; retorna False si no alcanza
        if self.cantidad_total >= cantidad:
            self.cantidad_total -= cantidad
            self.save()
            return True
        return False
    def get_numero_serie(self):
        return self.numero_serie

    def set_numero_serie(self, numero_serie):
        self.numero_serie = numero_serie

    def get_nombre(self):
        return self.nombre

    def set_nombre(self, nombre):
        self.nombre = nombre

    class Meta:
        db_table = 'consola'

    def __str__(self):
        return f"{self.nombre} [{self.numero_serie}]"
