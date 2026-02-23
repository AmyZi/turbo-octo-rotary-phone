class ProfileModel {

  ProfileInfo? data;


  ProfileModel(
      {
        this.data,
     });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ProfileInfo.fromJson(json['data']) : null;
  }
}

class ProfileInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;
  String? identificationNumber;
  String? identificationType;
  String? profileImage;
  List<String>? identificationImage;
  int? isActive;
  Wallet? wallet;
  Level? level;
  String? userRating;
  int? totalRideCount;
  double? completionPercent;
  int? loyaltyPoints;

  ProfileInfo(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.gender,
        this.identificationNumber,
        this.identificationType,
        this.profileImage,
        this.identificationImage,
        this.isActive,
        this.wallet,
        this.level,
        this.userRating,
        this.totalRideCount,
        this.completionPercent,
        this.loyaltyPoints
      });

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email']??'';
    phone = json['phone'];
    gender = json['gender'];
    identificationNumber = json['identification_number'];
    identificationType = json['identification_type'];
    profileImage = json['profile_image']??'';
    if(json['identification_image'] != null){
      identificationImage = json['identification_image'].cast<String>();
    }

    isActive = int.parse(json['is_active'].toString());
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    userRating = json['user_rating'].toString();
    totalRideCount = int.tryParse('${json['total_ride_count']}') ?? 0;
    completionPercent = json['completion_percent'].toDouble();
    if(json['loyalty_points'] != null) {
      loyaltyPoints = int.parse(json['loyalty_points'].toString());
    }
  }

}


class Wallet {
  String? id;
  double? payableBalance;
  double? receivableBalance;
  double? pendingBalance;
  double? walletBalance;
  double? totalWithdrawn;
  double? referralEarn;

  Wallet(
      {this.id,
        this.payableBalance,
        this.receivableBalance,
        this.pendingBalance,
        this.walletBalance,
        this.totalWithdrawn,
        this.referralEarn
      });

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payableBalance = json['payable_balance'].toDouble();
    receivableBalance = json['receivable_balance'].toDouble();
    pendingBalance = json['pending_balance'].toDouble();
    walletBalance = json['wallet_balance'].toDouble();
    totalWithdrawn = json['total_withdrawn'].toDouble();
    referralEarn = json['referral_earn'].toDouble();
  }

}

class Level {
  String? id;
  int? sequence;
  String? name;
  String? rewardType;
  String? image;

  Level(
      {this.id,
        this.sequence,
        this.name,
        this.rewardType,
        this.image
        });

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = int.parse(json['sequence'].toString());
    name = json['name'];
    rewardType = json['reward_type'];
    image = json['image'];

  }

}