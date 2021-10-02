import 'package:vector_math/vector_math_64.dart' hide Colors;

class SensorReading{
  int time;
  Vector3 data;
  SensorReading(this.time, this.data);
}