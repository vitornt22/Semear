// ignore: unused_element
double _getScreenWidth(double w) {
  if (w < 800) {
    return 0;
  } else if (w > 800 && w < 1000) {
    return 100;
  } else if (w > 1000 && w < 1200) {
    return 200;
  } else if (w > 1200 && w < 1300) {
    return 250;
  } else if (w > 1300 && w < 1400) {
    return 300;
  } else if (w > 1400 && w < 1600) {
    return 400;
  } else if (w > 1400 && w < 1600) {
    return 400;
  } else if (w > 1600 && w < 1800) {
    return 500;
  }

  return 600;
}
