import de.bezier.data.sql.*;  //import the MySQL library
import processing.serial.*;   //import the Serial library

MySQL msql;      //Create MySQL Object
String[] a;
int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
Serial port;     // The serial port, this is a new instance of the Serial class (an Object)

void setup() {
  String user     = "user12";
  String pass     = "user12";
  String database = "user12";
  
  msql = new MySQL( this, "10.50.202.242", database, user, pass );
  port = new Serial(this, "COM4", 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)  
  //port = new Serial(this, Serial.list()[0], 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();  // function from serial library that throws out the first reading, in case we started reading in the middle of a string from Arduino
  serial = port.readStringUntil(end); // function that reads the string from serial port until a println and then assigns string to our string variable (called 'serial')
  serial = null; // initially, the string will be null (empty)
}
void draw() 
{
  
  while (port.available() > 0) 
  { 
    //as long as there is data coming from serial port, read it and store it 
    serial = port.readStringUntil(end);
  }
    if (serial != null) 
    {  
      //if the string is not empty, print the following
      //Note: the split function used below is not necessary if sending only a single variable. However, it is useful for parsing (separating) messages when
      //reading from multiple inputs in Arduino. Below is example code for an Arduino sketch
    
      a = split(serial, ',');  //a new array (called 'a') that stores values into separate cells (separated by commas specified in your Arduino program)
      //print(a);
      //Sleep_Phase=a[0];
      //print(a[0]); //print Temperature 
      //print(a[1]); //print Luminiscence
      //print(a[2]); //print Humidity
      //print(a[3]); //print Sleep_status
      
      print(a[0]); //print status
      print(a[1]); //print Luminiscence
      print(a[2]); //print temp
      print(a[3]); //print humidity
      //println(a[4]); //print Sleep_status
      function();
    }
}

void function()
{
  if ( msql.connect() )
    {
        //msql.query( "insert into Sleeping_Phase(Temperature,Luminiscence,Humidity,Status)values("+a[0]+","+a[1]+","+a[2]+",'%s')",a[3]);
        msql.query( "insert into Sleeping_Phase2(Status,Luminiscence,Temperature,Humidity,)values('%s',"+a[1]+","+a[2]+","+a[3]+")",a[0]);
        //msql.query( "insert into Sleeping_Phase(Temperature,Luminiscence,Humidity)values("+a[0]+","+a[1]+","+a[2]+")");
        
        //msql.query( "insert into Test(Temperature,Luminiscence,Humidity,Status)values("+a[0]+","+a[1]+","+a[2]+",'%s')",a[3]);
    }
    else
    {
        // connection failed !  
    }
    msql.close();  //Must close MySQL connection after Execution
}