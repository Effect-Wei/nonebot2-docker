FROM python:3.12-slim

WORKDIR /app

ENV TZ=Asia/Shanghai
ENV PYTHONPATH=/app
ENV APP_MODULE=main:app
ENV MAX_WORKERS=1
ENV APP_ENV=production
ENV POETRY_VIRTUALENVS_CREATE=false
ENV PIP_NO_CACHE_DIR=on
ENV PIP_DISABLE_PIP_VERSION_CHECK=on

COPY gunicorn_conf.py main.py start.sh /app/

ADD https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 /app/phantomjs-2.1.1-linux-x86_64.tar.bz2

RUN sed -i 's_http://deb.debian.org/_https://mirrors.tuna.tsinghua.edu.cn/_' /etc/apt/sources.list.d/debian.sources; \
    chmod +x /app/start.sh; \
    mkdir plugins; \
    apt-get update; \
    apt-get install -y fontconfig tar bzip2 curl fonts-wqy-microhei; \
    rm -rf /var/lib/apt/lists/*; \
    tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/; \
    rm phantomjs-2.1.1-linux-x86_64.tar.bz2; \
    ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin; \
    pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple ; \
    curl -sSL https://install.python-poetry.org | python3 -

RUN pip install --no-cache nb-cli

CMD ["bash", "/app/start.sh"]
