# Script d'envoi d'email avec msmtp

Ce script Bash permet d'envoyer des emails paramétrables en utilisant `msmtp`. Il est conçu pour être facilement intégré dans des scripts automatisés nécessitant des notifications par email.

## Fonctionnalités

- Envoi d'emails avec des paramètres personnalisables (sujet, corps, expéditeur, destinataire, etc.).
- Support des statuts d'email (INFO, ERROR, SUCCESS, WARNING) avec mise en forme HTML.
- Journalisation des actions dans un fichier de log.
- Configuration automatique de `msmtp` pour un compte Office365.

## Prérequis

- Un système Linux avec `bash` et `msmtp`.
- Accès à un compte email Office365 pour la configuration de `msmtp`.

## Installation

1. Clonez ce dépôt sur votre machine locale :

    ```bash
    git clone https://github.com/H3-Campus/sendmail_bash/sendmail_bash.git
    cd votre-depot
    ```

2. Assurez-vous que `msmtp` est installé. Si ce n'est pas le cas, le script l'installera automatiquement.

3. Configurez les informations d'identification de votre compte email dans le script.

## Utilisation

### Envoi d'un email

Pour envoyer un email, utilisez la fonction `send_email` avec les paramètres souhaités :

```bash
source send_email.sh
send_email --subject="Sujet de l'email" --body="Corps de l'email" --to="destinataire@example.com"
```

### Test de l'envoi d'email

Pour tester l'envoi d'un email, exécutez le script avec l'option `--test` :

```bash
./send_email.sh --test
```

## Configuration

Le script configure automatiquement `msmtp` avec un compte Office365. Vous pouvez modifier les informations de configuration directement dans le script.

## Journalisation

Les actions du script sont journalisées dans `/var/log/script_email.log`. Vous pouvez spécifier un autre fichier de log en utilisant l'option `--log`.

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](licence.txt) pour plus de détails.

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request.
