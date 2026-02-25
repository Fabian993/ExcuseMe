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

    def __str__(self):
        return f"{self.name} ({self.pk})"

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
    
    def __str__(self):
        return f"{self.name} ({self.pk})"
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

    def __str__(self):
        return f"{self.name} ({self.pk})"


class Teacher(models.Model):
    user = models.OneToOneField(
        User,
        related_name="teacher",
        on_delete=models.CASCADE
    )

class Student(models.Model):
    user = models.OneToOneField(
        User,
        related_name="student",
        on_delete=models.CASCADE
    )
    klasse = models.ForeignKey(
        Klasse,
        related_name="students",
        on_delete=models.CASCADE

    )
    
    def __str__(self):
        return f"{self.name} ({self.pk})"

class Parent(models.Model):
    user = models.OneToOneField(
        User,
        related_name="parent",
        on_delete=models.CASCADE,
     )
    students = models.ManyToManyField(
        Student,
        related_name="parents",
    )
        
    def __str__(self):
        return f"{self.name} ({self.pk})"

class Status(models.Model):
    name = models.CharField(max_length=255, default="Pending")

    def __str__(self):
        return f"{self.name} ({self.pk})"

class Excuse(models.Model):
    title = models.CharField(max_length=255)
    content = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    uploaded_by_user = models.ForeignKey(
        User,
        related_name="uploaded_excuses",
        on_delete=models.CASCADE,
    )

    teachers = models.ManyToManyField(
        Teacher,
        through="ExcuseTeacher",
        related_name="assigned_excuses",
    )

    student = models.ForeignKey(
        Student,
        related_name="excuses",
        on_delete=models.CASCADE,
    )

    def __str__(self):
        return f"{self.name} ({self.pk})"
class ExcuseTeacher(models.Model):
    read_at = models.DateTimeField(null=True, blank=True, default=None)
    excuse = models.ForeignKey(Excuse, on_delete=models.CASCADE)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    status = models.ForeignKey(Status, on_delete=models.CASCADE)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["excuse", "teacher"],
                name="unique_excuse_teacher",
            )
        ]
        
    def __str__(self):
        return f"{self.name} ({self.pk})"