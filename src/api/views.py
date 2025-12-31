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
    serializer_class = SchoolSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['name']
    search_fields = ['name']
#Schulbezogen


class KlasseViewSet(viewsets.ModelViewSet):
    queryset = Klasse.objects.all()
    serializer_class = KlasseSerializer
    permission_classes = [SchoolUserPermission]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['school']

class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    serializer_class = TeacherSerializer
    permission_classes = [SchoolUserPermission]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['school']

#Student
class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer
    permission_classes = [StudentPermission]

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'student'):
            return Student.objects.filter(id=user.student.id)
        return Student.objects.none()
    
#Eltern
class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()
    serializer_class = ParentSerializer
    permission_classes = [ParentPermission]

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'parent'):
            return Parent.objects.filter(id=user.parent.id)
        return Parent.objects.none()

class StatusViewSet(viewsets.ModelViewSet):
    queryset = Status.objects.all()
    serializer_class = StatusSerializer

#Excuses
class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    serializer_class = ExcuseSerializer
    permission_classes = [ExcusePermission]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['student__klasse', 'teacher', 'status', 'date']

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'student'):
            return Excuse.objects.filter(student=user.student)
        elif hasattr(user, 'teacher'):
            return Excuse.objects.filter(student__klasse = user.teacher.klasse)
        elif hasattr(user, 'parent'):
            return Excuse.objects.filter(student__parent = user.parent)
        return Excuse.objects.none()
    
    #Quasi Platzhalter für richtige signatur
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='genehmigt')
        excuse.save()
        return Response({'message': 'Entschuldigung genehmigt'})

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='abgelehnt')
        excuse.save()
        return Response({'message': 'Entschuldigung abgelehnt'})


class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAdminUser]

class ExcuseTeacherViewSet(viewsets.ModelViewSet):
    queryset = ExcuseTeacher.objects.all()
    serializer_class = ExcuseTeacherSerializer
    permission_classes = [permissions.IsAdminUser]
