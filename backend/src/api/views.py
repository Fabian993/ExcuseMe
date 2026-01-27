"""
Docstring for api.views
"""
#We use Views to get web requests and send responses
from rest_framework import viewsets, filters, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .serializer import *
from .models import *
from .permissions import *

#Public
class SchoolViewSet(viewsets.ModelViewSet):
    queryset = School.objects.all()
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['name']
    search_fields = ['name']

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return SchoolInputSerializer
        return SchoolOutputSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [SchoolUserPermission()]
#Schulbezogen

class KlasseViewSet(viewsets.ModelViewSet):
    queryset = Klasse.objects.all()
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['school']

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return KlasseInputSerializer
        return KlasseOutputSerializer

    def get_permissions(self):
        if self.action == 'create':
            return [permissions.IsAdminUser()]
        return [SchoolUserPermission()]

class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    filter_backends = [DjangoFilterBackend]
    filterset_fields = []

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return TeacherInputSerializer
        return TeacherOutputSerializer
    
    def get_permissions(self):
        return [permissions.IsAdminUser()]

#Student
class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()

    def get_queryset(self):
        user = self.request.user
        if user.is_staff:
            return Student.objects.all()
        if hasattr(user, 'student'):
            return Student.objects.filter(user=user.student.user)
        return Student.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StudentInputSerializer
        return StudentOutputSerializer
    
    def get_permissions(self):
        return [permissions.IsAdminUser()]
#Eltern
class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'parent'):
            return Parent.objects.filter(id=user.parent.id)
        return Parent.objects.none()

    def get_serializer_class(self):
        if self.action in ['create', 'update']:
            return ParentInputSerializer
        return ParentOutputSerializer
    
    def get_permissions(self):
        if self.action in ['create']:
            return [permissions.IsAdminUser()]
        return [ParentPermission()]

class StatusViewSet(viewsets.ModelViewSet):
    queryset = Status.objects.all()
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StatusInputSerializer
        return StatusOutputSerializer
    
    def get_permissions(self):
        return [permissions.IsAdminUser()]

#Excuses
class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    #filter_backends = [DjangoFilterBackend]
    #filterset_fields = ['status']

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'student'):
            return Excuse.objects.filter(student=user.student)
        elif hasattr(user, 'teacher'):
            return Excuse.objects.filter(student__klasse = user.teacher.klassen.all())
        elif hasattr(user, 'parent'):
            return Excuse.objects.filter(student__parent = user.parent)
        return Excuse.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ExcuseInputSerializer
        return ExcuseOutputSerializer
    
    #Quasi Platzhalter für richtige signatur
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='genehmigt')
        excuse.save()

        serializer = ExcuseOutputSerializer(excuse)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='abgelehnt')
        excuse.save()

        serializer = ExcuseOutputSerializer(excuse)
        return Response(serializer.data)

    def get_permissions(self):
        return [ExcusePermission()]
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    
    def get_serializer_class(self):
        if self.action == 'create':
            return UserInputSerializer
        return UserOutputSerializer

    def get_permissions(self):
        return [permissions.IsAdminUser()]

class ExcuseTeacherViewSet(viewsets.ModelViewSet):
    queryset = ExcuseTeacher.objects.all()
    serializer_class = ExcuseTeacherSerializer

    def get_permissions(self):
        return [permissions.IsAdminUser()]
