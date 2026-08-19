class ErrorHandler {
  static String getFriendlyMessage(dynamic e) {
    String error = e.toString().toLowerCase();
    
    if (error.contains('network') || error.contains('connection') || error.contains('socketexception')) {
      return "Problème de connexion. Veuillez vérifier votre accès internet.";
    } 
    
    if (error.contains('401') || error.contains('unauthorized')) {
      return "Session expirée ou accès non autorisé. Veuillez vous reconnecter.";
    } 
    
    if (error.contains('403') || error.contains('forbidden')) {
      return "Vous n'avez pas la permission d'effectuer cette action.";
    }
    
    if (error.contains('404')) {
      return "Ressource introuvable. Veuillez réessayer plus tard.";
    }
    
    if (error.contains('500') || error.contains('server error')) {
      return "Erreur interne du serveur. Nos équipes travaillent à sa résolution.";
    }
    
    if (error.contains('timeout')) {
      return "Le serveur met trop de temps à répondre. Veuillez réessayer.";
    }

    if (error.contains('ia') || error.contains('ai')) {
      return e.toString().replaceFirst("Exception: ", "").replaceFirst("Erreur IA: ", "");
    }

    // Default message for other errors, avoiding technical details
    return "Une erreur inattendue est survenue. Veuillez réessayer.";
  }
}
