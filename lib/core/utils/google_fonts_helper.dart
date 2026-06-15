import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FontOption {
  poppins,
  roboto,
  inter,
  lato,
  montserrat,
  nunito,
  openSans,
  raleway,
  ubuntu,
  oswald,
  mukta,
  cabin,
  quicksand,
  workSans,
  dmSans,
  rubik,
  manrope,
  outfit,
  josefinSans,
  playfairDisplay,
}

class AppFonts {
  static TextTheme getTextTheme(FontOption font) {
    switch (font) {
      case FontOption.poppins:
        return GoogleFonts.poppinsTextTheme();

      case FontOption.roboto:
        return GoogleFonts.robotoTextTheme();

      case FontOption.inter:
        return GoogleFonts.interTextTheme();

      case FontOption.lato:
        return GoogleFonts.latoTextTheme();

      case FontOption.montserrat:
        return GoogleFonts.montserratTextTheme();

      case FontOption.nunito:
        return GoogleFonts.nunitoTextTheme();

      case FontOption.openSans:
        return GoogleFonts.openSansTextTheme();

      case FontOption.raleway:
        return GoogleFonts.ralewayTextTheme();

      case FontOption.ubuntu:
        return GoogleFonts.ubuntuTextTheme();

      case FontOption.oswald:
        return GoogleFonts.oswaldTextTheme();

      case FontOption.mukta:
        return GoogleFonts.muktaTextTheme();

      case FontOption.cabin:
        return GoogleFonts.cabinTextTheme();

      case FontOption.quicksand:
        return GoogleFonts.quicksandTextTheme();

      case FontOption.workSans:
        return GoogleFonts.workSansTextTheme();

      case FontOption.dmSans:
        return GoogleFonts.dmSansTextTheme();

      case FontOption.rubik:
        return GoogleFonts.rubikTextTheme();

      case FontOption.manrope:
        return GoogleFonts.manropeTextTheme();

      case FontOption.outfit:
        return GoogleFonts.outfitTextTheme();

      case FontOption.josefinSans:
        return GoogleFonts.josefinSansTextTheme();

      case FontOption.playfairDisplay:
        return GoogleFonts.playfairDisplayTextTheme();
    }
  }
}
extension FontOptionExtension on FontOption {
  String get label {
    switch (this) {
      case FontOption.poppins:
        return "Poppins";
      case FontOption.roboto:
        return "Roboto";
      case FontOption.inter:
        return "Inter";
      case FontOption.lato:
        return "Lato";
      case FontOption.montserrat:
        return "Montserrat";
      case FontOption.nunito:
        return "Nunito";
      case FontOption.openSans:
        return "Open Sans";
      case FontOption.raleway:
        return "Raleway";
      case FontOption.ubuntu:
        return "Ubuntu";
      case FontOption.oswald:
        return "Oswald";
      case FontOption.mukta:
        return "Mukta";
      case FontOption.cabin:
        return "Cabin";
      case FontOption.quicksand:
        return "Quicksand";
      case FontOption.workSans:
        return "Work Sans";
      case FontOption.dmSans:
        return "DM Sans";
      case FontOption.rubik:
        return "Rubik";
      case FontOption.manrope:
        return "Manrope";
      case FontOption.outfit:
        return "Outfit";
      case FontOption.josefinSans:
        return "Josefin Sans";
      case FontOption.playfairDisplay:
        return "Playfair Display";
    }
  }
}
