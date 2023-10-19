FROM python:3.10-alpine

EXPOSE 80

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


# Install pip requirements
COPY requirements.txt .

RUN set -ex \
&& apk add unixodbc-dev g++ curl gpg gpg-agent sudo \
\
&& python -m pip install -r requirements.txt \
&& python -m pip install --disable-pip-version-check debugpy -t /tmp \
\
#Download the desired package(s)
&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.5.1-1_amd64.apk \
&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.10.1.1-1_amd64.apk \
\
#(Optional) Verify signature, if 'gpg' is missing install it using 'apk add gnupg':
&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.5.1-1_amd64.sig \
&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.10.1.1-1_amd64.sig \
\
&& curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import - \
&& gpg --verify msodbcsql17_17.10.5.1-1_amd64.sig msodbcsql17_17.10.5.1-1_amd64.apk \
&& gpg --verify mssql-tools_17.10.1.1-1_amd64.sig mssql-tools_17.10.1.1-1_amd64.apk \
\
#Install the package(s)
&& sudo apk add --allow-untrusted msodbcsql17_17.10.5.1-1_amd64.apk \
&& sudo apk add --allow-untrusted mssql-tools_17.10.1.1-1_amd64.apk