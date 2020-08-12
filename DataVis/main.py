import mysql.connector
from tabulate import tabulate

#TODO make graph for month to month spending
#TODO Add month select function
#TODO Add firebase login to get username

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="xxmaster",
  database="fridgeInv"
)

mycursor = mydb.cursor()

def mostSpent ():
  data = []
  mycursor.execute("SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode),productTesting.price * Count(mainTesting.barcode) AS Total FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode ORDER by Total desc limit 3;")
  myresult = mycursor.fetchall()

  for x in myresult:
    data.append(x)
    
  print(tabulate(data))

def mostBought():
    data = []
    mycursor.execute("SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode) AS Total FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode ORDER by Total desc limit 3;")
    myresult = mycursor.fetchall()

    for x in myresult:
      data.append(x)
    print(tabulate(data))

def totalSpend(startMonth,endMonth):
    data = []
    mycursor.execute("SELECT sum(productTesting.price) FROM mainTesting inner join productTesting on mainTesting.barcode=productTesting.barcode WHERE mainTesting.entryTime BETWEEN '2020-08-01' AND '2020-08-31' AND mainTesting.userid='aF63z0R0jlQR7sfOgBAgOCOsQgv1' group by productTesting.price;")
    myresult = mycursor.fetchall()

    for x in myresult:
      data.append(x[0])
    print("Total Amount spent in Month: " ,round(sum(data),2))

def totalProducts(startMonth, endMonth):
    data = []
    mycursor.execute("SElECT COUNT(mainTesting.barcode) AS 'Total Items' FROM mainTesting WHERE mainTesting.entryTime BETWEEN '2020-08-01' AND '2020-08-31' AND mainTesting.userid='aF63z0R0jlQR7sfOgBAgOCOsQgv1';")
    myresult = mycursor.fetchall()

    for x in myresult:
      data.append(x[0])
    print("Total Amount spent in Month: ", data[0])

def mostExp(startMonth,endMonth):
    mycursor.execute("SELECT productTesting.pName, productTesting.price FROM mainTesting JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode ORDER by productTesting.price desc limit 1;")
    myresult = mycursor.fetchall()

    for x in myresult:
      print("Most Expensive Single Item: ", x[0]," R" ,x[1])

mostSpent()
mostBought()
totalSpend(1,2)
totalProducts(1,2)
mostExp(1,2)