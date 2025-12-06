#We use URLs to execute views
from django.urls import path  # noqa
from . import views

urlpatterns = [
    path("api/", views.api_get, name="api_get"),
]

#from rest_framework.routers import DefaultRouter
#router = DefaultRouter()
#urlpatterns = router.urls 
