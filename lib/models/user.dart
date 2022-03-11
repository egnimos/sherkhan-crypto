class User {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String userEmail;
  final String mobile;
  final String panNo;
  final String aadharNo;
  final String bankName;
  final String accountNo;
  final String ifsc;
  final String kycStatus;
  final String balance;
  final String refNo;
  final String totalInvested;
  final String imageName;
  // final String address;
  // final String state;
  // final String zip;
  // final String country;
  final String secret;
  final String paidDate;
  final String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.userEmail,
    required this.mobile,
    required this.panNo,
    required this.aadharNo,
    required this.bankName,
    required this.accountNo,
    required this.ifsc,
    this.kycStatus = "",
    required this.balance,
    required this.refNo,
    required this.totalInvested,
    required this.imageName,
    // required this.address,
    // required this.state,
    // required this.zip,
    // required this.country,
    required this.paidDate,
    required this.updatedAt,
    this.secret = "",
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data["id"],
        firstName: data["firstname"],
        lastName: data["lastname"],
        userName: data["username"],
        email: data["email"],
        userEmail: data["user_email"],
        mobile: data["mobile"],
        panNo: data["pan_no"],
        aadharNo: data["aadhar_no"],
        bankName: data["bank_name"],
        accountNo: data["account_no"],
        ifsc: data["ifsc_code"],
        kycStatus: data["kyc_status"],
        balance: data["balance"],
        refNo: data["total_ref_com"],
        totalInvested: data["total_invest"],
        imageName: data["image"],
        // address: data["address"]["address"],
        // state: data["address"]["state"],
        // zip: data["address"]["zip"],
        // country: data["address"]["country"],
        paidDate: data["paid_date"],
        updatedAt: data["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstName,
        "lastname": lastName,
        "username": userName,
        "email": email,
        "user_email": userEmail,
        "mobile": mobile,
        "pan_no": panNo,
        "aadhar_no": aadharNo,
        "bank_name": bankName,
        "account_no": accountNo,
        "ifsc_code": ifsc,
        "kyc_status": kycStatus,
        "balance": balance,
        "total_ref_com": refNo,
        "total_invest": totalInvested,
        "image": imageName,
        "paid_date": paidDate,
        "updated_at": updatedAt,
        "secret": secret,
      };
}
