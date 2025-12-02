from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

user_session_table = db.Table(
    "user_session_association",
    db.Model.metadata,
    db.Column("session_id", db.Integer, db.ForeignKey("sessions.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id"))
)

class User(db.Model):
    """
    User model
    """
    __tablename__ = "users"
    id=db.Column(db.Integer, primary_key=True, autoincrement=True)
    google_id=db.Column(db.String, unique=True, nullable=False)
    name=db.Column(db.String, nullable=False)
    email=db.Column(db.String, unique=True, nullable=False)
    profile_picture=db.Column(db.String)
    major=db.Column(db.String)
    interests=db.Column(db.String)
    sessions=db.relationship("Session", secondary=user_session_table, back_populates="students")
    friendships=db.relationship("Friend", foreign_keys="[Friend.user_id]", back_populates="user", cascade='delete')

    def __init__(self,**kwargs):
        """
        Initialize User object/entry
        """
        self.google_id = kwargs.get("google_id","")
        self.name = kwargs.get("name","")
        self.email = kwargs.get("email","")
        self.profile_picture =  kwargs.get("profile_picture","")
        self.major = kwargs.get("major","")
        self.interests=kwargs.get("interests","")


    def serialize(self):
        """
        Serialize a user object
        """
        return{
            "id": self.id,
            "google_id": self.google_id,
            "name": self.name,
            "email": self.email,
            "profile_picture": self.profile_picture,
            "major": self.major,
            "interests": self.interests,
            "sessions": [s.simple_serialize() for s in self.sessions],
            "friendships": [s.simple_serialize() for s in self.friendships]
        }
    
    def simple_serialize(self):
        """
        Serialize a simple user object
        """
        return{
            "id": self.id,
            "name": self.name,
            "email": self.email
        }
    
class Course(db.Model):
    """
    Course model
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String, unique=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    sessions = db.relationship("Session", back_populates="course", cascade='delete')

    def __init__(self, **kwargs):
        """
        """
        self.code=kwargs.get("code","")
        self.name=kwargs.get("name","")

    def serialize(self):
        """
        """
        return{
            "id": self.id,
            "code":self.code,
            "name": self.name,
            "sessions": [s.simple_serialize() for s in self.sessions]
        }
    def simple_serialize(self):
        """
        """
        return{
            "id": self.id,
            "code": self.code,
            "name": self.name
        }
    
class Session(db.Model):
    """
    Session model
    """
    __tablename__ = "sessions"
    id = db.Column(db.Integer,primary_key=True, autoincrement=True)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    class_number = db.Column(db.String, unique=True, nullable=False)
    name = db.Column(db.String, nullable=False)
    time = db.Column(db.String)
    course = db.relationship("Course", back_populates="sessions")
    students=db.relationship("User",secondary=user_session_table, back_populates="sessions")

    def __init__(self,**kwargs):
        """
        """
        self.course_id = kwargs.get("course_id")
        self.class_number = kwargs.get("class_number")
        self.name = kwargs.get("name")

    def serialize(self):
        """
        """
        return {
            "id": self.id,
            "class_number": self.class_number,
            "name": self.name,
            "time": self.time,
            "course": self.course.simple_serialize(),
            "students": [s.simple_serialize() for s in self.students]
        }
    
    def simple_serialize(self):
        """
        """
        return {
            "id": self.id,
            "class_number": self.class_number,
            "name": self.name,
            "time": self.time
        }

class Friend(db.Model):
    """
    Friend model
    """
    __tablename__="friends"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    friend_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    status = db.Column(db.String, default = 'Pending', nullable=False)
    user = db.relationship("User",foreign_keys=[user_id], back_populates="friendships")
    friend = db.relationship("User", foreign_keys=[friend_id])

    def __init__(self, **kwargs):
        """
        """
        self.user_id = kwargs.get("user_id")
        self.friend_id = kwargs.get("friend_id")
        self.status = kwargs.get("status")

    def serialize(self):
        """
        """
        return {
            "id": self.id,
            "user_id": self.user_id,
            "friend_id": self.friend_id,
            "status": self.status,
            "friend": self.friend.simple_serialize()
        }
    
    def simple_serialize(self):
        """
        """
        return{
            "friend_id": self.friend_id,
            "status": self.status
        }
    
class Message(db.Model):
    """
    Message Model
    """
    __tablename__="messages"
    id=db.Column(db.Integer, primary_key=True, autoincrement=True)
    sender_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    receiver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    content = db.Column(db.String, nullable=False)
    sent_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    read = db.Column(db.Boolean, default=False)
    sender = db.relationship("User", foreign_keys=[sender_id])
    receiver = db.relationship("User", foreign_keys=[receiver_id])

    def __init__(self, **kwargs):
        """
        """
        self.sender_id = kwargs.get("sender_id")
        self.receiver_id = kwargs.get("receiver_id")
        self.content = kwargs.get("content", "")
        self.sent_at = kwargs.get("sent_at")
        self.read = kwargs.get("read", False)

    def serialize(self):
        """
        """
        return {
            "id": self.id,
            "sender_id": self.sender_id,
            "receiver_id": self.receiver_id,
            "content": self.content,
            "sent_at": self.sent_at.isoformat(),
            "read": self.read,
            "sender": self.sender.simple_serialize(),
            "receiver": self.receiver.simple_serialize()
        }
    
    def simple_serialize(self):
        """
        """
        return{
            "content": self.content
        }

    


        


