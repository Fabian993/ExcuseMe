#We use URLs to execute views
from django.urls import path  # noqa
from . import views

urlpatterns = [
    path("api/", views.api, name="API"),
]

#from rest_framework.routers import DefaultRouter
#router = DefaultRouter()
#urlpatterns = router.urls 
