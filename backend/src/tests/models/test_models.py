from api import models

def make_user(username: str) -> models.User:
    """
    A little helper func
    """
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    user = models.User.objects.create(
        username=username,
        first_name="fj",
        last_name="ts",
        email="user@testmail.com",
        password="testpassword",
        # date_joined="2000-01-01",
        school=school
    )
    return user

def make_klasse(name: str) -> models.Klasse:
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    klasse = models.Klasse.objects.create(
        name=name,
        school=school
    )
    return klasse

def test_school():
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    
    assert school.name == "test"
    assert school.address == "teststreet"

    school.delete()
    assert models.School.objects.count() == 0

def test_user():
    school = models.School.objects.create(
        name="test",
        address="teststreet"
    )
    user = models.User.objects.create(
        username="user",
        first_name="fj",
        last_name="ts",
        email="user@testmail.com",
        # date_joined="2000-01-01",
        school=school
    )
    user.set_password("testpassword")
    user.save()
    assert user.username == "user"
    assert user.first_name == "fj"
    assert user.last_name == "ts"
    assert user.email == "user@testmail.com"
    assert user.check_password("testpassword")
    assert user.date_joined is not None # default should be "now()"
    
    # fk
    assert user.school == school

    user.delete()
    assert models.User.objects.count() == 0

def test_klasse():
    t_user1 = make_user("user1")
    t_user2 = make_user("user2")
    teacher1 = models.Teacher.objects.create(user=t_user1)
    teacher2 = models.Teacher.objects.create(user=t_user2)
    
    klasse = make_klasse("1AKIFT")
    klasse.teachers.add(teacher1, teacher2)

    assert klasse.name == "1AKIFT"

    # fk
    assert klasse.teachers.count() == 2
    assert set(klasse.teachers.all()) == {teacher1, teacher2}

    klasse.delete()
    assert models.Klasse.objects.count() == 0

def test_teacher():
    user = make_user("user")
    teacher = models.Teacher.objects.create(user=user)

    # fk
    assert teacher.user == user

    teacher.delete()
    assert models.Teacher.objects.count() == 0

def test_student():
    s_user = make_user("student")
    t_user = make_user("teacher")
    teacher = models.Teacher.objects.create(user=t_user)
    klasse = make_klasse(name="1AKIFT")
    klasse.teachers.add(teacher)
    student = models.Student.objects.create(user=s_user, klasse=klasse)
    
    assert student.user == s_user
    assert student.klasse == klasse

    # fk
    student.delete()
    assert models.Student.objects.count() == 0


def test_parent():
    klasse = make_klasse(name="1AKIFT")
    
    c_user1 = make_user("child1")
    c_user2 = make_user("child2")
    child1 = models.Student.objects.create(user=c_user1, klasse=klasse)
    child2 = models.Student.objects.create(user=c_user2, klasse=klasse)


    p_user = make_user("parent")
    parent = models.Parent.objects.create(user=p_user)
    parent.students.add(child1, child2)

    assert parent.students.count() == 2
    assert set(parent.students.all()) == {child1, child2}

    # fk
    assert parent.students.count() == 2
    assert set(parent.students.all()) == {child1, child2}

    parent.delete()
    assert models.Parent.objects.count() == 0

def test_status():
    status = models.Status.objects.create(name="teststatus")
    assert status.name == "teststatus"

    status.delete()
    assert models.Status.objects.count() == 0


def test_excuse():
    klasse = make_klasse("1AKIFT")
    s_user = make_user("student")
    student = models.Student.objects.create(user=s_user, klasse=klasse)

    user = make_user("user")
    t_user = make_user("teacher")
    teacher = models.Teacher.objects.create(user=t_user)
    status = models.Status.objects.create(name="teststatus")
    excuse = models.Excuse.objects.create(
        title="test",
        content="some content",
        # date_joined="2000-01-01",
        uploaded_by_user=user,
        student=student,
    )
    models.ExcuseTeacher.objects.create(
        excuse=excuse,
        teacher=teacher,
        status=status  # required
    )
    excuse.teachers.add(teacher)

    assert excuse.title == "test"
    assert excuse.content == "some content"
    assert excuse.created_at is not None
    assert excuse.uploaded_by_user == user
    assert excuse.teachers.count() == 1
    assert excuse.student==student
    assert teacher in excuse.teachers.all()

    excuse.delete()
    assert models.Excuse.objects.count() == 0


def test_excuseTeacher():
    user = make_user("user")
    t_user = make_user("teacher")
    teacher = models.Teacher.objects.create(user=t_user)
    status = models.Status.objects.create(name="teststatus")

    klasse = make_klasse("1AKIFT")
    s_user = make_user("student")
    student = models.Student.objects.create(user=s_user, klasse=klasse)

    excuse = models.Excuse.objects.create(
        title="test",
        content="some content",
        # date_joined="2000-01-01",
        uploaded_by_user=user,
        student=student,
    )
    excuse.teachers.add(teacher)

    excuseTeacher = models.ExcuseTeacher.objects.create(
        excuse=excuse,
        teacher=teacher,
        status=status
    )

    # excuseTeacher.read_at may be None, so no test
    assert excuseTeacher.excuse == excuse
    assert excuseTeacher.teacher == teacher
    assert excuseTeacher.status == status

    excuseTeacher.delete()
    assert models.ExcuseTeacher.objects.count() == 0