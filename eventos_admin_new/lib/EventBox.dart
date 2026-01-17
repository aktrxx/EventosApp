// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable, use_key_in_widget_constructors, must_be_immutable, empty_constructor_bodies, annotate_overrides, file_names

import 'package:eventos_admin_new/eventpage.dart';
import 'package:flutter/material.dart';
import './img.dart';

class EventBox extends StatelessWidget {
  String titleText;
  String descrText = '';
  int pageFrom;
  String dateTime;
  String imageLink;
  String eventOrgV;
  String eventOrg;
  String refe;

  EventBox({
    required this.eventOrg,
    required this.eventOrgV,
    required this.refe,
    required this.titleText,
    required this.descrText,
    required this.dateTime,
    required this.imageLink,
    required this.pageFrom,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(
              eventTitle: titleText,
              eventOrgV: eventOrgV,
              eventOrg: eventOrg,
              imageLink: imageLink,
              refe: refe,
              eventDescription: descrText,
              pageFrom: pageFrom,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 120,
          child: Row(
            children: [
              // Event Poster Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Container(
                  width: 100,
                  height: 120,
                  color: Colors.grey[300],
                  child: imageLink.isNotEmpty
                      ? Image.network(
                          imageLink,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
                        )
                      : Icon(
                          Icons.event,
                          size: 40,
                          color: Colors.grey,
                        ),
                ),
              ),
              
              // Event Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Date/Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dateTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      
                      // Organization
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              eventOrg,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Arrow Icon
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
