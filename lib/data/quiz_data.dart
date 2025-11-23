import '../models/question.dart';
import '../models/leadership_style.dart';

final List<Question> quiz = [
  Question(
    id: "Q1",
    text: "Cuando el equipo está bajo presión, tu reacción típica es:",
    options: [
    AnswerOption(text: "Dar instrucciones claras y monitorear de cerca", weights: {LeadershipStyle.autocratic: 2}),
    AnswerOption(text: "Convocar al equipo y votar el plan a seguir",     weights: {LeadershipStyle.democratic: 2}),
    AnswerOption(text: "Inspirar con visión y propósito",                 weights: {LeadershipStyle.transformational: 2}),
    AnswerOption(text: "Confiar en que cada uno se auto-organice",       weights: {LeadershipStyle.laissezFaire: 2}),
    AnswerOption(text: "Acompañar uno a uno para remover bloqueos",      weights: {LeadershipStyle.coaching: 2}),
    ],
  ),
// 2
  Question(
    id: "Q2",
    text: "Para asignar tareas, prefieres:",
    options: [
    AnswerOption(text: "Asignarlas tú según habilidades",                 weights: {LeadershipStyle.autocratic: 2}),
    AnswerOption(text: "Cocrear el reparto con el equipo",               weights: {LeadershipStyle.democratic: 2}),
    AnswerOption(text: "Vincular cada tarea a la visión de cambio",      weights: {LeadershipStyle.transformational: 2}),
    AnswerOption(text: "Dar libertad total y mínima intervención",       weights: {LeadershipStyle.laissezFaire: 2}),
    AnswerOption(text: "Definir metas y plan de desarrollo individual",  weights: {LeadershipStyle.coaching: 2}),
    ],
  ),
// 3
  Question(
    id: "Q3",
    text: "Ante conflictos internos:",
    options: [
    AnswerOption(text: "Decides rápido la solución",                      weights: {LeadershipStyle.autocratic: 2}),
    AnswerOption(text: "Facilitas diálogo y consenso",                    weights: {LeadershipStyle.democratic: 2}),
    AnswerOption(text: "Reencuadras hacia metas superiores",              weights: {LeadershipStyle.transformational: 2}),
    AnswerOption(text: "Evitas intervenir mientras puedan resolver",      weights: {LeadershipStyle.laissezFaire: 2}),
    AnswerOption(text: "Coacheas para que aprendan del conflicto",        weights: {LeadershipStyle.coaching: 2}),
    ],
  ),
// 4
  Question(
    id: "Q4",
    text: "Tu métrica principal de éxito:",
    options: [
    AnswerOption(text: "Cumplir el plan al detalle",                      weights: {LeadershipStyle.autocratic: 2}),
    AnswerOption(text: "Satisfacción y acuerdo del equipo",               weights: {LeadershipStyle.democratic: 2}),
    AnswerOption(text: "Progreso hacia una transformación real",          weights: {LeadershipStyle.transformational: 2}),
    AnswerOption(text: "Autonomía y responsabilidad individual",          weights: {LeadershipStyle.laissezFaire: 2}),
    AnswerOption(text: "Crecimiento de cada persona",                     weights: {LeadershipStyle.coaching: 2}),
    ],
  ),
// 5
  Question(
    id: "Q5",
    text: "Con una urgencia inesperada:",
    options: [
    AnswerOption(text: "Ordenas y reasignas sin consulta",                weights: {LeadershipStyle.autocratic: 2}),
    AnswerOption(text: "Buscas rápidamente opiniones clave",              weights: {LeadershipStyle.democratic: 2}),
    AnswerOption(text: "Conectas la urgencia con la visión",              weights: {LeadershipStyle.transformational: 2}),
    AnswerOption(text: "Permites que cada uno reaccione",                 weights: {LeadershipStyle.laissezFaire: 2}),
    AnswerOption(text: "Acompañas al más afectado a desbloquear",         weights: {LeadershipStyle.coaching: 2}),
    ],
  ),
];

