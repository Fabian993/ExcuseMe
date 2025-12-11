"""
Docstring for api.views
"""
#We use Views to get web requests and send responses
from rest_framework import viewsets
from .serializer import *
from .models import *

class SchoolViewSet(viewsets.ModelViewSet):
    queryset = School.objects.all()
    serializer_class = SchoolSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class KlasseViewSet(viewsets.ModelViewSet):
    queryset = Klasse.objects.all()
    serializer_class = KlasseSerializer

class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    serializer_class = TeacherSerializer

class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()
    serializer_class = ParentSerializer

class StatusViewSet(viewsets.ModelViewSet):
    queryset = Status.objects.all()
    serializer_class = StatusSerializer

class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    serializer_class = ExcuseSerializer

class ExcuseTeacherViewSet(viewsets.ModelViewSet):
    queryset = ExcuseTeacher.objects.all()
    serializer_class = ExcuseTeacherSerializer
