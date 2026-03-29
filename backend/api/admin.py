from django.contrib import admin
from .models import (
    Usuario, Equipo, Juego, Plataforma, Consola, Control,
    Trofeo, Sesion, UsuarioTrofeo, EquipoTrofeo
)

admin.site.register(Usuario)
admin.site.register(Equipo)
admin.site.register(Juego)
admin.site.register(Plataforma)
admin.site.register(Consola)
admin.site.register(Control)
admin.site.register(Trofeo)
admin.site.register(Sesion)
admin.site.register(UsuarioTrofeo)
admin.site.register(EquipoTrofeo)
