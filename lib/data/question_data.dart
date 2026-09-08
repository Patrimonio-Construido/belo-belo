import 'dart:math';

import 'package:belobelo/models/question_model.dart';

final List<Question> questions = [
  Question(
      question: "Qual a capital do Brasil?",
      answers: ["Rio de Janeiro", "Brasilia", "São Paulo"],
      correctAnswerIndex: 1
  ),
  Question(
      question: "Qual a capital da França?",
      answers: ["Paris", "Londres", "Roma"],
      correctAnswerIndex: 0
  )
];

Question getRandomQuestionAndPop() {
  questions.shuffle(Random());
  Question question = questions[0];
  questions.removeAt(0);
  return question;
}
