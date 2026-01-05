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
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']
        read_only_fields = ['id']

class UserInputSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'first_name', 'last_name', 'school']
        extra_kwargs = {
            'password': {'write_only': True}
        }

class KlasseInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Klasse
        fields = ['name', 'school']

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
        read_only_fields = []

class StudentInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['user', 'klasse']
        extra_kwargs = {'user': {'write_only': True}}

class ParentInputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = ['user']
        extra_kwargs = {'user': {'write_only': True}}

class ParentOutputSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = ['id', 'user']
        read_only_fields = ['id']

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