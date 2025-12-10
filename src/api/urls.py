#We use URLs to execute views
from django.urls import path, include  # noqa
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r"schools", SchoolViewSet, basename = "school")
router.register(r"users", UserViewSet, basename = "user")
router.register(r"klasses", KlasseViewSet, basename = "klasse")
router.register(r"teachers", TeacherViewSet, basename = "teacher")
router.register(r"students", StudentViewSet, basename = "student")
router.register(r"parents", ParentViewSet, basename = "parent")
router.register(r"status", StatusViewSet, basename = "status")
router.register(r"excuses", ExcuseViewSet, basename = "excuse")
router.register(r"excuseteacher", ExcuseTeacherViewSet, basename = "excuseteacher")

urlpatterns = [
    path("api/", include(router.urls))
] 
