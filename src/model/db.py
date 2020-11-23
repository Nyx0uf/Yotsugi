#!/usr/bin/env python3
# coding: utf-8

"""
Notes database
"""

import sqlite3
import time
from typing import List

from model import note

class Database:
    """"""
    def __init__(self, name: str):
        self.db_name = name
        self.table_name = str("notes")
        self.create_table_if_needed()

    def create_table_if_needed(self):
        """Create`table_name` if it does not exist"""
        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        cursor.execute(f"SELECT count(name) FROM sqlite_master WHERE type='table' AND name='{self.table_name}'")
        if cursor.fetchone()[0] == 0:
            cursor.execute(f"CREATE TABLE {self.table_name}(id INTEGER PRIMARY KEY, title TEXT NOT NULL, content TEXT, creation_date INTEGER NOT NULL, update_date INTEGER NOT NULL)")
        self.conn.commit()
        self.conn.close()

    def get_notes(self) -> List[note.Note]:
        """Returns a list of all notes"""
        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        cursor.execute(f"SELECT * FROM {self.table_name}")
        rows = cursor.fetchall()
        notes: List[note.Note] = []
        for row in rows:
            n = note.Note(int(row[0]), row[1], row[2], int(row[3]), int(row[4]))
            notes.append(n)
        self.conn.commit()
        self.conn.close()
        return notes

    def get_note(self, note_id: int) -> note.Note:
        """Returns a single note given an id or None"""
        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        cursor.execute(f"SELECT * FROM {self.table_name} WHERE id = {note_id}")
        tmp = cursor.fetchone()
        self.conn.commit()
        self.conn.close()
        if tmp:
            return note.Note(int(tmp[0]), tmp[1], tmp[2], int(tmp[3]), int(tmp[4]))
        return None

    def create_note(self, title: str, content: str) -> note.Note:
        """Create a note with `title`"""
        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        current_date = int(time.time())
        cursor.execute(f"INSERT INTO {self.table_name}(title, content, creation_date, update_date) VALUES('{title}', '{content}', {current_date}, {current_date})")
        note_id = cursor.lastrowid
        self.conn.commit()
        self.conn.close()
        return note.Note(note_id, title, None, current_date, current_date)

    def delete_note(self, note_id: int):
        """Delete the note with `note_id`"""
        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        cursor.execute(f"DELETE FROM {self.table_name} WHERE id = {note_id}")
        self.conn.commit()
        self.conn.close()

    def update_note(self, note_id: int, title: str, content: str) -> note.Note:
        """Update the note with `note_id`"""
        if title is None and content is None:
            return self.get_note(note_id)

        self.conn = sqlite3.connect(self.db_name)
        cursor = self.conn.cursor()
        current_date = int(time.time())
        sql = f"UPDATE {self.table_name} "
        if title:
            sql += f"SET title='{title}'"
        if content:
            if title:
                sql += f", content='{content}'"
            else:
                sql += f"SET content='{content}'"
        sql += f", update_date={current_date} WHERE id = {note_id}"
        cursor.execute(sql)
        self.conn.commit()
        self.conn.close()
        return self.get_note(note_id)
