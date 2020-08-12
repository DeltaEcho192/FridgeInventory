import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="xxmaster",
  database="fridgeInv"
)

mycursor = mydb.cursor()

mycursor.execute("SELECT * FROM main")

myresult = mycursor.fetchall()

for x in myresult:
  print(x[0])