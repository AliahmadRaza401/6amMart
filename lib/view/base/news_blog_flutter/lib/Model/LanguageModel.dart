import 'package:flutter/material.dart';

class Language {
  int id;
  String name;
  String languageCode;
  String flag;

  Language(this.id, this.name, this.languageCode, this.flag);

  static List<Language> getLanguages() {
    return <Language>[
      Language(0, 'English', 'en', 'Images/News/flags/ic_us.png'),
      Language(1, 'Hindi', 'hi', 'Images/News/flags/ic_india.png'),
      Language(2, 'Spanish', 'es', 'Images/News/flags/ic_spain.png'),
      Language(3, 'Afrikaans', 'af', 'Images/News/flags/ic_south_africa.png'),
      Language(4, 'French', 'fr', 'Images/News/flags/ic_france.png'),
      Language(5, 'German', 'de', 'Images/News/flags/ic_germany.png'),
      Language(6, 'Indonesian', 'id', 'Images/News/flags/ic_indonesia.png'),
      Language(7, 'Portuguese', 'pt', 'Images/News/flags/ic_portugal.png'),
      Language(8, 'Turkish', 'tr', 'Images/News/flags/ic_turkey.png'),
      Language(9, 'Arabic', 'ar', 'Images/News/flags/ic_arabic.png'),
      Language(10, 'vietnam', 'vi', 'Images/News/flags/ic_vitnam.png'),
      Language(11, 'Dutch', 'nl', 'Images/News/flags/ic_netherlands.png'),
      Language(12, 'Gujarati', 'gu', 'Images/News/flags/ic_india.png'),
      Language(13, 'chinese', 'zh', 'Images/News/flags/ic_china.png'),
      Language(14, 'japanese', 'ja', 'Images/News/flags/ic_japanese.png'),
    ];
  }

  static List<Language> getLanguagesForTTS() {
    return <Language>[
      Language(
        0,
        'English',
        '',
        '',
      ),
      Language(
        1,
        'Marathi',
        'IN',
        '',
      ),
      Language(
        2,
        'Russian',
        'RU',
        '',
      ),
      Language(
        3,
        'Chinese',
        'TW',
        '',
      ),
      Language(
        4,
        'Hungarian',
        'HU',
        '',
      ),
      Language(5, 'Thai', 'TH', ''),
      Language(
        6,
        'Urdu',
        '',
        '',
      ),
      Language(
        7,
        'Norwegian',
        '',
        '',
      ),
      Language(8, 'Danish', 'DK', ''),
      Language(9, 'Turkish', 'TR', ''),
      Language(
        10,
        'Estonian',
        'EE',
        '',
      ),
      Language(
        11,
        'Bosnian',
        '',
        '',
      ),
      Language(
        12,
        'Swahili',
        '',
        '',
      ),
      Language(
        13,
        'Portuguese',
        '',
        '',
      ),
      Language(
        14,
        'Vietnamese',
        'VN',
        '',
      ),
      Language(
        15,
        'Korean',
        'KR',
        '',
      ),
      Language(
        16,
        'Swedish',
        'SE',
        '',
      ),
      Language(
        17,
        'Arabic',
        '',
        '',
      ),
      Language(
        18,
        'Sundanese',
        'ID',
        '',
      ),
      Language(
        19,
        'Bengali',
        '',
        '',
      ),
      Language(
        20,
        'Gujarati',
        'IN',
        '',
      ),
      Language(
        21,
        'Kannada',
        'IN',
        '',
      ),
      Language(
        22,
        'Greek',
        '',
        '',
      ),
      Language(
        23,
        'Hindi',
        'IN',
        '',
      ),
      Language(
        24,
        'Finnish',
        'FI',
        '',
      ),
      Language(
        25,
        'Khmer',
        '',
        '',
      ),
      Language(
        26,
        'Bengali',
        'IN',
        '',
      ),
      Language(
        27,
        'French',
        'FR',
        '',
      ),
      Language(
        28,
        'Ukrainian',
        'UA',
        '',
      ),
      // Language(29, 'English', 'AU', '', ),
      Language(
        30,
        'Dutch',
        'NL',
        '',
      ),
      Language(
        31,
        'French',
        'CA',
        '',
      ),
      Language(
        32,
        'Serbian',
        '',
        '',
      ),
      Language(
        33,
        'Portuguese',
        'BR',
        '',
      ),
      Language(
        34,
        'Malayalam',
        'IN',
        '',
      ),
      Language(
        35,
        'Sinhala',
        '',
        '',
      ),
      Language(
        36,
        'German',
        'DE',
        '',
      ),
      Language(
        37,
        'Kurdish',
        '',
        '',
      ),
      Language(
        38,
        'Czech',
        '',
        '',
      ),
      Language(
        39,
        'Polish',
        'PL',
        '',
      ),
      Language(
        40,
        'Slovak',
        'SK',
        '',
      ),
      Language(
        41,
        'Philippines',
        '',
        '',
      ),
      Language(
        42,
        'Italian',
        'IT',
        '',
      ),
      Language(
        43,
        'Nepali',
        '',
        '',
      ),
      Language(
        44,
        'Croatian',
        '',
        '',
      ),
      //Language(45, 'English(NG)', 'NG', '', ),
      Language(
        46,
        'Chinese',
        'CN',
        '',
      ),
      Language(
        47,
        'Spanish',
        'ES',
        '',
      ),
      Language(
        48,
        'Welsh',
        '',
        '',
      ),
      Language(
        49,
        'Tamil',
        'IN',
        '',
      ),
      Language(
        50,
        'Japanese',
        'JP',
        '',
      ),
      Language(
        51,
        'Albanian',
        '',
        '',
      ),
      Language(
        52,
        'Hong Kong',
        'HK',
        '',
      ),
      //Language(53, 'English', 'IN', '', ),
      Language(
        54,
        'Spanish',
        'US',
        '',
      ),
      Language(
        55,
        'Javanese',
        'ID',
        '',
      ),
      Language(
        56,
        'Latin',
        '',
        '',
      ),
      Language(
        57,
        'Indonesian',
        '',
        '',
      ),
      Language(
        58,
        'Telugu',
        'IN',
        '',
      ),
      Language(
        59,
        'Romanian',
        'RO',
        '',
      ),
      Language(
        60,
        'Catalan',
        '',
        '',
      ),
      // Language(61, 'English', 'GB', '', ),
    ];
  }

  static List<String> languages() {
    List<String> list = [];

    getLanguages().forEach((element) {
      list.add(element.languageCode);
    });

    return list;
  }

  static List<Locale> languagesLocale() {
    List<Locale> list = [];

    getLanguages().forEach((element) {
      list.add(Locale(element.languageCode, ''));
    });

    return list;
  }
}

// class Language {
//   int id;
//   String name;
//   String languageCode;
//   String flag;
//
//   Language(this.id, this.name, this.languageCode, this.flag);
//
//   static List<Language> getLanguages() {
//     return <Language>[
//       Language(0, 'English', 'en', 'Images/News/flags/ic_us.png'),
//       Language(1, 'Hindi', 'hi', 'Images/News/flags/ic_india.png'),
//       Language(2, 'Spanish', 'es', 'Images/News/flags/ic_spain.png'),
//       Language(3, 'Afrikaans', 'af', 'Images/News/flags/ic_south_africa.png'),
//       Language(4, 'French', 'fr', 'Images/News/flags/ic_france.png'),
//       Language(5, 'German', 'de', 'Images/News/flags/ic_germany.png'),
//       Language(6, 'Indonesian', 'id', 'Images/News/flags/ic_indonesia.png'),
//       Language(7, 'Portuguese', 'pt', 'Images/News/flags/ic_portugal.png'),
//       Language(8, 'Turkish', 'tr', 'Images/News/flags/ic_turkey.png'),
//       Language(9, 'Arabic', 'ar', 'Images/News/flags/ic_arabic.png'),
//       Language(10, 'vietnam', 'vi', 'Images/News/flags/ic_vitnam.png'),
//       Language(11, 'Dutch', 'nl', 'Images/News/flags/ic_netherlands.png'),
//       Language(12, 'Gujarati', 'gu', 'Images/News/flags/ic_india.png'),
//       Language(13, 'chinese', 'zh', 'Images/News/flags/ic_china.png'),
//       Language(14, 'japanese', 'ja', 'Images/News/flags/ic_japanese.png'),
//     ];
//   }
//   static List<Language> getLanguagesForTTS() {
//     return <Language>[
//
//       Language(0, 'English', '', '', ),
//       Language(1, 'Marathi', 'IN', '', ),
//       Language(2, 'Russian', 'RU', '', ),
//       Language(3, 'Chinese', 'TW', '', ),
//       Language(4, 'Hungarian', 'HU', '', ),
//       Language(5, 'Thai', 'TH', '' ),
//       Language(6, 'Urdu', '', '', ),
//       Language(7, 'Norwegian', '', '', ),
//       Language(8, 'Danish', 'DK', ''),
//       Language(9, 'Turkish', 'TR', ''),
//       Language(10, 'Estonian', 'EE', '', ),
//       Language(11, 'Bosnian', '', '', ),
//       Language(12, 'Swahili', '', '', ),
//       Language(13, 'Portuguese', '', '', ),
//       Language(14, 'Vietnamese', 'VN', '', ),
//       Language(15, 'Korean', 'KR', '', ),
//       Language(16, 'Swedish', 'SE', '', ),
//       Language(17, 'Arabic', '', '', ),
//       Language(18, 'Sundanese', 'ID', '', ),
//       Language(19, 'Bengali', '', '', ),
//       Language(20, 'Gujarati', 'IN', '', ),
//       Language(21, 'Kannada', 'IN', '', ),
//       Language(22, 'Greek', '', '', ),
//       Language(23, 'Hindi', 'IN', '', ),
//       Language(24, 'Finnish', 'FI', '', ),
//       Language(25, 'Khmer', '', '', ),
//       Language(26, 'Bengali', 'IN', '', ),
//       Language(27, 'French', 'FR', '', ),
//       Language(28, 'Ukrainian', 'UA', '', ),
//       // Language(29, 'English', 'AU', '', ),
//       Language(30, 'Dutch', 'NL', '', ),
//       Language(31, 'French', 'CA', '', ),
//       Language(32, 'Serbian', '', '', ),
//       Language(33, 'Portuguese', 'BR', '', ),
//       Language(34, 'Malayalam', 'IN', '', ),
//       Language(35, 'Sinhala', '', '', ),
//       Language(36, 'German', 'DE', '', ),
//       Language(37, 'Kurdish', '', '', ),
//       Language(38, 'Czech', '', '', ),
//       Language(39, 'Polish', 'PL', '', ),
//       Language(40, 'Slovak', 'SK', '', ),
//       Language(41, 'Philippines', '', '', ),
//       Language(42, 'Italian', 'IT', '', ),
//       Language(43, 'Nepali', '', '', ),
//       Language(44, 'Croatian', '', '', ),
//       //Language(45, 'English(NG)', 'NG', '', ),
//       Language(46, 'Chinese', 'CN', '', ),
//       Language(47, 'Spanish', 'ES', '', ),
//       Language(48, 'Welsh', '', '', ),
//       Language(49, 'Tamil', 'IN', '', ),
//       Language(50, 'Japanese', 'JP', '', ),
//       Language(51, 'Albanian', '', '', ),
//       Language(52, 'Hong Kong', 'HK', '', ),
//       //Language(53, 'English', 'IN', '', ),
//       Language(54, 'Spanish', 'US', '', ),
//       Language(55, 'Javanese', 'ID', '', ),
//       Language(56, 'Latin', '', '', ),
//       Language(57, 'Indonesian', '', '', ),
//       Language(58, 'Telugu', 'IN', '', ),
//       Language(59, 'Romanian', 'RO', '', ),
//       Language(60, 'Catalan', '', '', ),
//       // Language(61, 'English', 'GB', '', ),
//     ];
//   }
// }
