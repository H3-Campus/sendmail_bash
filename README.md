Voici un exemple de fichier `README.md` et `LICENSE.txt` pour votre projet GitHub.

### `README.md`

```markdown


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
    git clone https://github.com/votre-utilisateur/votre-depot.git
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

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE.txt) pour plus de détails.

## Contributions

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request.



```

### `LICENSE.txt`

```plaintext


MIT License

Copyright (c) 2025 Votre Nom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


```

Ces fichiers fournissent une documentation claire et une licence pour votre projet, facilitant ainsi son utilisation et sa contribution par d'autres développeurs. Vous pouvez les adapter selon vos besoins spécifiques.
