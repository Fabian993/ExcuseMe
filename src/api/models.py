"""
Docstring for api.models

Source for SQL-Django Syntax:
https://docs.djangoproject.com/en/6.0/ref/models/fields/
"""

from django.db import models  # noqa


class TestModel(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    file = models.FileField(upload_to="api/files/")

    def __str__(self):
        return self.name

class School(models.Model):
    name = models.CharField(max_length=255)
    adress = models.CharField(max_length=255)

class User(models.Model):
    school_id = models.ForeignKey(School, on_delete=models.CASCADE)
    username = models.CharField(max_length=255)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.CharField(max_length=255)
    password_hash = models.BinaryField(max_length=32) #SHA-256
    created_at = models.DateField

class Class(models.Model):
    teacher_id = models.ForeignKey("Teacher", on_delete=models.CASCADE)
    name = models.CharField(max_length=255)

class Teacher(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    class_id = models.ForeignKey(Class, on_delete=models.CASCADE)

class Student(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    class_id = models.ForeignKey(Class, on_delete=models.CASCADE)

class Parent(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    children = models.ManyToManyField(Student)

