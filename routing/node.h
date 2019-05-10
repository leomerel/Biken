#ifndef NODE_H
#define NODE_H

#include <iostream>
#include <string>
#include <QDebug>
#include <QTextStream>

using namespace std;

class Node
{
public :
  Node(unsigned long long id,double lat,double lon); //constructor
  Node();

  //getter (no setter bc it is read-only)
  unsigned long long getId() const;
<<<<<<< routing/node.h
=======

>>>>>>> routing/node.h
  double getLatitude() const;
  double getLongitude() const;

  double getDistance() const;
  void setDistance(double value);


  unsigned long long getPrecedingNodeId() const;
  void setPrecedingNodeId(unsigned long long value);

private :
  unsigned long long id;          //id of the Node
  double latitude;    //latitude of the node
  double longitude;   //longitude of the node
  double distance=999999999;
  unsigned long long precedingNodeId;
};

#endif // NODE_H
