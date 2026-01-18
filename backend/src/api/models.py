"""
Docstring for api.models

Source for SQL-Django Syntax:
https://docs.djangoproject.com/en/6.0/ref/models/fields/
"""

from django.db import models  # noqa
from django.contrib.auth.models import User as DjangoAuthUser

class School(models.Model):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)

class Klasse(models.Model):
    name = models.CharField(max_length=255)
    school = models.ForeignKey(
        School, 
        on_delete=models.CASCADE
    )
    teachers = models.ManyToManyField(
        "Teacher",
        related_name="klassen",
    )
class User(DjangoAuthUser):
    # username,
    # password and
    # email are required in parent (auth.models.User)
    # date_joined (created_at) is also already logged in parent
    school = models.ForeignKey(
        School,
        related_name="users",
        on_delete=models.CASCADE,
    )
    role = models.CharField(
        max_length=20,
        choices=[('teacher', 'Teacher'), ('student', 'Student'), ('parent', 'Parent')],
        default='student'
    )
    klasse = models.ForeignKey(
        Klasse,
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True
    )

class Teacher(models.Model):
    user = models.OneToOneField(
        User,
        related_name="teachers",
        on_delete=models.CASCADE
    )

class Student(models.Model):
    user = models.OneToOneField(
        User,
        related_name="students",
        on_delete=models.CASCADE
    )
    klasse = models.ForeignKey(
        Klasse,
        related_name="students",
        on_delete=models.CASCADE
    )

class Parent(models.Model):
    user = models.OneToOneField(
        User,
        related_name="parents",
        on_delete=models.CASCADE,
     )
    children = models.ManyToManyField(
        Student,
        related_name="parents",
    )

class Status(models.Model):
    name = models.CharField(max_length=255, default="Pending")

class Excuse(models.Model):
    title = models.CharField(max_length=255)
    content = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    uploaded_by_user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )
    teachers = models.ManyToManyField(
        Teacher,
        related_name="excuses",
    )

class ExcuseTeacher(models.Model):
    read_at = models.DateTimeField(null=True, blank=True, default=None)
    excuse = models.ForeignKey(Excuse, on_delete=models.CASCADE)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    status = models.ForeignKey(Status, on_delete=models.CASCADE)