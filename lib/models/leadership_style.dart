enum LeadershipStyle { autocratic, democratic, transformational, laissezFaire, coaching }

String styleName(LeadershipStyle s) {
  switch (s) {
    case LeadershipStyle.autocratic: return "Autocrático";
    case LeadershipStyle.democratic: return "Democrático";
    case LeadershipStyle.transformational: return "Transformacional";
    case LeadershipStyle.laissezFaire: return "Laissez-faire";
    case LeadershipStyle.coaching: return "Coaching";
  }
}

