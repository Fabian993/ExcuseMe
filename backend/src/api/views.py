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
from .permissions import * # Custom permission

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
#Schulbezogen


class KlasseViewSet(viewsets.ModelViewSet):
    queryset = Klasse.objects.all()
    #permission_classes = [SchoolUserPermission]
    permission_classes = [permissions.AllowAny] # nur für Testing
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['school']

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return KlasseInputSerializer
        return KlasseOutputSerializer


class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    #permission_classes = [SchoolUserPermission]
    permission_classes = [permissions.AllowAny] # nur für Testing
    filter_backends = [DjangoFilterBackend]
    filterset_fields = []

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return TeacherInputSerializer
        return TeacherOutputSerializer

#Student
class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    #permission_classes = [StudentPermission]
    permission_classes = [permissions.AllowAny] # nur für Testing

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'student'):
            return Student.objects.filter(id=user.student.id)
        return Student.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StudentInputSerializer
        return StudentOutputSerializer
#Eltern
class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()
    #permission_classes = [ParentPermission]
    permission_classes = [permissions.AllowAny] # nur für Testing

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'parent'):
            return Parent.objects.filter(id=user.parent.id)
        return Parent.objects.none()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ParentInputSerializer
        return ParentOutputSerializer

class StatusViewSet(viewsets.ModelViewSet):
    queryset = Status.objects.all()
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StatusInputSerializer
        return StatusOutputSerializer

#Excuses
class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    #permission_classes = [ExcusePermission]
    permission_classes = [permissions.AllowAny] # nur für Testing
    filter_backends = [DjangoFilterBackend]
    #filterset_fields = ['student__klasse', 'teacher', 'status', 'date']

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'student'):
            return Excuse.objects.filter(student=user.student)
        elif hasattr(user, 'teacher'):
            return Excuse.objects.filter(student__klasse = user.teacher.klasse)
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


class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserOutputSerializer
    #permission_classes = [permissions.IsAdminUser]
    permission_classes = [permissions.AllowAny] # nur für Testing

class ExcuseTeacherViewSet(viewsets.ModelViewSet):
    queryset = ExcuseTeacher.objects.all()
    serializer_class = ExcuseTeacherSerializer
    #permission_classes = [permissions.IsAdminUser]
    permission_classes = [permissions.AllowAny] # nur für Testing
