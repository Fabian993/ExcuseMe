#We use URLs to execute views
from django.urls import path, include  # noqa
from rest_framework.routers import DefaultRouter
from . import views

#removed basename
router = DefaultRouter()
router.register(r"schools", views.SchoolViewSet) 
router.register(r"users", views.UserViewSet) 
router.register(r"klasses", views.KlasseViewSet) 
router.register(r"teachers", views.TeacherViewSet) 
router.register(r"students", views.StudentViewSet) 
router.register(r"parents", views.ParentViewSet) 
router.register(r"status", views.StatusViewSet) 
router.register(r"excuses", views.ExcuseViewSet) 
router.register(r"excuseteacher", views.ExcuseTeacherViewSet) 

urlpatterns = [
    path("api/", include(router.urls))
] 
