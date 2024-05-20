List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      // contentPadding: 10,
      icon: current == 0
          ? Image.asset(
              "assets/nav/wn1.png",
              height: 2.h,
              width: 3.3.h,
            )
          : Image.asset(
              "assets/nav/home.png",
              height: 2.h,
              width: 3.3.h,
            ),

      activeColorPrimary: MyColors.white,
      // iconSize: 2.h,
      inactiveColorSecondary: Color(0xff9CA3AF),
      // iconSize: 4.h,

      textStyle: TextStyle(
          fontSize: 13.5.sp,
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500),

      inactiveColorPrimary: Color(0xff9CA3AF),
      // inactiveColorSecondary: Colors.purple,
    ),
    PersistentBottomNavBarItem(
      // contentPadding: 10,
      icon: current == 1
          ? Image.asset(
              "assets/nav/wn2.png",
              height: 2.h,
              width: 3.3.h,
            )
          : Image.asset(
              "assets/nav/search.png",
              height: 2.h,
              width: 3.3.h,
            ),

      activeColorPrimary: MyColors.white,
      // iconSize: 2.h,
      inactiveColorSecondary: Color(0xff9CA3AF),
      // iconSize: 4.h,

      textStyle: TextStyle(
          fontSize: 13.5.sp,
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500),

      inactiveColorPrimary: Color(0xff9CA3AF),
      // inactiveColorSecondary: Colors.purple,
    ),
    PersistentBottomNavBarItem(
      // contentPadding: 10,
      icon: current == 2
          ? Image.asset(
              "assets/nav/wn3.png",
              height: 2.h,
              width: 3.3.h,
            )
          : Image.asset(
              "assets/nav/n3.png",
              height: 2.h,
              width: 3.3.h,
            ),

      activeColorPrimary: MyColors.white,
      // iconSize: 2.h,
      inactiveColorSecondary: Color(0xff9CA3AF),
      // iconSize: 4.h,

      textStyle: TextStyle(
          fontSize: 13.5.sp,
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500),

      inactiveColorPrimary: Color(0xff9CA3AF),
      // inactiveColorSecondary: Colors.purple,
    ),
    PersistentBottomNavBarItem(
      // contentPadding: 10,
      icon: current == 3
          ? Image.asset(
              "assets/nav/wn4.png",
              height: 2.h,
              width: 3.3.h,
            )
          : Image.asset(
              "assets/nav/n4.png",
              height: 2.h,
              width: 3.3.h,
            ),

      activeColorPrimary: MyColors.white,
      // iconSize: 2.h,
      inactiveColorSecondary: Color(0xff9CA3AF),
      // iconSize: 4.h,

      textStyle: TextStyle(
          fontSize: 13.5.sp,
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500),

      inactiveColorPrimary: Color(0xff9CA3AF),
      // inactiveColorSecondary: Colors.purple,
    ),
  ];
}