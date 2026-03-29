from django.db import models

class TipoControl(models.TextChoices):
    TECLADO     = 'teclado',     'Teclado'
    MOUSE       = 'mouse',       'Mouse'
    GAMEPAD     = 'gamepad',     'Gamepad'
    INSTRUMENTO = 'instrumento', 'Instrumento Musical'
    VOLANTE     = 'volante',     'Volante'
    OTRO        = 'otro',        'Otro'

class Control(models.Model):
    id           = models.AutoField(primary_key=True)
    numero_serie = models.CharField(max_length=100, unique=True)
    plataforma   = models.ForeignKey('Plataforma', on_delete=models.PROTECT, related_name='controles')
    tipo         = models.CharField(max_length=15, choices=TipoControl.choices)

    class Meta:
        db_table = 'control'

    def __str__(self):
        return f"{self.tipo} [{self.numero_serie}]"
