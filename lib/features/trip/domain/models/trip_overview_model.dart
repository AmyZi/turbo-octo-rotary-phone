class TripOverView {
  int? successRate;
  int? totalTrips;
  int? totalEarn;
  int? totalCancel;
  int? totalReviews;
  IncomeStat? incomeStat;

  TripOverView(
      {this.successRate,
        this.totalTrips,
        this.totalEarn,
        this.totalCancel,
        this.totalReviews,
        this.incomeStat});

  TripOverView.fromJson(Map<String, dynamic> json) {
    successRate = json['success_rate'];
    totalTrips = json['total_trips'];
    totalEarn = json['total_earn'];
    totalCancel = json['total_cancel'];
    totalReviews = json['total_reviews'];
    incomeStat = json['income_stat'] != null
        ? IncomeStat.fromJson(json['income_stat'])
        : null;
  }
}

class IncomeStat {
  int? sun;
  int? mon;
  int? tues;
  int? wed;
  int? thu;
  int? fri;
  int? sat;

  IncomeStat(
      {this.sun, this.mon, this.tues, this.wed, this.thu, this.fri, this.sat});

  IncomeStat.fromJson(Map<String, dynamic> json) {
    sun = json['Sun'];
    mon = json['Mon'];
    tues = json['Tues'];
    wed = json['Wed'];
    thu = json['Thu'];
    fri = json['Fri'];
    sat = json['Sat'];
  }
}
