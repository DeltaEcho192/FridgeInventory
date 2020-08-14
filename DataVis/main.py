import mysql.connector
from tabulate import tabulate
import matplotlib.pyplot as plt
import numpy as np

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
  total = []
  mycursor.execute("SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode),productTesting.price * Count(mainTesting.barcode) AS Total FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode ORDER by Total desc limit 3;")
  myresult = mycursor.fetchall()

  for x in myresult:
    data.append(x)
    total.append(x[3])
  
  top3 = round(sum(total),2)
  print(tabulate(data))
  return top3

def mostBought():
    data = []
    mycursor.execute("SELECT productTesting.pName,mainTesting.barcode, Count(mainTesting.barcode) AS Total FROM mainTesting INNER JOIN productTesting ON mainTesting.barcode=productTesting.barcode group by mainTesting.barcode ORDER by Total desc limit 3;")
    myresult = mycursor.fetchall()

    for x in myresult:
      data.append(x)
    print(tabulate(data))

def totalSpend(startMonth,endMonth):
    data = []
    mycursor.execute("SELECT sum(productTesting.price) FROM mainTesting inner join productTesting on mainTesting.barcode=productTesting.barcode WHERE mainTesting.entryTime BETWEEN '"+str(startMonth)+"' AND '"+str(endMonth)+"' AND mainTesting.userid='aF63z0R0jlQR7sfOgBAgOCOsQgv1' group by productTesting.price;")
    myresult = mycursor.fetchall()

    for x in myresult:
      data.append(x[0])
    print("Total Amount spent in Month: " ,round(sum(data),2))
    totalM = round(sum(data),2)
    return totalM

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

def monthToM():
  monthStart = int(input("Please Enter Start Month (8 = August)"))
  monthEnd = int(input("Please Enter end months (8 = August)"))

  monthArrS = []
  monthArrE = []
  i = monthStart
  while i < monthEnd + 1:
    monthStartW = i
    monthEndW = i
    if(monthStartW > 9 and monthStartW < 13):
      startDate = "2020-"+str(monthStartW)+"-01"
    else:
      startDate = "2020-0"+str(monthStartW)+"-01"
    if(monthEndW > 9 and monthEndW < 13):
      if (monthEndW % 2) == 0:  
        endDate = "2020-"+str(monthEndW)+"-31"
      else:
        endDate = "2020-"+str(monthEndW)+"-30"
    else:
      if monthEndW in (1,3,5,7,8):
        endDate = "2020-0"+str(monthEndW)+"-31"
      elif monthEndW in (2,4,6,9):
        endDate = "2020-0"+str(monthEndW)+"-30"
    monthArrS.append(startDate)
    monthArrE.append(endDate)
    i = i + 1
  print(monthArrS)
  print(monthArrE)
  x = 0
  totalArr = []
  while x < len(monthArrS):
    totalW = totalSpend(monthArrS[x],monthArrE[x])
    totalArr.append(totalW)
    x = x + 1 
  print(totalArr)
  plt.bar(monthArrS,totalArr, color="blue")
  plt.title("Month To Month Spending")
  plt.xlabel("Months")
  plt.ylabel("Amount in Rands")
  plt.show()




top3 = mostSpent()
mostBought()
totalM = totalSpend("2020-08-01","2020-08-31")
totalProducts(1,2)
mostExp(1,2)
monthToM()

percent = round((top3 / totalM) * 100,1)
print(percent, " % Top 3 items")