#We use URLs to execute views
from django.urls import path  # noqa
from .views import *

urlpatterns = [
    #path("api/", views.api, name="api"),
    #path("frontend/", views.frontend), #test
    path('schools/', SchoolView, name = 'schools'),
]
#from rest_framework.routers import DefaultRouter
#router = DefaultRouter()
#urlpatterns = router.urls 
