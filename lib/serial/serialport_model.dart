class SerialPortInfo {
  SerialPortInfo(this.name, this.address, this.description, this.manufacturer,
      this.serialNumber);

  factory SerialPortInfo.empty() {
    return SerialPortInfo("", -1, "", "", "");
  }

  final int address;
  final String description;
  final String manufacturer;
  final String name;
  final String serialNumber;

  // final int productId;
  // final int vendorId;
  bool get isINav => this.manufacturer == "INAV";

  info() {
    print('\address: ${this.address}');
    print('\tDescription: ${this.description}');
    print('\tManufacturer: ${this.manufacturer}');
    print('\tSerial Number: ${this.serialNumber}');
    // print('\tProduct ID: 0x${this.productId.toRadixString(16)}');
    // print('\tVendor ID: 0x${this.vendorId.toRadixString(16)}');
  }
}
