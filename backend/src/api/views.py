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
        return SchoolNestedSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated(), SchoolUserPermission()]
#Schulbezogen

class KlasseViewSet(viewsets.ModelViewSet):
    queryset = Klasse.objects.all()
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['school']

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return KlasseInputSerializer
        return KlasseNestedSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated(), SchoolUserPermission()]

class TeacherViewSet(viewsets.ModelViewSet):
    queryset = Teacher.objects.all()
    filter_backends = [DjangoFilterBackend]

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Teacher.objects.none()
        elif user.is_superuser:
            return Teacher.objects.all()
        
        elif hasattr(user, 'teacher'):
            return Teacher.objects.filter(user__school=user.school)
        elif hasattr(user, 'student'):
            return Teacher.objects.filter(klassen=user.student.klasse).distinct()
        elif  hasattr(user, 'parent'):
            return Teacher.objects.filter(klassen__in=user.parent.students.values("klasse")).distinct()
        return Teacher.objects.none()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return TeacherInputSerializer
        return TeacherNestedSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated(), SchoolUserPermission()]
    
#Student
class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Student.objects.none()
        elif user.is_superuser:
            return Student.objects.all()
        
        elif hasattr(user, 'teacher'):
            return Student.objects.filter(klasse__in=user.teacher.klassen.all())
        elif hasattr(user, 'student'):
            return Student.objects.filter(pk=user.student.pk)
        elif hasattr(user, 'parent'):
            return user.parent.students.all()
        return Student.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StudentInputSerializer
        return StudentNestedSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated(), SchoolUserPermission()]
#Eltern
class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Parent.objects.none()
        elif user.is_superuser:
            return Parent.objects.all()
        
        elif hasattr(user, 'teacher'):
            return Parent.objects.filter(students__klasse__in=user.teacher.klassen.all()).distinct()
        elif hasattr(user, 'parent'):
            return Parent.objects.filter(pk=user.parent.pk)
        return Parent.objects.none()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ParentInputSerializer
        return ParentOutputSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated(), SchoolUserPermission()]

class StatusViewSet(viewsets.ModelViewSet):
    queryset = Status.objects.all()
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return StatusInputSerializer
        return StatusNestedSerializer
    
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated()]
#Excuses
class ExcuseViewSet(viewsets.ModelViewSet):
    queryset = Excuse.objects.all()
    #filter_backends = [DjangoFilterBackend]
    #filterset_fields = ['status']

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Excuse.objects.none()
        elif user.is_superuser:
            return Excuse.objects.all()

        elif hasattr(user, 'student'):
            return Excuse.objects.filter(student=user.student)
        elif hasattr(user, 'teacher'):
            return Excuse.objects.filter(student__klasse__in = user.teacher.klassen.all())
        elif hasattr(user, 'parent'):
            return Excuse.objects.filter(student__parents = user.parent)
        return Excuse.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ExcuseInputSerializer
        return ExcuseOutputSerializer
    
    def perform_create(self, serializer):
        serializer.save(uploaded_by_user=self.request.user)

    #Quasi Platzhalter für richtige signatur
    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def approve(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='genehmigt')
        excuse.save()

        serializer = ExcuseOutputSerializer(excuse)
        return Response(ExcuseOutputSerializer(excuse).data)

    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def reject(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get(name='abgelehnt')
        excuse.save()

        serializer = ExcuseOutputSerializer(excuse)
        return Response(ExcuseOutputSerializer(excuse).data)

    def get_permissions(self):
        return [permissions.IsAuthenticated(), ExcusePermission()]
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    
    def get_serializer_class(self):
        if self.action == 'create':
            return UserInputSerializer
        return UserNestedSerializer

    def get_permissions(self):
        return [permissions.IsAdminUser()]

class ExcuseTeacherViewSet(viewsets.ModelViewSet): #vlt entfernen und nur intern nutzen
    queryset = ExcuseTeacher.objects.all()

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ExcuseTeacherInputSerializer
        return ExcuseTeacherOutputSerializer

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return ExcuseTeacher.objects.none()
        elif user.is_superuser:
            return ExcuseTeacher.objects.all()
        
        elif hasattr(user, 'teacher'):
            return ExcuseTeacher.objects.filter(teacher=user.teacher)
        elif hasattr(user, 'student'):
            return ExcuseTeacher.objects.filter(excuse__student=user.student)
        elif hasattr(user, 'parent'):
            return ExcuseTeacher.objects.filter(excuse__student__parents=user.parent)
        return ExcuseTeacher.objects.none()
    
    def get_permissions(self):
        if self.action in ['destroy']:
            return [permissions.IsAdminUser()]
        return [permissions.IsAuthenticated()]