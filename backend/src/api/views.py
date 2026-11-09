"""
Docstring for api.views
Controller
"""
#We use Views to get web requests and send responses
from rest_framework import viewsets, views, filters, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django.utils import timezone
import time

from .serializer import *
from .models import *
from .permissions import *
from .signature import *

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
        elif user.role == 'student':
            return Excuse.objects.none()
        return Excuse.objects.none()
    
    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return ExcuseInputSerializer
        return ExcuseOutputSerializer
    
    def perform_create(self, serializer):
        user = User.objects.get(pk=self.request.user.pk)
        status_pending = Status.objects.get_or_create(name='Pending')[0]
        if hasattr(user, 'student'):
            excuse = serializer.save(uploaded_by_user=user, student=user.student, status=status_pending)
        elif user.role == 'student':
            student, _ = Student.objects.get_or_create(user=user, defaults={'klasse': user.klasse})
            excuse = serializer.save(uploaded_by_user=user, student=student, status=status_pending)
        elif hasattr(user, 'parent'):
            student = serializer.validated_data.get('student')
            if not student:
                from rest_framework.exceptions import ValidationError
                raise ValidationError(
                    {"student": "Provide Student ID."}
                )
            excuse = serializer.save(uploaded_by_user=user, status=status_pending)
        else:
            from rest_framework.exceptions import ValidationError
            raise ValidationError(
                    {"student": "Only students or parents can create excuses."}
            )
        if excuse.student and excuse.student.klasse:
            for teacher in excuse.student.klasse.teachers.all():
                ExcuseTeacher.objects.get_or_create(
                    excuse=excuse,
                    teacher=teacher,
                    defaults={'status': status_pending},
                )

    @action(detail=True, methods=['patch'], permission_classes=[permissions.IsAuthenticated, ExcusePermission])
    def sign(self, request, pk=None):
        excuse = self.get_object()
        now = int(time.time())

        strategy_name = request.data.get('strategy', 'django')
        strategy = changeStrategy(strategy_name, user=request.user)
        confirmation = {
            'excuse_id': excuse.id,
            'status': 'signed',
            'parent_id': request.user.id,
            'timestamp': now,
        }

        signed_json = strategy.signJson(confirmation)
        excuse.parent_signed = True
        excuse.approval_timestamp = now
        excuse.save()
        serializer = ExcuseOutputSerializer(excuse)
        return Response({
            **serializer.data,
            'signed_confirmation': signed_json
        })

    @action(detail=True, methods=['patch'], permission_classes=[permissions.IsAuthenticated, ExcusePermission])
    def reject(self, request, pk=None):
        excuse = self.get_object()
        excuse.status = Status.objects.get_or_create(name='rejected')[0]
        excuse.approved_by = request.user
        excuse.approval_timestamp = int(time.time())
        excuse.save()
        serializer = ExcuseOutputSerializer(excuse)
        return Response(serializer.data)

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

    @action(detail=True, methods=['post'])
    def confirm(self, request, pk=None):
        et = self.get_object()
        et.status = Status.objects.get_or_create(name='approved')[0]
        et.read_at = timezone.now()
        et.save()
        et.excuse.status = et.status
        et.excuse.approved_by = request.user
        et.excuse.approval_timestamp = int(time.time())
        et.excuse.save()
        serializer = ExcuseTeacherOutputSerializer(et)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        et = self.get_object()
        et.status = Status.objects.get_or_create(name='rejected')[0]
        et.read_at = timezone.now()
        et.save()
        et.excuse.status = et.status
        et.excuse.approved_by = request.user
        et.excuse.approval_timestamp = int(time.time())
        et.excuse.save()
        serializer = ExcuseTeacherOutputSerializer(et)
        return Response(serializer.data)

class StatisticsView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        if hasattr(user, 'student'):
            students = [user.student]
        elif hasattr(user, 'parent'):
            students = user.parent.students.all()
        elif hasattr(user, 'teacher'):
            students = Student.objects.filter(klasse__in=user.teacher.klassen.all())
        elif user.role == 'student':
            student, _ = Student.objects.get_or_create(user=user, defaults={'klasse': user.klasse})
            students = [student]
        elif user.role == 'teacher':
            Teacher.objects.create(user=user)
            students = Student.objects.filter(klasse__in=user.teacher.klassen.all())
        elif user.role == 'parent':
            Parent.objects.create(user=user)
            students = user.parent.students.all()
        else:
            return Response({'error': 'User has no role or profile.'}, status=403)

        result = []
        for s in students:
            total = CachedAbsence.objects.filter(student=s).count()
            excused = Excuse.objects.filter(student=s, status__name='approved').count()
            rejected = Excuse.objects.filter(student=s, status__name='rejected').count()
            pending = Excuse.objects.filter(student=s, status__name='Pending').count()
            result.append({
                'id': s.pk,
                'student': s.user.username,
                'klasse': s.klasse.name if s.klasse else None,
                'total': total,
                'excused': excused,
                'rejected': rejected,
                'pending': pending,
                'unexcused': max(0, total - excused),
            })
        return Response(result)

class WebUntisAbsencesView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        from .webuntis import get_absences

        serializer = WebUntisAbsencesInputSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        absences = get_absences(
            serializer.validated_data["username"],
            serializer.validated_data["password"],
        )

        if hasattr(request.user, 'student'):
            student = request.user.student
        elif request.user.role == 'student':
            student, _ = Student.objects.get_or_create(user=request.user, defaults={'klasse': request.user.klasse})
        else:
            student = None

        if student:
            for a in absences:
                CachedAbsence.objects.update_or_create(
                    student=student,
                    absence_id=str(a['id']),
                    defaults={'data': a},
                )

        return Response({"absences": absences})