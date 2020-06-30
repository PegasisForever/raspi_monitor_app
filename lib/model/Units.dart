import 'package:intl/intl.dart';

abstract class AutoScalableVector {
  double getBestValue();

  double getRawValue();

  double scaleUse(String unit);

  String getBestUnit();

  String toBestString();
}

final _format = NumberFormat("####.#");

class Temperature implements AutoScalableVector {
  final double rawValue; // C

  Temperature(this.rawValue);

  @override
  String getBestUnit() {
    return '°C';
  }

  @override
  double getBestValue() {
    return rawValue;
  }

  @override
  double getRawValue() {
    return rawValue;
  }

  @override
  double scaleUse(String unit) {
    return rawValue;
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}

class FileSize implements AutoScalableVector {
  final double rawValue; // Byte

  FileSize(this.rawValue);

  FileSize.fromKB(double kb) : rawValue = kb * 1024;

  @override
  String getBestUnit() {
    if (rawValue < 1024) {
      return 'B';
    } else if (rawValue < 1024 * 1024) {
      return 'KB';
    } else if (rawValue < 1024 * 1024 * 1024) {
      return 'MB';
    } else if (rawValue < 1024 * 1024 * 1024 * 1024) {
      return 'GB';
    } else {
      return 'TB';
    }
  }

  @override
  double getBestValue() {
    if (rawValue < 1024) {
      return rawValue;
    } else if (rawValue < 1024 * 1024) {
      return rawValue / 1024.0;
    } else if (rawValue < 1024 * 1024 * 1024) {
      return rawValue / 1024.0 / 1024.0;
    } else if (rawValue < 1024 * 1024 * 1024 * 1024) {
      return rawValue / 1024.0 / 1024.0 / 1024.0;
    } else {
      return rawValue / 1024.0 / 1024.0 / 1024.0 / 1024.0;
    }
  }

  @override
  double getRawValue() {
    return rawValue;
  }

  @override
  double scaleUse(String unit) {
    if (unit == 'B' || unit == null) {
      return rawValue;
    } else if (unit == 'KB') {
      return rawValue / 1024;
    } else if (unit == 'MB') {
      return rawValue / 1024 / 1024;
    } else if (unit == 'GB') {
      return rawValue / 1024 / 1024 / 1024;
    } else if (unit == 'TB') {
      return rawValue / 1024 / 1024 / 1024 / 1024;
    } else {
      throw ('Unkown unit: $unit');
    }
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}

class FileSizePerSecond implements AutoScalableVector {
  final FileSize fileSize;

  FileSizePerSecond(this.fileSize);

  @override
  String getBestUnit() {
    return fileSize.getBestUnit() + "/s";
  }

  @override
  double getBestValue() {
    return fileSize.getBestValue();
  }

  @override
  double getRawValue() {
    return fileSize.getRawValue();
  }

  @override
  double scaleUse(String unit) {
    return fileSize.scaleUse(unit.substring(0, unit.length - 2));
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}

class Frequency implements AutoScalableVector {
  final double rawValue; // mhz

  Frequency(this.rawValue);

  @override
  String getBestUnit() {
    if (rawValue < 1000) {
      return 'MHz';
    } else {
      return 'GHz';
    }
  }

  @override
  double getBestValue() {
    if (rawValue < 1000) {
      return rawValue;
    } else {
      return rawValue / 1000.0;
    }
  }

  @override
  double getRawValue() {
    return rawValue;
  }

  @override
  double scaleUse(String unit) {
    if (unit == 'MHz' || unit == null) {
      return rawValue;
    } else if (unit == 'GHz') {
      return rawValue / 1000;
    } else {
      throw ('Unkown unit: $unit');
    }
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}

class RawNumber implements AutoScalableVector {
  final double rawValue;
  final String unit;

  RawNumber(this.rawValue, this.unit);

  @override
  String getBestUnit() {
    return unit;
  }

  @override
  double getBestValue() {
    return rawValue;
  }

  @override
  double getRawValue() {
    return rawValue;
  }

  @override
  double scaleUse(String unit) {
    return rawValue;
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}

class Percentage implements AutoScalableVector {
  final double rawValue;

  Percentage(this.rawValue);

  @override
  String getBestUnit() {
    return "%";
  }

  @override
  double getBestValue() {
    return rawValue * 100;
  }

  @override
  double getRawValue() {
    return rawValue;
  }

  @override
  double scaleUse(String unit) {
    if (unit == '%') {
      return rawValue * 100;
    } else {
      return rawValue;
    }
  }

  @override
  String toBestString() {
    return _format.format(getBestValue()) + getBestUnit();
  }
}
