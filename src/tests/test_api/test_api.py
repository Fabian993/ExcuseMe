import pytest
from api import models

# def test_example(test_user):
#     assert test_user.username == "test_user"
#     assert test_user.email is not None

def test_school():
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    assert school.name == "test"
    assert school.address == "teststreet"

    school.delete()
    assert school.objects.count() == 0

def test_user():
    school = models.School.objects.create(name="test")

    user = models.User.objects.create(
        username="user",
        first_name="fj",
        last_name="ts",
        email="user@testmail.com",
        password_hash="9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", # "test"
        # created_at="2000-01-01",
        school=school
    )

    assert user.username == "user"
    assert user.first_name == "fj"
    assert user.last_name == "ts"
    assert user.email == "user@testmail.com"
    assert user.password_hash == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    assert user.created_at is not None
    
    # fk
    assert user.school == school

    user.delete()
    assert school.objects.count() == 0

def test_klasse():
    user1 = models.User.objects.create(username="user1")
    user2 = models.User.objects.create(username="user2")
    teacher1 = models.Teacher.objects.create(user=user1)
    teacher2 = models.Teacher.objects.create(user=user2)
    klasse = models.Klasse.objects.create(name="1AKIFT")
    klasse.teachers.add(teacher1, teacher2)

    assert klasse.name == "1AKIFT"

    # fk
    assert klasse.teachers.count() == 2
    assert list(klasse.teachers.all()) == [teacher1, teacher2]

    klasse.delete()
    assert klasse.objects.count() == 0

def test_teacher():
    user = models.User.objects.create(username="user")
    teacher = models.Teacher.objects.create(user=user)

    # fk
    assert teacher.user == user

    teacher.delete()
    assert teacher.objects.count() == 0

def test_student():
    user = models.User.objects.create(username="user")
    teacher = models.Teacher.objects.create(user=user)
    klasse = models.Klasse.objects.create(name="1AKIFT", teacher=teacher)
    student = models.Student.objects.create(user=user, klasse=klasse)
    
    assert student.user == user
    assert student.klasse == klasse

    # fk
    student.delete()
    assert student.objects.count() == 0


def test_parent():
    user = models.User.objects.create(username="user")
    user1 = models.User.objects.create(username="user1")
    user2 = models.User.objects.create(username="user2")
    child1 = models.Student.objects.create(user=user1)
    child2 = models.Student.objects.create(user=user2)
    parent = models.Parent.objects.create(user=user)
    parent.children.add(child1, child2)

    assert parent.user == user

    # fk
    assert parent.children.count() == 2
    assert list(parent.children.all()) == [child1, child2]

    parent.delete()
    assert parent.objects.count == 0

def test_status():
    default = models.Status.objects.create()
    status = models.Status.objects.create(name="teststatus")
    assert default.name == "Pending"
    assert status.name == "teststatus"

    status.delete()
    assert status.objects.count == 0


def test_excuse():
    user = models.User.objects.create(username="user")
    user1 = models.User.objects.create(username="user1")
    teacher1 = models.Teacher.objects.create(user=user1)
    excuse = models.Excuse.objects.create(
        title="test",
        content="some content",
        # created_at="2000-01-01",
        uploaded_by_user=user,
        teachers=teacher1
    )
    assert excuse.title == "test"
    assert excuse.content == "some content"
    assert excuse.created_at is not None
    assert excuse.uploaded_by_user == user
    assert excuse.teachers == teacher1

    excuse.delete()
    assert excuse.objects.count == 0


def test_excuseTeacher():
    user = models.User.objects.create(username="user")
    user1 = models.User.objects.create(username="user1")
    teacher1 = models.Teacher.objects.create(user=user)
    status = models.Status.objects.create(name="teststatus")
    excuse = models.Excuse.objects.create(
        title="test",
        content="some content",
        # created_at="2000-01-01",
        uploaded_by_user=user,
        teachers=teacher1
    )
    excuseTeacher = models.ExcuseTeacher.objects.create(
        excuse=excuse,
        teacher=teacher1,
    )

    # assert excuseTeacher.read_at ==
    assert excuseTeacher.excuse == excuse
    assert excuseTeacher.teacher == teacher1
    assert excuseTeacher.status == "teststatus"

    excuseTeacher.delete()
    assert excuseTeacher.objects.count() == 0