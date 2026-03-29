from django.db import models

class TipoUsuario(models.TextChoices):
    ENTRENADOR    = 'entrenador',    'Entrenador'
    ATLETA        = 'atleta',        'Atleta'
    ADMINISTRATIVO= 'administrativo','Administrativo'
    PROVEEDOR     = 'proveedor',     'Proveedor'

class TipoDocumento(models.TextChoices):
    CC  = 'CC',  'Cédula de Ciudadanía'
    TI  = 'TI',  'Tarjeta de Identidad'
    CE  = 'CE',  'Cédula de Extranjería'
    PP  = 'PP',  'Pasaporte'

class Sexo(models.TextChoices):
    MASCULINO = 'M', 'Masculino'
    FEMENINO  = 'F', 'Femenino'
    OTRO      = 'O', 'Otro'

class Usuario(models.Model):
    id               = models.AutoField(primary_key=True)
    tipo_documento   = models.CharField(max_length=5, choices=TipoDocumento.choices)
    numero_documento = models.CharField(max_length=20, unique=True)
    nombre_completo  = models.CharField(max_length=200)
    edad             = models.PositiveSmallIntegerField()
    sexo             = models.CharField(max_length=1, choices=Sexo.choices)
    comuna           = models.CharField(max_length=100)
    barrio           = models.CharField(max_length=100)
    direccion        = models.CharField(max_length=255)
    telefono_movil   = models.CharField(max_length=20, blank=True, null=True)
    telefono_trabajo = models.CharField(max_length=20, blank=True, null=True)
    telefono_fijo    = models.CharField(max_length=20, blank=True, null=True)
    redes_sociales   = models.JSONField(default=dict, blank=True)
    tipo_usuario     = models.CharField(max_length=20, choices=TipoUsuario.choices)
    nickname         = models.CharField(max_length=50, unique=True)
    contrasena       = models.CharField(max_length=255)
    acudiente        = models.ForeignKey(
        'self', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='menores_a_cargo'
    )
    equipo           = models.ForeignKey(
        'Equipo', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='atletas'
    )
    trofeos          = models.ManyToManyField(
        'Trofeo', through='UsuarioTrofeo', blank=True
    )

    class Meta:
        db_table = 'usuario'
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'

    def __str__(self):
        return f"{self.nickname} ({self.nombre_completo})"
