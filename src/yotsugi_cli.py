#!/usr/bin/env python3
# coding: utf-8

"""
Client
"""

import argparse
import sys
from configparser import ConfigParser
from pathlib import Path
from typing import List, Dict

import requests
from requests.models import HTTPBasicAuth

from model import note

def load_cfg() -> ConfigParser:
    """Load the client config file"""
    cfg_path = Path.home().joinpath(".yotsugi").joinpath("yotsugi.conf")
    cfg = ConfigParser()
    cfg.read(cfg_path)
    return cfg

def get_auth(cfg: ConfigParser) -> HTTPBasicAuth:
    """Returns basic auth info or `None`"""
    def has_auth_infos(cfg: ConfigParser) -> bool:
        """Check if http basic auth infos are provided"""
        return cfg.has_option("SERVER", "basic_auth_user") and cfg.has_option("SERVER", "basic_auth_password")
    return HTTPBasicAuth(cfg.get("SERVER", "basic_auth_user"), cfg.get("SERVER", "basic_auth_password")) if has_auth_infos(cfg) is True else None

def get_url(cfg: ConfigParser) -> str:
    return f"{cfg.get('SERVER', 'url')}:{cfg.get('SERVER', 'port')}"

def list_notes(cfg: ConfigParser):
    """List all notes"""
    response = requests.get(f"{get_url(cfg)}/api/notes", auth=get_auth(cfg))
    if response.status_code == 200:
        notes: List[Dict] = response.json()
        print(f"{len(notes)} Note{'' if len(notes) == 1 else 's'} :")
        for d in notes:
            n = note.Note(d["id"], d["title"], d["content"], d["creation_date"], d["update_date"])
            print(f"\t- {n.title} (id {n.id})")

def show_note(cfg: ConfigParser, note_id: int):
    """Show the note `note_id`"""
    response = requests.get(f"{get_url(cfg)}/api/notes/{note_id}", auth=get_auth(cfg))
    if response.status_code == 200:
        tmp = response.json()
        n = note.Note(tmp["id"], tmp["title"], tmp["content"], tmp["creation_date"], tmp["update_date"])
        print(f"{n.title} :\n---")
        print(f"{n.content}")

def create_note(cfg: ConfigParser, title: str, body: str):
    """Create a new note with a title and body"""
    response = requests.post(f"{get_url(cfg)}/api/notes/add", data={"title": title, "content": body}, auth=get_auth(cfg))
    if response.status_code == 200:
        print(f"[+] Note created")
    else:
        print(f"[!] Error creating note : {response}")

def delete_note(cfg: ConfigParser, note_id: int):
    """Delete the note `note_id`"""
    response = requests.delete(f"{get_url(cfg)}/api/notes/delete/{note_id}", auth=get_auth(cfg))
    if response.status_code == 200:
        print(f"[+] Note {note_id} deleted")
    else:
        print(f"[!] Error deleting note {note_id} : {response}")

def update_note(cfg: ConfigParser, note_id: int, title: str, body: str):
    """Update the note `note_id`"""
    response = requests.put(f"{get_url(cfg)}/api/notes/update/{note_id}", data={"title": title, "content": body}, auth=get_auth(cfg))
    if response.status_code == 200:
        print(f"[+] Note {note_id} updated")
    else:
        print(f"[!] Error updating note {note_id} : {response}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-l", "--list", dest="list", action='store_true', help="List all notes")
    parser.add_argument("-s", "--show", dest="show", action='store_true', help="Show the given note")
    parser.add_argument("-c", "--create", dest="create", action='store_true', help="Create a new note")
    parser.add_argument("-d", "--delete", dest="delete", action='store_true', help="Delete a note")
    parser.add_argument("-u", "--update", dest="update", action='store_true', help="Update a note")
    parser.add_argument("-i", "--id", dest="id", type=int, default=0, help="Note id")
    parser.add_argument("-t", "--title", dest="title", type=str, default=None, help="Note title")
    parser.add_argument("-b", "--body", dest="body", type=str, default=None, help="Note body")
    args = parser.parse_args()

    cfg = load_cfg()

    if args.list is True:
        list_notes(cfg)
        sys.exit(0)

    if args.show is True and args.id > 0:
        show_note(cfg, args.id)

    if args.delete is True and args.id > 0:
        delete_note(cfg, args.id)
        list_notes(cfg)

    if args.create is True and args.title and len(args.title) > 0:
        create_note(cfg, args.title, args.body)
        list_notes(cfg)

    if args.update is True and args.id > 0:
        update_note(cfg, args.id, args.title, args.body)
        list_notes(cfg)
