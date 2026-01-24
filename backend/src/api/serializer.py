"""
Docstring for api.serializer
class Meta - eine art Konfigurationsbox
"""
from rest_framework import serializers
from .models import *

class SchoolInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = ['name', 'address']
class SchoolOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = ['id', 'name', 'address']
        read_only_fields = ['id']

class UserOutputSerializer(serializers.ModelSerializer):
    role = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['username', 'email', 'first_name', 'last_name', 'school', 'role']
        read_only_fields = ['id']

    def get_role(self, obj):
        if hasattr(obj, 'student'): return 'student'
        if hasattr(obj, 'teacher'): return 'teacher'
        if hasattr(obj, 'parent'): return 'parent'
        return obj.role

class UserInputSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length = 8)
    class Meta:
        model = User
        fields = ['username', 'email', 'first_name', 'last_name', 'school', 'password', 'role', 'klasse']

    def create(self, validated_data):
        password = validated_data.pop('password') #reihenfolge wichtig, pop muss zuerst sein
        role = validated_data.pop('role')

        validated_data['role'] = role
        user = User.objects.create_user(password=password, **validated_data)
        if role == 'teacher':
            Teacher.objects.create(user=user)
        elif role == 'student':
            klasse = validated_data.pop('klasse', None)
            Student.objects.create(user=user, klasse=klasse)
        elif role == 'parent':
            Parent.objects.create(user=user)
        return user

class KlasseInputSerializer(serializers.ModelSerializer):
    teachers = serializers.PrimaryKeyRelatedField(queryset=Teacher.objects.all(), many=True)
    class Meta:
        model = Klasse
        fields = '__all__'

class KlasseOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Klasse
        fields = ['id', 'name', 'school']
        read_only_fields = ['id']

class TeacherOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Teacher
        fields = ['id', 'user']
        read_only_fields = ['id']

class TeacherInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Teacher
        fields = ['user']
        extra_kwargs = {'user': {'write_only': True}}

class StudentOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['id', 'user', 'klasse']
        read_only_fields = ['id']

class StudentInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['user', 'klasse']
        extra_kwargs = {'user': {'write_only': True}}

class ParentInputSerializer(serializers.ModelSerializer):
    children = serializers.PrimaryKeyRelatedField(queryset=Student.objects.all(), many=True)
    class Meta:
        model = Parent
        fields = '__all__'
        extra_kwargs = {'user': {'write_only': True}}

class ParentOutputSerializer(serializers.ModelSerializer):
    children_count = serializers.SerializerMethodField()
    class Meta:
        model = Parent
        fields = ['id', 'user', 'children_count']
        read_only_fields = ['id']
    
    def get_children_count(self, obj):
        return obj.children.count()

class StatusInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = ['name']

class StatusOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = ['id', 'name']
        read_only_fields = ['id']

class ExcuseOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Excuse
        fields = ['id', 'title', 'content', 'created_at', 'uploaded_by_user']
        read_only_fields = ['id', 'created_at']
class ExcuseInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Excuse
        fields = ['title', 'content', 'uploaded_by_user']  # Keine status/teacher Manipulation
        extra_kwargs = {'uploaded_by_user': {'write_only': True}}
class ExcuseTeacherSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExcuseTeacher  # Fix: korrektes Model
        fields = ['id', 'excuse', 'teacher', 'status', 'read_at']
        read_only_fields = ['id']