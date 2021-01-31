import 'package:flutter/material.dart';

class EndPoints {

  static  getOneSession(sessionId) => '/sessions/$sessionId';
  static  updateSessionOffer(sessionId) => '/sessions/$sessionId/offer';
  static  updateSessionAnswer(sessionId) => '/sessions/$sessionId/answer';
  static  updateSessionCandidate(sessionId) => '/sessions/$sessionId/candidate';


}