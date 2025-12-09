from api import models

def test_example(test_user):
    assert test_user.username == "test_user"
    assert test_user.email is not None


# def test_testModel():
#     model = models.TestModel
#     model.

def test_school():
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    assert school.name == "test"
    assert school.address == "teststreet"

def test_user():
    school = models.School.objects.create(name="test")

    user = models.User.objects.create(
        username="user",
        first_name="fj",
        last_name="ts",
        email="user@testmail.com",
        password_hash="9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", # "test". 
        school=school
    )

    assert user.username == "user"
    assert user.first_name == "fj"
    assert user.last_name == "ts"
    assert user.email == "user@testmail.com"
    assert user.password_hash == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
    
    # test fk
    assert user.school == school
    assert user.school.name == "test"
    school.delete()
    assert school.objects.count() == 0


def test_klasse():
    pass

def test_teacher():
    pass

def test_student():
    pass

def test_parent():
    pass

def test_status():
    pass

def test_excuse():
    pass

def test_excuseTeacher():
    pass
