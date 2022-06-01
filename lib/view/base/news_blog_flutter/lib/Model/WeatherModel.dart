class WeatherModel {
  Current? current;
  Location? location;
  Forecast? forecast;

  WeatherModel({this.current, this.location, this.forecast});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      current: json['current'] != null ? Current.fromJson(json['current']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.forecast != null) {
      data['forecast'] = this.forecast!.toJson();
    }
    return data;
  }
}

class Location {
  String? country;
  double? lat;
  String? localtime;
  int? localtime_epoch;
  double? lon;
  String? name;
  String? region;
  String? tz_id;

  Location({this.country, this.lat, this.localtime, this.localtime_epoch, this.lon, this.name, this.region, this.tz_id});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'],
      lat: json['lat'],
      localtime: json['localtime'],
      localtime_epoch: json['localtime_epoch'],
      lon: json['lon'],
      name: json['name'],
      region: json['region'],
      tz_id: json['tz_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['localtime'] = this.localtime;
    data['localtime_epoch'] = this.localtime_epoch;
    data['lon'] = this.lon;
    data['name'] = this.name;
    data['region'] = this.region;
    data['tz_id'] = this.tz_id;
    return data;
  }
}

class Current {
  AirQuality? air_quality;
  int? cloud;
  Condition? condition;
  double? feelslike_c;
  double? feelslike_f;
  double? gust_kph;
  double? gust_mph;
  int? humidity;
  int? is_day;
  String? last_updated;
  int? last_updated_epoch;
  double? precip_in;
  double? precip_mm;
  double? pressure_in;
  double? pressure_mb;
  double? temp_c;
  double? temp_f;
  double? uv;
  double? vis_km;
  double? vis_miles;
  int? wind_degree;
  String? wind_dir;
  double? wind_kph;
  double? wind_mph;

  Current({
    this.air_quality,
    this.cloud,
    this.condition,
    this.feelslike_c,
    this.feelslike_f,
    this.gust_kph,
    this.gust_mph,
    this.humidity,
    this.is_day,
    this.last_updated,
    this.last_updated_epoch,
    this.precip_in,
    this.precip_mm,
    this.pressure_in,
    this.pressure_mb,
    this.temp_c,
    this.temp_f,
    this.uv,
    this.vis_km,
    this.vis_miles,
    this.wind_degree,
    this.wind_dir,
    this.wind_kph,
    this.wind_mph,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      air_quality: json['air_quality'] != null ? AirQuality.fromJson(json['air_quality']) : null,
      cloud: json['cloud'],
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      feelslike_c: json['feelslike_c'],
      feelslike_f: json['feelslike_f'],
      gust_kph: json['gust_kph'],
      gust_mph: json['gust_mph'],
      humidity: json['humidity'],
      is_day: json['is_day'],
      last_updated: json['last_updated'],
      last_updated_epoch: json['last_updated_epoch'],
      precip_in: json['precip_in'],
      precip_mm: json['precip_mm'],
      pressure_in: json['pressure_in'],
      pressure_mb: json['pressure_mb'],
      temp_c: json['temp_c'],
      temp_f: json['temp_f'],
      uv: json['uv'],
      vis_km: json['vis_km'],
      vis_miles: json['vis_miles'],
      wind_degree: json['wind_degree'],
      wind_dir: json['wind_dir'],
      wind_kph: json['wind_kph'],
      wind_mph: json['wind_mph'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cloud'] = this.cloud;
    data['feelslike_c'] = this.feelslike_c;
    data['feelslike_f'] = this.feelslike_f;
    data['gust_kph'] = this.gust_kph;
    data['gust_mph'] = this.gust_mph;
    data['humidity'] = this.humidity;
    data['is_day'] = this.is_day;
    data['last_updated'] = this.last_updated;
    data['last_updated_epoch'] = this.last_updated_epoch;
    data['precip_in'] = this.precip_in;
    data['precip_mm'] = this.precip_mm;
    data['pressure_in'] = this.pressure_in;
    data['pressure_mb'] = this.pressure_mb;
    data['temp_c'] = this.temp_c;
    data['temp_f'] = this.temp_f;
    data['uv'] = this.uv;
    data['vis_km'] = this.vis_km;
    data['vis_miles'] = this.vis_miles;
    data['wind_degree'] = this.wind_degree;
    data['wind_dir'] = this.wind_dir;
    data['wind_kph'] = this.wind_kph;
    data['wind_mph'] = this.wind_mph;
    if (this.air_quality != null) {
      data['air_quality'] = this.air_quality!.toJson();
    }
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    return data;
  }
}

class AirQuality {
  double? co;
  int? gb_defra_index;
  double? no2;
  double? o3;
  double? pm10;
  double? pm2_5;
  double? so2;
  int? us_epa_index;

  AirQuality({this.co, this.gb_defra_index, this.no2, this.o3, this.pm10, this.pm2_5, this.so2, this.us_epa_index});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: json['co'],
      gb_defra_index: json['gb-defra-index'],
      no2: json['no2'],
      o3: json['o3'],
      pm10: json['pm10'],
      pm2_5: json['pm2_5'],
      so2: json['so2'],
      us_epa_index: json['us-epa-index'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['co'] = this.co;
    data['gb-defra-index'] = this.gb_defra_index;
    data['no2'] = this.no2;
    data['o3'] = this.o3;
    data['pm10'] = this.pm10;
    data['pm2_5'] = this.pm2_5;
    data['so2'] = this.so2;
    data['us-epa-index'] = this.us_epa_index;
    return data;
  }
}

class Condition {
  int? code;
  String? icon;
  String? text;

  Condition({this.code, this.icon, this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      code: json['code'],
      icon: json['icon'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['icon'] = this.icon;
    data['text'] = this.text;
    return data;
  }
}

class Forecast {
  List<Forecastday>? forecastday;

  Forecast({this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: json['forecastday'] != null ? (json['forecastday'] as List).map((i) => Forecastday.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forecastday != null) {
      data['forecastday'] = this.forecastday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Forecastday {
  Astro? astro;
  String? date;
  int? date_epoch;
  Day? day;
  List<Hour>? hour;

  Forecastday({this.astro, this.date, this.date_epoch, this.day, this.hour});

  factory Forecastday.fromJson(Map<String, dynamic> json) {
    return Forecastday(
      astro: json['astro'] != null ? Astro.fromJson(json['astro']) : null,
      date: json['date'],
      date_epoch: json['date_epoch'],
      day: json['day'] != null ? Day.fromJson(json['day']) : null,
      hour: json['hour'] != null ? (json['hour'] as List).map((i) => Hour.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_epoch'] = this.date_epoch;
    if (this.astro != null) {
      data['astro'] = this.astro!.toJson();
    }
    if (this.day != null) {
      data['day'] = this.day!.toJson();
    }
    if (this.hour != null) {
      data['hour'] = this.hour!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Day {
  double? avghumidity;
  double? avgtemp_c;
  double? avgtemp_f;
  double? avgvis_km;
  double? avgvis_miles;
  Condition? condition;
  int? daily_chance_of_rain;
  int? daily_chance_of_snow;
  int? daily_will_it_rain;
  int? daily_will_it_snow;
  double? maxtemp_c;
  double? maxtemp_f;
  double? maxwind_kph;
  double? maxwind_mph;
  double? mintemp_c;
  double? mintemp_f;
  double? totalprecip_in;
  double? totalprecip_mm;
  double? uv;

  Day(
      {this.avghumidity,
      this.avgtemp_c,
      this.avgtemp_f,
      this.avgvis_km,
      this.avgvis_miles,
      this.condition,
      this.daily_chance_of_rain,
      this.daily_chance_of_snow,
      this.daily_will_it_rain,
      this.daily_will_it_snow,
      this.maxtemp_c,
      this.maxtemp_f,
      this.maxwind_kph,
      this.maxwind_mph,
      this.mintemp_c,
      this.mintemp_f,
      this.totalprecip_in,
      this.totalprecip_mm,
      this.uv});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      avghumidity: json['avghumidity'],
      avgtemp_c: json['avgtemp_c'],
      avgtemp_f: json['avgtemp_f'],
      avgvis_km: json['avgvis_km'],
      avgvis_miles: json['avgvis_miles'],
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      daily_chance_of_rain: json['daily_chance_of_rain'],
      daily_chance_of_snow: json['daily_chance_of_snow'],
      daily_will_it_rain: json['daily_will_it_rain'],
      daily_will_it_snow: json['daily_will_it_snow'],
      maxtemp_c: json['maxtemp_c'],
      maxtemp_f: json['maxtemp_f'],
      maxwind_kph: json['maxwind_kph'],
      maxwind_mph: json['maxwind_mph'],
      mintemp_c: json['mintemp_c'],
      mintemp_f: json['mintemp_f'],
      totalprecip_in: json['totalprecip_in'],
      totalprecip_mm: json['totalprecip_mm'],
      uv: json['uv'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avghumidity'] = this.avghumidity;
    data['avgtemp_c'] = this.avgtemp_c;
    data['avgtemp_f'] = this.avgtemp_f;
    data['avgvis_km'] = this.avgvis_km;
    data['avgvis_miles'] = this.avgvis_miles;
    data['daily_chance_of_rain'] = this.daily_chance_of_rain;
    data['daily_chance_of_snow'] = this.daily_chance_of_snow;
    data['daily_will_it_rain'] = this.daily_will_it_rain;
    data['daily_will_it_snow'] = this.daily_will_it_snow;
    data['maxtemp_c'] = this.maxtemp_c;
    data['maxtemp_f'] = this.maxtemp_f;
    data['maxwind_kph'] = this.maxwind_kph;
    data['maxwind_mph'] = this.maxwind_mph;
    data['mintemp_c'] = this.mintemp_c;
    data['mintemp_f'] = this.mintemp_f;
    data['totalprecip_in'] = this.totalprecip_in;
    data['totalprecip_mm'] = this.totalprecip_mm;
    data['uv'] = this.uv;
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    return data;
  }
}

class Hour {
  int? chance_of_rain;
  int? chance_of_snow;
  int? cloud;
  Condition? condition;
  double? dewpoint_c;
  double? dewpoint_f;
  double? feelslike_c;
  double? feelslike_f;
  double? gust_kph;
  double? gust_mph;
  double? heatindex_c;
  double? heatindex_f;
  int? humidity;
  int? is_day;
  double? precip_in;
  double? precip_mm;
  double? pressure_in;
  double? pressure_mb;
  double? temp_c;
  double? temp_f;
  String? time;
  int? time_epoch;
  double? uv;
  double? vis_km;
  double? vis_miles;
  int? will_it_rain;
  int? will_it_snow;
  int? wind_degree;
  String? wind_dir;
  double? wind_kph;
  double? wind_mph;
  double? windchill_c;
  double? windchill_f;

  Hour(
      {this.chance_of_rain,
      this.chance_of_snow,
      this.cloud,
      this.condition,
      this.dewpoint_c,
      this.dewpoint_f,
      this.feelslike_c,
      this.feelslike_f,
      this.gust_kph,
      this.gust_mph,
      this.heatindex_c,
      this.heatindex_f,
      this.humidity,
      this.is_day,
      this.precip_in,
      this.precip_mm,
      this.pressure_in,
      this.pressure_mb,
      this.temp_c,
      this.temp_f,
      this.time,
      this.time_epoch,
      this.uv,
      this.vis_km,
      this.vis_miles,
      this.will_it_rain,
      this.will_it_snow,
      this.wind_degree,
      this.wind_dir,
      this.wind_kph,
      this.wind_mph,
      this.windchill_c,
      this.windchill_f});

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      chance_of_rain: json['chance_of_rain'],
      chance_of_snow: json['chance_of_snow'],
      cloud: json['cloud'],
      condition: json['condition'] != null ? Condition.fromJson(json['condition']) : null,
      dewpoint_c: json['dewpoint_c'],
      dewpoint_f: json['dewpoint_f'],
      feelslike_c: json['feelslike_c'],
      feelslike_f: json['feelslike_f'],
      gust_kph: json['gust_kph'],
      gust_mph: json['gust_mph'],
      heatindex_c: json['heatindex_c'],
      heatindex_f: json['heatindex_f'],
      humidity: json['humidity'],
      is_day: json['is_day'],
      precip_in: json['precip_in'],
      precip_mm: json['precip_mm'],
      pressure_in: json['pressure_in'],
      pressure_mb: json['pressure_mb'],
      temp_c: json['temp_c'],
      temp_f: json['temp_f'],
      time: json['time'],
      time_epoch: json['time_epoch'],
      uv: json['uv'],
      vis_km: json['vis_km'],
      vis_miles: json['vis_miles'],
      will_it_rain: json['will_it_rain'],
      will_it_snow: json['will_it_snow'],
      wind_degree: json['wind_degree'],
      wind_dir: json['wind_dir'],
      wind_kph: json['wind_kph'],
      wind_mph: json['wind_mph'],
      windchill_c: json['windchill_c'],
      windchill_f: json['windchill_f'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chance_of_rain'] = this.chance_of_rain;
    data['chance_of_snow'] = this.chance_of_snow;
    data['cloud'] = this.cloud;
    data['dewpoint_c'] = this.dewpoint_c;
    data['dewpoint_f'] = this.dewpoint_f;
    data['feelslike_c'] = this.feelslike_c;
    data['feelslike_f'] = this.feelslike_f;
    data['gust_kph'] = this.gust_kph;
    data['gust_mph'] = this.gust_mph;
    data['heatindex_c'] = this.heatindex_c;
    data['heatindex_f'] = this.heatindex_f;
    data['humidity'] = this.humidity;
    data['is_day'] = this.is_day;
    data['precip_in'] = this.precip_in;
    data['precip_mm'] = this.precip_mm;
    data['pressure_in'] = this.pressure_in;
    data['pressure_mb'] = this.pressure_mb;
    data['temp_c'] = this.temp_c;
    data['temp_f'] = this.temp_f;
    data['time'] = this.time;
    data['time_epoch'] = this.time_epoch;
    data['uv'] = this.uv;
    data['vis_km'] = this.vis_km;
    data['vis_miles'] = this.vis_miles;
    data['will_it_rain'] = this.will_it_rain;
    data['will_it_snow'] = this.will_it_snow;
    data['wind_degree'] = this.wind_degree;
    data['wind_dir'] = this.wind_dir;
    data['wind_kph'] = this.wind_kph;
    data['wind_mph'] = this.wind_mph;
    data['windchill_c'] = this.windchill_c;
    data['windchill_f'] = this.windchill_f;
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    return data;
  }
}

class Astro {
  String? moon_illumination;
  String? moon_phase;
  String? moonrise;
  String? moonset;
  String? sunrise;
  String? sunset;

  Astro({this.moon_illumination, this.moon_phase, this.moonrise, this.moonset, this.sunrise, this.sunset});

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      moon_illumination: json['moon_illumination'],
      moon_phase: json['moon_phase'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['moon_illumination'] = this.moon_illumination;
    data['moon_phase'] = this.moon_phase;
    data['moonrise'] = this.moonrise;
    data['moonset'] = this.moonset;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    return data;
  }
}
