interface II18n {
  translations : object;
  locale : string;
  translate(args) : string;
  localize(args) : string;
  t(args) : string;
  l(args) : string;
  reset();
}


declare var I18n : II18n