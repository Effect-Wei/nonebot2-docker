FROM python:3.14-slim
WORKDIR /app

ENV APP_ENV=production
ENV PATH="/app/.venv/bin:$PATH"
ENV PDM_CHECK_UPDATE=false
ENV PDM_NO_CACHE=true
ENV PDM_NO_EDITABLE=true
ENV PDM_NO_SELF=true
ENV PDM_NON_INTERACTIVE=true
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_NO_CACHE_DIR=on
ENV PYTHONUNBUFFERED=1
ENV TZ=Asia/Shanghai

COPY gunicorn_conf.py main.py start.sh /app/

RUN chmod +x /app/start.sh; \
    mkdir plugins; \
    apt-get update; \
    apt-get update && apt-get install -y curl fontconfig fonts-wqy-microhei; \
    rm -rf /var/lib/apt/lists/*

RUN pip install nb-cli pdm

CMD ["bash", "/app/start.sh"]
