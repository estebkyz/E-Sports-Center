from rest_framework.routers import DefaultRouter
from api.views import (
    UsuarioViewSet, EquipoViewSet, JuegoViewSet,
    PlataformaViewSet, ConsolaViewSet, ControlViewSet,
    TrofeoViewSet, SesionViewSet,
)

router = DefaultRouter()
router.register(r'usuarios',    UsuarioViewSet)
router.register(r'equipos',     EquipoViewSet)
router.register(r'juegos',      JuegoViewSet)
router.register(r'plataformas', PlataformaViewSet)
router.register(r'consolas',    ConsolaViewSet)
router.register(r'controles',   ControlViewSet)
router.register(r'trofeos',     TrofeoViewSet)
router.register(r'sesiones',    SesionViewSet)

urlpatterns = router.urls
