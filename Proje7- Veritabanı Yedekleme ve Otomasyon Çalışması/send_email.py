import smtplib
from email.mime.text import MIMEText

def send_email(error_message):
    sender = "persuren@gmail.com"
    receiver = "ofyeter60@gmail.com"
    password = "akl 34 abcyd38!"

    msg = MIMEText(f"Hata Mesajı: {error_message}")
    msg['Subject'] = "SQL Server Backup Hatası"
    msg['From'] = sender
    msg['To'] = receiver
    
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender, password)
        server.sendmail(sender, receiver, msg.as_string())
