#!/usr/bin/env python3
# coding: utf-8

"""
Note class
"""

class Note:
    """"""
    def __init__(self, note_id: int, title: str, content: str, creation_date: int, update_date: int):
        self.id = note_id
        self.title = title
        self.content = content
        self.creation_date = creation_date
        self.update_date = update_date

    def __str__(self):
        return "{}:{}".format(self.id, self.title)

    def __repr__(self):
        return "{}:{}".format(self.id, self.title)

    def __hash__(self):
        return hash(self.id)

    def __eq__(self, other):
        return self.id == other.id
