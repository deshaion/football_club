
class ObjectReader {
  String _delim = "#";
  String _buffer;
  int pos = 0;

  ObjectReader(String buffer) {
    this._buffer = buffer;
  }

  int readInt() {
    if (pos >= _buffer.length) {
      throw new Exception("Wrong buffer value");
    }
    int first = pos;
    while (_buffer[pos] != _delim) {
      pos++;
    }
    int res = int.parse(_buffer.substring(first, pos));
    pos++;
    return res;
  }

  String readString() {
    if (pos >= _buffer.length) {
      throw new Exception("Wrong buffer value");
    }
    int first = pos;
    while (_buffer[pos] != _delim) {
      pos++;
    }
    String res = _buffer.substring(first, pos);
    pos++;
    return res;
  }

  bool readBool() {
    if (pos >= _buffer.length) {
      throw new Exception("Wrong buffer value");
    }
    bool res = _buffer[pos] == "1" ? true : false;
    pos += 2;
    return res;
  }

  List<int> readListInt() {
    List<int> res = [];
    int n = readInt();
    for (var i = 0; i < n; i++) {
      res.add(readInt());
    }
    return res;
  }
}