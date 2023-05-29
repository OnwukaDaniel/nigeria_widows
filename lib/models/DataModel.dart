class BackgroundPrefData {
  bool isRandomColor = false;
  double awayRadius = 20;
  double numberOfParticles = 100;
  double speedOfParticles = 1.5;
  double maxParticleSize = 7;
  double particleColor = 1;
  int backgroundColor = 8;
  double opacity = 0;
  bool connectDots = true;
  int identity = 1;

  BackgroundPrefData({
    this.isRandomColor = false,
    this.awayRadius = 20,
    this.numberOfParticles = 100,
    this.speedOfParticles = 1.5,
    this.maxParticleSize = 7,
    this.particleColor = 1,
    this.backgroundColor = 8,
    this.connectDots = true,
    this.identity = 1,
  });

  BackgroundPrefData.fromJson(Map<String, dynamic> json) {
    isRandomColor = json['isRandomColor'];
    awayRadius = json['awayRadius'];
    numberOfParticles = json['numberOfParticles'];
    speedOfParticles = json['speedOfParticles'];
    maxParticleSize = json['maxParticleSize'];
    particleColor = json['particleColor'];
    backgroundColor = json['backgroundColor'];
    connectDots = json['connectDots'];
    identity = json['identity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isRandomColor'] = isRandomColor;
    data['awayRadius'] = awayRadius;
    data['numberOfParticles'] = numberOfParticles;
    data['speedOfParticles'] = speedOfParticles;
    data['maxParticleSize'] = maxParticleSize;
    data['particleColor'] = particleColor;
    data['backgroundColor'] = backgroundColor;
    data['connectDots'] = connectDots;
    data['identity'] = identity;
    return data;
  }
}
