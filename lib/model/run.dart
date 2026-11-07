class Run {
  String? id;
  String? createdAt;
  String? runWhere;
  String? runPerson;
  int? rundistance;
  String? runimageUrl;

  Run({
    this.id,
    this.createdAt,
    this.runWhere,
    this.runPerson,
    this.runimageUrl,
    this.rundistance,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (createdAt != null) 'created_at': createdAt,
        if (runWhere != null) 'run_Where': runWhere,
        if (runPerson != null) 'run_person': runPerson,
        if (rundistance != null) 'run_distance': rundistance,
        if (runimageUrl != null) 'runImageUrl': runimageUrl,
      };

  factory Run.fromJson(Map<String, dynamic> json) {
    final distance = json['run_distance'];

    return Run(
      id: json['id']?.toString(),
      createdAt: json['created_at']?.toString(),
      runWhere: json['run_Where'] as String?,
      runPerson: json['run_person'] as String?,
      rundistance: distance is num
          ? distance.toInt()
          : int.tryParse(distance?.toString() ?? ''),
      runimageUrl: json['runImageUrl'] as String?,
    );
  }
}
