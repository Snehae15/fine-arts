import 'package:fine_arts/admin/AdminEvent.dart';
import 'package:fine_arts/admin/orgDetails.dart';
import 'package:fine_arts/admin/studentlistbuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).w,
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(children: [
                      StdlistBuilder(),
                      OrgDetails(),
                      AdminEvent()
                    ]),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                // padding: EdgeInsets.all(10.w),
                height: 60.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: Color(0xFF204563)),
                child: TabBar(
                    indicatorPadding:
                        EdgeInsets.only(left: 0, top: 15, bottom: 15),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.r),
                        color: Color(0xFFFDBE40),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4.r,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ]),
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: 72.w,
                          child: Center(
                            child: Text(
                              'Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Text(
                            'Organizer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Text(
                            'Event',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
