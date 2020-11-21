# Yotsugi

**Yotsugi** is a very simple notes manager written in Python 3. It comes with a RESTful API, a CLI and readonly web pages to render notes.

## Server

First install **Flask** package.

```bash
pip3 install Flask
```

Then run `yotsugi_server.py`.

You can check if it's working correctly by going to `http://localhost:9950`

### systemd

If running Linux you can create a **systemd** service, use the *yotsugi.systemd.service* template file and edit the `User` and `ExecStart` values.

## Client

First install the **requests** package.

```bash
pip3 install requests
```

Next create a configuration file named `~/yotsugi/yotsugi.conf` with the following content :

```ini
[SERVER]
url = http://SERVER_IP
port = SERVER_PORT
```

then run `yotsugi_cli.py -h` to see available options.

## API Usage

There is a postman collection available in the postman folder which implement the API described below.

### Creating a note

Make a *POST* request to `SERVER_URL/api/notes/add` with the following body :

```json
"title": "Your note title"
"content": "Your note content"
```

The note object will be returned as JSON.

```json
{
    "content": null,
    "creation_date": 1605976147,
    "id": 4,
    "title": "Note title",
    "update_date": 1605976147
}
```

*content* is optional.

### Deleting a note

Make a *DELETE* request to `SERVER_URL/api/notes/delete/<note_id>`.

### Updating a note

Make a *PUT* request to `SERVER_URL/api/notes/update/<note_id>` with the following body :

```json
"title": "Updated title"
"content": "Updated content"
```

*title* and *content* are optional and if neither are specified the note won't be updated.

### Getting all notes

Make a *GET* request to `SERVER_URL/api/notes`.

```json
[
    {
        "content": "cool",
        "creation_date": 1605953529,
        "id": 1,
        "title": "note 1",
        "update_date": 1605953529
    },
    {
        "content": "blah",
        "creation_date": 1605963787,
        "id": 2,
        "title": "note 2",
        "update_date": 1605966217
    },
]
```

### Getting a single note

Make a *GET* request to `SERVER_URL/api/notes/<note_id>`.

```json
{
    "content": "note content",
    "creation_date": 1605953529,
    "id": 1,
    "title": "note title",
    "update_date": 1605953529
}
```

## LICENSE

**Yotsugi** is released under the MIT License, see LICENSE file.
