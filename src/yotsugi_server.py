#!/usr/bin/env python3
# coding: utf-8

"""
Server
"""

from pathlib import Path

import flask
from flask import request, jsonify, render_template

from model import db

app = flask.Flask(__name__)

#
# Internal
#
def get_db() -> db.Database:
    """Returns the notes database"""
    dir_path = Path.home().joinpath(".yotsugi")
    if dir_path.exists() is False:
        dir_path.mkdir(exist_ok=True)
    db_path = dir_path.joinpath("yotsugi.db")
    return db.Database(db_path)

#
# App navigation
#
@app.route('/', methods=['GET'])
def index():
    """List notes on the homepage"""
    db = get_db()
    notes = db.get_notes()
    s = sorted(notes, key=lambda x: x.title, reverse=False)
    return render_template('index.html', title='Home', count=len(notes), notes=s)

@app.route('/app/note/<note_id>', methods=['GET'])
def app_get_note(note_id: int):
    """Display the note `note_id`"""
    db = get_db()
    note = db.get_note(note_id)
    return render_template('note.html', title='Note', note=note)

#
# API
#
@app.route('/api/notes', methods=['GET'])
def api_get_notes():
    """Returns all notes"""
    db = get_db()
    notes = db.get_notes()
    return jsonify([o.__dict__ for o in notes])

@app.route('/api/notes/<note_id>', methods=['GET'])
def api_get_note(note_id: int):
    """Returns the note `note_id`"""
    db = get_db()
    note = db.get_note(note_id)
    return jsonify(note.__dict__)

@app.route('/api/notes/add', methods=['POST'])
def api_create_note():
    """Create a note"""
    db = get_db()
    content = request.form["content"] if "content" in request.form.keys() else None
    note = db.create_note(request.form["title"], content)
    return jsonify(note.__dict__)

@app.route('/api/notes/delete/<note_id>', methods=['DELETE'])
def api_delete_note(note_id: int):
    """Delete a note"""
    db = get_db()
    db.delete_note(note_id)
    return jsonify({"message": "ok"})

@app.route('/api/notes/update/<note_id>', methods=['PUT'])
def api_update_note(note_id: int):
    """Update a note"""
    db = get_db()
    title = request.form["title"] if "title" in request.form.keys() else None
    content = request.form["content"] if "content" in request.form.keys() else None
    note = db.update_note(note_id, title, content)
    return jsonify(note.__dict__)

if __name__ == '__main__':
    app.run(host="localhost", port=9950, debug=True)
