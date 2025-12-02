from db import db, User, Course, Session, Friend, Message
from flask import Flask, request
import json
from google.oauth2 import id_token
from google.auth.transport import requests as grequests
from dotenv import load_dotenv
import os
from fetch_classes import fetch_all, fetch_classes_for_subject

app = Flask(__name__)
db_filename = "cms.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

load_dotenv()
GOOGLE_CLIENT_ID=os.getenv("GOOGLE_CLIENT_ID")
GOOGLE_CLIENT_SECRET = os.getenv("GOOGLE_CLIENT_SECRET")

db.init_app(app)
with app.app_context():
        db.create_all()

def success_response(data, code=200):
    """
    """
    return json.dumps(data), code

def failure_response(data, code=404):
    """
    """
    return json.dumps({"error": data}), code

@app.route("/course/fetch/", methods=["POST"])
def fetch_course():
    """
    """
    print("Fetching start")
    fetch_all(app)
    return {"status": "ok"}, 200

# ------------------- GOOGLE LOGIN -------------------
@app.route("/auth/google/", methods=["POST"])
def google_login():
     """
     Endpoint for Handling Google OAuth login 
     """
     try:
        body=json.loads(request.data)
        token=body.get("token_id")
        if not token:
            return failure_response("Missing ID Token", 400)
        idinfo=id_token.verify_oauth2_token(token, grequests.Request(), GOOGLE_CLIENT_ID)
        user_id=idinfo["sub"]
        email=idinfo.get("email")
        name=idinfo.get("name")
        picture=idinfo.get("picture")
        user=User.get_by_google_id(user_id)
        if not user:
            user = User(google_id=user_id, email=email, name=name, picture=picture)
        return success_response(user.serialize(), 201)
     except ValueError:
          return failure_response("Invalid token", 400)

# ------------------- USER ROUTES -------------------
@app.route("/users/<int:user_id>/")
def get_user_by_id(user_id):
     """
     Endpoint for getting user by id
     """
     user = User.query.filter_by(id=user_id).first()
     if user is None:
        return failure_response("User not found!")
     return success_response(user.serialize())

@app.route("/users/<int:user_id>", methods=["POST"])
def update_user(user_id):
     """
     Endpoint for updating user profile
     """
     body=json.loads(request.data)
     major = body.get("major")
     interests = body.get("interests")
     profile_picture = body.get("profile_picture")
     user = User.query.filter_by(id=user_id).first()
     if user is None:
        return failure_response("User not found!")
     if not major is None:
        user.major = major
     if not interests is None:
         user.interests = interests 
     if not profile_picture is None:
         user.profile_picture=profile_picture 
     db.session.commit()
     return success_response(user.serialize(), 200)

@app.route("/users/<int:user_id>/friend/")
def get_friends(user_id):
    """
    Endpoint for getting all friends of a user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
       return failure_response("User not found!")
    sent = Friend.query.filter_by(user_id=user_id, status="Accepted").all()
    received = Friend.query.filter_by(friend_id=user_id, status="Accepted").all()
    list=[]
    for items in sent:
        list.append(items.friend.simple_serialize())
    for items in received:
        list.append(items.user.simple_serialize())
    return success_response({"friends":list}, 200)

@app.route("/users/<int:user_id>/friend/", methods=["POST"])
def send_friend_request(user_id):
    """
    Endpoint for sending friend request
    """
    body = json.loads(request.data)
    friend_id=body.get("friend_id")
    if friend_id is None or friend_id==user_id:
        return failure_response("Invalid friend_id", 400)
    user = User.query.filter_by(id=user_id).first()
    friend = User.query.filter_by(id=friend_id).first()
    if not user or not friend:
        return failure_response("User not found", 404)
    current = Friend.query.filter(
        ((Friend.user_id==user_id) & (Friend.friend_id==friend_id)) | 
        ((Friend.user_id==friend_id) & (Friend.friend_id==user_id))
    ).first()
    if not current is None:
        return failure_response("Friendship already exists", 400)
    new = Friend(user_id=user_id, friend_id=friend_id, status="Pending")
    db.session.add(new)
    db.session.commit()
    return success_response(new.serialize(), 201)
    
@app.route("/users/<int:user_id>/friends/<friend_id>/", methods=["POST"])
def respond_request(user_id, friend_id):
    """
    Endpoint for accepting or rejecting request
    """
    body = json.loads(request.data)
    action = body.get("action")
    if action not in ["accept","reject"]:
        return failure_response("Invalid action", 400)
    current = Friend.query.filter(
        ((Friend.user_id==user_id) & (Friend.friend_id==friend_id)) | 
        ((Friend.user_id==friend_id) & (Friend.friend_id==user_id))
    ).first()
    if not current:
        return failure_response("Friendship not found", 404)
    if action=="accept":
        current.status = "Accepted"
        db.session.commit()
        return success_response(current.serialize(), 201)
    else:
        db.session.delete(current)
        db.session.commit()
        return success_response({"Friend request rejected"}, 200)
    
# ------------------- COURSE ROUTES -------------------
@app.route("/courses/")
def get_courses():
    """
    """
    courses = []
    for course in Course.query.all():
        courses.append(course.simple_serialize())
    return success_response({"courses": courses})

@app.route("/courses/<int:course_id>/")
def get_course_by_code(course_id):
    """
    """
    course = Course.query.filter_by(id=course_id).first()
    if not course:
        return failure_response("Course not found", 404)
    return success_response(course.serialize())

# ------------------- COURSE ROUTES -------------------
@app.route("/session/<int:session_id>/")
def get_sessions(session_id):
    """
    """
    session = Session.query.filter_by(id=session_id).first()
    if not session:
        return failure_response("Session not found", 404)
    return success_response(session.serialize())

# ------------------- SCHEDULE ROUTES -------------------
@app.route("/users/<int:user_id>/schedule/")
def get_user_schedule(user_id):
    """
    """
    user=User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)
    list= [s.serialize() for s in user.sessions]
    return success_response({"sessions": list}, 200)

@app.route("/users/<int:user_id>/schedule/", methods=["POST"])
def add_session_to_schedule(user_id):
    """
    """
    user=User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)
    body=json.loads(request.data)
    session_id = body.get("session_id")
    if not session_id:
        return failure_response("Invalid body information", 400)
    session=Session.query.filter_by(id=session_id).first()
    if not session:
        return failure_response("Session not found", 404)
    if session in user.sessions:
        return failure_response("Session already in schedule", 400)
    user.sessions.append(session)
    db.session.commit()
    return success_response(user.serialize(), 201)

@app.route("/users/<int:user_id>/schedule/<int:session_id>/", methods=["DELETE"])
def remove_session_from_schedule(user_id, session_id):
    """
    """
    user=User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)
    if not session_id:
        return failure_response("Invalid body information", 400)
    session=Session.query.filter_by(id=session_id).first()
    if not session:
        return failure_response("Session not found", 404)
    if session in user.sessions:
        user.sessions.remove(session)
        db.session.commit()
    return success_response(user.serialize(), 200)

# ------------------- MESSAGE ROUTES -------------------
@app.route("/messages/send/", methods=["POST"])
def send_message():
    """
    """
    body=json.loads(request.data)
    sender_id = body.get("sender_id")
    receiver_id = body.get("receiver_id")
    content = body.get("content", "")
    if not sender_id or not receiver_id or not content:
        return failure_response("Invalid body information", 400)
    sender = User.query.get(sender_id)
    receiver = User.query.get(receiver_id)
    if not sender or not receiver:
        return failure_response("User not found", 404)
    message = Message(sender_id=sender_id,receiver_id=receiver_id,content=content)
    db.session.add(message)
    db.session.commit()
    return success_response(message.serialize(), 201)

@app.route("/messages/<int:user_id>/<int:friend_id>/")
def get_conversation(user_id, friend_id):
    """
    """
    user=User.query.filter_by(id=user_id).first()
    friend=User.query.filter_by(id=friend_id).first()
    if not user or not friend:
        return failure_response("User not found", 404)
    messages = Message.query.filter(
        ((Message.sender_id == user_id) & (Message.receiver_id == friend_id)) |
        ((Message.sender_id == friend_id) & (Message.receiver_id == user_id))
    ).order_by(Message.sent_at).all()
    return success_response({"messages": [m.simple_serialize() for m in messages]}, 200)

@app.route("/messages/<user_id>/conversations/")
def get_inbox_preview(user_id):
    """
    """
    user=User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)
    messages = Message.query.filter(
        (Message.sender_id==user_id)|(Message.receiver_id==user_id)
    ).order_by(Message.sent_at.desc()).all()
    conversations = {}
    for items in messages:
        if items.sender_id==user_id:
            friend_id=items.receiver_id
        else:
            friend_id=items.sender_id
        if friend_id not in conversations:
            conversations[friend_id]=items.simple_serialize()
    return success_response({"conversations": conversations}, 200)

# ------------------- SEARCH ROUTES -------------------
@app.route("/courses/search/")
def search_courses():
    """
    """
    query = request.args.get("q","")
    query = query.strip()
    if len(query)<3:
        return success_response({"courses":[], "sessions":[]})
    courses = Course.query.filter(
        (Course.code.ilike(f"%{query}%"))|(Course.name.ilike(f"%{query}%"))
    ).all()
    return success_response({"courses":[c.simple_serialize() for c in courses]}, 200)

@app.route("/users/<int:user_id>/match/", methods=["POST"])
def match_buddy(user_id):
    """
    Request JSON:
    {
        "course_code": "Math1920",
        "session_ids": [2, 12]  #optional
    }
    """
    body=json.loads(request.data)
    code = body.get("course_code")
    session_ids = body.get("session_ids",[])
    if not code:
        return failure_response("Invalid body information", 400)
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return failure_response("User not found", 404)
    course = Course.query.filter_by(code=code).first()
    if not course:
        return failure_response("Course not found", 404)
    if session_ids:
        sessions = Session.query.filter(Session.id.in_(session_ids)).all()
    else:
        session_ids= [s.id for s in course.sessions]
        sessions = Session.query.filter(Session.id.in_(session_ids)).all()
    if not sessions:
        return failure_response("Session not found", 404)
    potential=[]
    for s in sessions:
        for student in s.students:
            if student.id!=user.id and student not in potential:
                potential.append(student)
    matches=[]
    user_majors = [m.strip().lower() for m in (user.major or "").split(",")]
    user_interests = [i.strip().lower() for i in (user.interests or "").split(",")]

    for buddy in potential:
        score=0
        buddy_majors= [m.strip().lower() for m in (buddy.major or "").split(",")]
        buddy_interests = [i.strip().lower() for i in (buddy.interests or ""). split(",")]
        if any(m in buddy_majors for m in user_majors):
            score+=1
        score+=sum(1 for i in user_interests if i in buddy_interests)
        matches.append({"student": buddy.simple_serialize(), "score": score})
    
    matches.sort(key=lambda x: x["score"], reverse=True)
    return success_response({"matches": matches}, 200)    
        

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)