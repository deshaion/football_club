
class ObjectWriter {
  String _delim = "#";
  StringBuffer _buffer = new StringBuffer();

  ObjectWriter writeInt(int v) {
    _buffer.write(v);
    _buffer.write(_delim);
    return this;
  }

  ObjectWriter writeString(String s) {
    _buffer.write(s);
    _buffer.write(_delim);
    return this;
  }

  ObjectWriter writeBool(bool b) {
    _buffer.write(b ? 1 : 0);
    _buffer.write(_delim);
    return this;
  }

  ObjectWriter writeListInt(List<int> list) {
    writeInt(list.length);
    for (int x in list) {
      writeInt(x);
    }
    return this;
  }

  String getValue() {
    return _buffer.toString();
  }

}