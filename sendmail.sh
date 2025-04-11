#!/bin/bash

#-------------------------------------------------------
# Fonction d'envoi d'email paramétrable avec msmtp
# Auteur: SI H3 Campus
# Usage: send_email [options]
#-------------------------------------------------------

# Installation de msmtp si non présent
if ! command -v msmtp &> /dev/null; then
    echo "msmtp n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y msmtp
fi

# Configuration de msmtp pour Outlook
MSMTPRC_CONTENT=$(cat <<EOF
# Configuration de msmtp pour Outlook
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Compte Backups
account Backups
host smtp.office365.com
port 587
from backups@h3campus.fr
user backups@h3campus.fr
password *************

# Définir l'account par défaut
account default : Backups
EOF
)

# Écriture de la configuration dans le fichier .msmtprc
MSMTPRC_PATH="$HOME/.msmtprc"
echo "$MSMTPRC_CONTENT" > "$MSMTPRC_PATH"
chmod 600 "$MSMTPRC_PATH"

# Variables par défaut
DEFAULT_MAIL_FROM="Système de notification <backups@h3campus.fr>"
DEFAULT_MAIL_TO="admin@h3campus.fr"
DEFAULT_MAIL_ACCOUNT="Backups"
LOG_FILE="/var/log/script_email.log"

# Fonction de journalisation
log_message() {
    local message="$1"
    local level="$2"
    local log_file="${3:-$LOG_FILE}"

    local GREEN="\033[1;32m"
    local RED="\033[1;31m"
    local YELLOW="\033[1;33m"
    local NC="\033[0m"

    if [[ "$level" == "ERROR" ]]; then
        echo -e "${RED}[ERROR] $message${NC}"
    elif [[ "$level" == "WARNING" ]]; then
        echo -e "${YELLOW}[WARNING] $message${NC}"
    else
        echo -e "${GREEN}[INFO] $message${NC}"
    fi

    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [$level] $message" >> "$log_file"
}

# Fonction d'envoi d'email avec msmtp
send_email() {
    # Traitement des paramètres avec valeurs par défaut
    local subject="Notification"
    local body="Ceci est un message de notification."
    local status="info"
    local mail_from="$DEFAULT_MAIL_FROM"
    local mail_to="$DEFAULT_MAIL_TO"
    local mail_account="$DEFAULT_MAIL_ACCOUNT"
    local custom_log_file="$LOG_FILE"
    local server_name="$(hostname)"
    local script_name="script.sh"

    # Analyse des options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --subject=*)
                subject="${1#*=}"
                shift
                ;;
            --body=*)
                body="${1#*=}"
                shift
                ;;
            --status=*)
                status="${1#*=}"
                shift
                ;;
            --from=*)
                mail_from="${1#*=}"
                shift
                ;;
            --to=*)
                mail_to="${1#*=}"
                shift
                ;;
            --account=*)
                mail_account="${1#*=}"
                shift
                ;;
            --log=*)
                custom_log_file="${1#*=}"
                shift
                ;;
            --server=*)
                server_name="${1#*=}"
                shift
                ;;
            --script=*)
                script_name="${1#*=}"
                shift
                ;;
            *)
                log_message "Option non reconnue: $1" "ERROR" "$custom_log_file"
                return 1
                ;;
        esac
    done

    # Création du fichier temporaire pour l'email
    TEMP_EMAIL=$(mktemp)

    # Configuration des couleurs et styles en fonction du statut
    local message_class="info"
    local bg_color="#4a86e8"

    if [[ "$status" == "ERROR" ]]; then
        message_class="error"
        bg_color="#cc0000"
    elif [[ "$status" == "SUCCESS" ]]; then
        message_class="success"
        bg_color="#007700"
    elif [[ "$status" == "WARNING" ]]; then
        message_class="warning"
        bg_color="#ff9900"
    fi

    # Formatage du corps du message avec <br> pour le HTML
    body=$(echo -e "$body" | sed 's/$/\<br\>/g')

    # Création du contenu de l'email en HTML
    cat > "$TEMP_EMAIL" << EOF
From: $mail_from
To: $mail_to
Subject: $subject
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 5px; overflow: hidden; }
        .header { background-color: ${bg_color}; color: white; padding: 15px; text-align: center; }
        .content { padding: 20px; background-color: white; }
        .footer { background-color: #eee; padding: 10px; text-align: center; font-size: 12px; color: #666; }
        .error { color: #cc0000; font-weight: bold; }
        .success { color: #007700; font-weight: bold; }
        .warning { color: #ff9900; font-weight: bold; }
        .info { color: #0066cc; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        table, th, td { border: 1px solid #ddd; }
        th, td { padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Notification système</h2>
        </div>
        <div class="content">
            <div class="${message_class}">
                ${body}
            </div>
            <div style="margin-top: 20px;">
                <table>
                    <tr>
                        <th>Serveur</th>
                        <td>${server_name}</td>
                    </tr>
                    <tr>
                        <th>Date</th>
                        <td>$(date)</td>
                    </tr>
                    <tr>
                        <th>Script</th>
                        <td>${script_name}</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="footer">
            Ce message est généré automatiquement, merci de ne pas y répondre.
        </div>
    </div>
</body>
</html>
EOF

    # Envoi de l'email avec msmtp
    msmtp -a "$mail_account" -t < "$TEMP_EMAIL"

    # Vérification du statut de l'envoi
    if [ $? -eq 0 ]; then
        log_message "Email envoyé à $mail_to" "INFO" "$custom_log_file"
        rm -f "$TEMP_EMAIL"
        return 0
    else
        log_message "Échec de l'envoi d'email à $mail_to" "ERROR" "$custom_log_file"
        rm -f "$TEMP_EMAIL"
        return 1
    fi
}

# Fonction de test d'envoi d'email
test_send_email() {
    log_message "Test d'envoi d'email..." "INFO"
    send_email --subject="Test d'envoi d'email" \
              --body="Ceci est un email de test envoyé $0." \
              --status="info" \
              --script="$0"
}

# Si le script est exécuté directement, afficher l'aide
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Usage: source $(basename "${BASH_SOURCE[0]}") # Pour charger la fonction"
    echo "ou: $(basename "${BASH_SOURCE[0]}") [--test] # Pour tester la fonction"
    echo ""
    echo "Paramètres disponibles pour send_email:"
    echo "  --subject=SUJET      Sujet de l'email"
    echo "  --body=CORPS         Corps du message"
    echo "  --status=STATUT      Statut (INFO, ERROR, SUCCESS, WARNING)"
    echo "  --from=EXPÉDITEUR    Adresse de l'expéditeur"
    echo "  --to=DESTINATAIRE    Adresse du destinataire"
    echo "  --account=COMPTE     Compte msmtp à utiliser"
    echo "  --log=FICHIER_LOG    Chemin du fichier de log"
    echo "  --server=SERVEUR     Nom du serveur à afficher"
    echo "  --script=SCRIPT      Nom du script à afficher"

    # Si l'option --test est spécifiée, exécuter le test
    if [[ "$1" == "--test" ]]; then
        test_send_email
    fi
fi
