from rest_framework.routers import DefaultRouter
from api.views import (
    EquipoViewSet, JuegoViewSet, PlataformaViewSet
)

router = DefaultRouter()
router.register(r'equipos',     EquipoViewSet)
router.register(r'juegos',      JuegoViewSet)
router.register(r'plataformas', PlataformaViewSet)

urlpatterns = router.urls
