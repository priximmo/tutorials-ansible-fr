#!/usr/bin/python3

import sqlite3, requests, time, logging, random, json
from flask import Flask, jsonify

prenom = ['xavki', 'xavier', 'pierre', 'paul']
ville = ['Paris', 'Bordeaux', 'Marseile', 'Lyon', 'Caen', 'Toulouse']
nom = ['Dupond', 'Durand', 'Duchemin', 'Dumond', 'Dumaine', 'Duchemin']

conn = sqlite3.connect('database.db')
conn.execute('CREATE TABLE IF NOT EXISTS utilisateurs (prenom STRING, age INTEGER, nom STRING, ville STRING)')
seconds = [0.002, 0.003, 0.004, 0.01, 0.3, 0.2, 0.009, 0.015, 0.02, 0.225, 0.009, 0.001, 0.25, 0.030, 0.018]

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({"message": "response ok"})

@app.route('/delay')
def delay():
    time.sleep(random.choice(seconds))
    return jsonify({"message": "response delay"})

@app.route('/error500')
def error_500():
    value = 'a' + 1
    return jsonify({"message": value})

@app.route('/insert')
def sqlw():
    conn = sqlite3.connect('database.db')
    conn.execute('INSERT INTO utilisateurs VALUES("{}", "{}", "{}", "{}")'.format(random.choice(prenom), random.randint(18,40), random.choice(nom), random.choice(ville)))
    conn.execute('INSERT INTO utilisateurs VALUES("{}", "{}", "{}", "{}")'.format(random.choice(prenom), random.randint(18,40), random.choice(nom), random.choice(ville)))
    conn.execute('INSERT INTO utilisateurs VALUES("{}", "{}", "{}", "{}")'.format(random.choice(prenom), random.randint(18,40), random.choice(nom), random.choice(ville)))
    conn.execute('INSERT INTO utilisateurs VALUES("{}", "{}", "{}", "{}")'.format(random.choice(prenom), random.randint(18,40), random.choice(nom), random.choice(ville)))
    conn.execute('INSERT INTO utilisateurs VALUES("{}", "{}", "{}", "{}")'.format(random.choice(prenom), random.randint(18,40), random.choice(nom), random.choice(ville)))
    conn.commit()
    conn.close()
    return 'ok', 200

@app.route('/select')
def sqlr():
    data = []
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute('select * from utilisateurs')
    rows = cur.fetchall()
    conn.close()
    for row in rows:
      item = {
        "prenom": row[0],
        "nom": row[2],
        "age": row[1],
        "ville": row[3]
        }
      data.append(item)
    jsonData=json.dumps(data)

    return jsonData, 200

@app.route('/groupby')
def slqg():
    data =  []
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute('select count(*) as num, ville from utilisateurs group by ville')
    rows = cur.fetchall()
    conn.close()
    for row in rows:
      item = {
        "ville": row[1],
        "nb": row[0]
        }
      data.append(item)
    jsonData=json.dumps(data)
    return jsonData, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)


