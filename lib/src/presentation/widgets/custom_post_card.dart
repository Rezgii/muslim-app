import 'dart:ui';

import 'package:flutter/material.dart';

class CustomPostCard extends StatelessWidget {
  const CustomPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: h * 0.02,
                top: h * 0.02,
                bottom: h * 0.01,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 50),
                  // Name & Verified Icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      // color: Colors.black.withAlpha((0.6 * 255).round()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Belghithe Abderazak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.verified, color: Colors.orange, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                ClipPath(
                  clipper: ProfileCardClipper(),
                  child: Image.asset(
                    'assets/images/post1.jpg',
                    fit: BoxFit.cover,
                    width: w * 0.9,
                    height: h * 0.3,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/profile1.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.favorite, color: Colors.white, size: 23),
                            SizedBox(height: 5),
                            Text(
                              '2.9k',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 10),
                            Icon(
                              Icons.mode_comment,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '133',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.01),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: w * 0.88,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(w * 0.035),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.03),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$950',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Slide for more details',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProfileCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double profileRadius = 25;
    double curvePadding = 10; 
    double cornerRadius = 30;

    Path path = Path();
    path.moveTo(profileRadius * 3, 0);

    // Top Right Curve
    path.lineTo(size.width - profileRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, profileRadius);

    // Right Side
    path.lineTo(size.width, size.height - profileRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - profileRadius,
      size.height,
    );

    // Bottom Side
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Left Side (Adding the Profile Cutout)
    path.lineTo(0, profileRadius * 3 + curvePadding);

    // First Quadratic Bezier Curve
    path.quadraticBezierTo(
      0,
      profileRadius * 2,
      profileRadius,
      profileRadius * 2,
    );

    // Second Quadratic Bezier Curve
    path.quadraticBezierTo(
      profileRadius * 2,
      profileRadius * 2,
      profileRadius * 2,
      profileRadius,
    );

    //Third Quadric Bezier Curve
    path.quadraticBezierTo(profileRadius * 2, 0, profileRadius * 3, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
