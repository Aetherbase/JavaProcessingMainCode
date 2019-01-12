import processing.serial.*;
import processing.net.*;
import java.net.*;
import java.io.*;
import javax.swing.*;
import P5ireBase.library.*;

Server main;
Serial arduino;
String val, mydevice;
int devicemode;
int port = 5000;
String infromserver;
P5ireBase fire;


String HTTP_GET_REQUEST = "GET /";
String HTTP_HEADER = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
String HTML_SCRIPT = "<html><head><title>myM</title></head><body><h3>Hello World, Here we begin!</h3></body></html>";
String execread, er;
String dbserver = "https://sdc-proj-1.firebaseio.com";
void setup()
{
  mydevice = Serial.list()[0];
  arduino = new Serial(this, mydevice, 9600);
  fire = new P5ireBase(this, dbserver);
  main = new Server(this, port);
  try
  {
    Process s = Runtime.getRuntime().exec("netsh interface ip show address Wi-Fi");
    BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
    BufferedReader err = new BufferedReader(new InputStreamReader(s.getErrorStream()));
    while ((execread=in.readLine()) != null) 
    { 
      er+=execread;
    }
    println("\n\n\n");
    int ccc = er.indexOf("IP Address:");
    int ddd = er.indexOf("Subnet Prefix");
    er = er.substring(ccc+38, ddd);//get IPv4 address of adapter
    in.close();
    while ((execread=err.readLine()) != null) println(execread);
    err.close();
    s.waitFor();
    println("Assigned IP: " + er);
    println("Port:        " + port);
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}

void draw()
{

  Client c = main.available();
  if (c!=null)
  {
    //println(c.ip());
    infromserver = c.readString(); //get tcp socket data from client
    arduino.write(infromserver);

  }



  if (arduino.available()>0)
  {
    val = arduino.readStringUntil('\n');
  }
  try {
    if (val.indexOf("MODE0")>0)
    {
      println("Switched to Manual mode");
    } else if (val.indexOf("MODE1")>0)
    {
      println("Automatic Mode");
      //play an exe file

      launch("C:/Runnable/a.CR2");
    }
  }
  catch(Exception e)
  {
  }
  //get position and send it to firebase

  String signal = "Position: ";
  try {
    String BB = val.substring(0, 10);
    String LAThemisphere="", LONhemisphere="";
    if (BB.equals(signal))
    {
      String LAT = val.substring(10, 18); //22,29for lon
      int LATzero = LAT.indexOf('0');
      if (LATzero == 0) LAT = LAT.substring(1);
      LAThemisphere += (char)val.charAt(19); //30forlon
      String LON = val.substring(22, 29);
      int LONzero = LON.indexOf('0');
      if (LONzero ==0) LON = LON.substring(1);
      LONhemisphere += ((char)val.charAt(32));

      //send to firebase
      String latitude = (nf(float(LAT), 0, 6));
      String longitude = (nf(float(LON), 0, 6));
      fire.setValue("Latitude", latitude);
      fire.setValue("Longitude", longitude);
      fire.setValue("Latitude Direction", LAThemisphere);
      fire.setValue("Longitude Direction", LONhemisphere);
      LAThemisphere="";
      LONhemisphere="";
    }
  } 
  catch(Exception e)
  {
  }


  val="";
}
