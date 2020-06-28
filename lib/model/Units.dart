abstract class AutoScalableVector {
  double getBestValue();

  String getBestUnit();
}

class Temperature implements AutoScalableVector {
  final double rawValue; // C

  Temperature(this.rawValue);

  @override
  String getBestUnit() {
    return 'C';
  }

  @override
  double getBestValue() {
    return rawValue;
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
    return rawValue;
  }
}
