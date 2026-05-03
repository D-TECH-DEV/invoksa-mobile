# Fiche d'Audit - Application Invoksa
**Date :** 1 Mai 2026
**Auditeur :** Expert Pentest & Flutter Dev
**Statut du projet :** Développement en cours (Phase MVP)

---

## 1. Audit Fonctionnel (Analyse des fonctions manquantes)

### 🔐 Authentification & Profil
- **Gestion du mot de passe :** Absence de la fonction "Mot de passe oublié" et de la modification du mot de passe une fois connecté.
- **Déconnexion :** La logique de déconnexion est incomplète dans le `SettingsViewmodel` et ne semble pas réinitialiser l'état global de l'application.
- **Suppression de compte :** Conformément au RGPD et aux règles Apple/Google, l'option de suppression de compte est absente.

### 👤 Gestion des Clients
- **Édition :** Impossible de modifier les informations d'un client existant (Nom, Email, Téléphone).
- **Suppression :** Absence de fonction pour supprimer ou archiver un client.
- **Historique :** Pas de vue détaillée consolidée de l'historique complet par client (uniquement une liste de factures).

### 📄 Gestion des Factures
- **Édition :** Une facture créée ne peut plus être modifiée (sauf son statut). Une fonction de "Brouillon" ou d'édition avant finalisation est manquante.
- **Suppression :** Absence de suppression des factures (nécessaire pour les erreurs de saisie en phase de test).
- **Export :** L'export PDF fonctionne mais manque d'options de personnalisation (logo, couleurs, mentions légales).

### ⚙️ Paramètres & UX
- **Internationalisation :** Les fichiers de traduction (AR/EN/FR) sont prévus dans `main.dart` mais la logique de changement de langue dans `SettingsViewmodel` est vide.
- **Mode Hors-ligne :** L'application est 100% dépendante de l'API. Aucun cache local (SQLite ou Hive) n'est implémenté pour consulter les données sans connexion.
- **Notifications :** Aucune gestion des notifications push (relances de factures impayées, etc.).

---

## 2. Audit de Sécurité (Pentest & Hardening)

### 🚨 Vulnérabilités Identifiées
1. **Validation des entrées (Client-side) :** 
   - Faible validation sur les formulaires (Login, Client, Facture). Pas de vérification de format d'email (regex) ou de force de mot de passe.
   - Risque d'injection de données malformées vers l'API.
2. **Hardcoding :** 
   - L'URL de l'API (`baseUrl`) est en dur dans `ApiConstants.dart`. Elle devrait être déplacée dans un fichier `.env` non commité.
3. **Gestion des Erreurs :** 
   - Utilisation de `e.toString()` dans plusieurs ViewModels qui peut exposer des détails techniques du backend à l'utilisateur final.

### ✅ Points Forts (Sécurité)
- **Stockage Sécurisé :** Utilisation de `FlutterSecureStorage` pour le JWT, ce qui est la bonne pratique.
- **Gestion des Sessions :** `ApiService` gère correctement les codes 401 et l'expiration des tokens.

---

## 3. Audit Technique (Code & Architecture)

### 🏗️ Architecture MVVM
- **Incohérences :** Le `SettingsViewmodel` ne suit pas le pattern `ChangeNotifier` contrairement aux autres, ce qui empêche la mise à jour réactive de l'UI.
- **Redondance :** Les méthodes de chargement de clients sont dupliquées entre `InvoiceViewmodel` et `ClientViewModel`.
- **Modèles :** Les modèles utilisent des conversions JSON manuelles. L'utilisation de `json_serializable` serait plus robuste pour éviter les erreurs de type au runtime.

### 🧹 Qualité du Code
- **Logs :** Présence de `debugPrint` et `print` qui devraient être retirés ou remplacés par un logger (ex: `logger` package) pour la production.
- **Assets :** Le splash screen est basique (couleur unie). Les assets d'images sont présents mais peu utilisés pour l'interactivité.

---

## 4. Recommandations Prioritaires

1. **[Urgent - Sécurité]** Implémenter des validations Regex rigoureuses sur tous les champs de saisie.
2. **[Urgent - Fonctionnel]** Finaliser la logique de `SettingsViewmodel` pour la déconnexion et le changement de langue.
3. **[Structure]** Centraliser la gestion des clients dans un seul service/repository pour éviter la redondance.
4. **[UX]** Ajouter un système de mise en cache simple (ex: `dio_http_cache` ou stockage manuel des JSON) pour améliorer la réactivité.
5. **[DevOps]** Configurer des environnements (Dev/Staging/Prod) via `--dart-define` ou `.env`.

---
*Audit réalisé par Gemini CLI Expert.*
