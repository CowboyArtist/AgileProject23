class TimeService {

  static getFormattedDateWithTime(DateTime date) {
    String formattedDate = '${getFormattedDate(date)} - ${date.hour}:${date.minute}';
    return formattedDate;
  }

  static getFormattedDate(DateTime date){
    String formatted = '${date.day} ${getMonthString(date.month)} ${date.year}';
    return formatted;
  }

  static getMonthString(int monthNumber){

    switch (monthNumber) {
      case 1:
        return 'Januari';
        break;
      case 2:
        return 'Februari';
        break;
      case 3:
        return 'Mars';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'Maj';
        break;
      case 6:
        return 'Juni';
        break;
      case 7:
        return 'Juli';
        break;
      case 8:
        return 'Augusti';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'Oktober';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;

      default:
        return 'Månad';
  }
  }
}