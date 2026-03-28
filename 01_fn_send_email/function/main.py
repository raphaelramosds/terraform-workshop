import os
import smtplib
import json
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

import functions_framework


@functions_framework.http
def send_email(request):
    """HTTP Cloud Function to send email via SMTP."""
    if request.method != "POST":
        return (json.dumps({"error": "Only POST method is allowed"}), 405, {"Content-Type": "application/json"})

    data = request.get_json(silent=True)
    if not data:
        return (json.dumps({"error": "Request body must be JSON"}), 400, {"Content-Type": "application/json"})

    to_address = data.get("to")
    subject = data.get("subject", "(no subject)")
    body = data.get("body", "")

    if not to_address:
        return (json.dumps({"error": "Missing required field: to"}), 400, {"Content-Type": "application/json"})

    smtp_host = os.environ["SMTP_HOST"]
    smtp_port = int(os.environ.get("SMTP_PORT", "587"))
    smtp_user = os.environ["SMTP_USER"]
    smtp_password = os.environ["SMTP_PASSWORD"]
    from_address = os.environ.get("SMTP_FROM", smtp_user)

    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = from_address
    msg["To"] = to_address
    msg.attach(MIMEText(body, "plain"))

    try:
        with smtplib.SMTP(smtp_host, smtp_port) as server:
            server.ehlo()
            server.starttls()
            server.login(smtp_user, smtp_password)
            server.sendmail(from_address, to_address, msg.as_string())
    except Exception as e:
        return (json.dumps({"error": str(e)}), 500, {"Content-Type": "application/json"})

    return (json.dumps({"status": "email sent", "to": to_address}), 200, {"Content-Type": "application/json"})
