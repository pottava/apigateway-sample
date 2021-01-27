FROM docker:20.10.2-dind

ENV JUPYTER_LAB_VERSION=3.0.5 \
    GCLOUD_VERSION=325.0.0 \
    LANG=ja_JP.UTF-8 \
    PATH=/usr/local/share/google-cloud-sdk/bin:$PATH

# Install JupyterLab
RUN apk --no-cache add python3 py3-pyzmq py3-six py3-requests tini curl jq \
    && apk --no-cache add --virtual build-deps build-base py3-pip \
        python3-dev libffi-dev openssl-dev \
    && python3 -m pip install "jupyterlab == ${JUPYTER_LAB_VERSION}" \
    && python3 -m pip install "bash_kernel == 0.7.2" \
    && python3 -m bash_kernel.install \
    && python3 -m pip install "yq == 2.11.1" \
    && find / -type d -name tests -depth -exec rm -rf {} \; \
    && find / -type d -name \__pycache__ -depth -exec rm -rf {} \; \
    && rm -rf /root/.cache \
    && apk del --purge -r build-deps

# Install Google Cloud SDK
RUN apk --no-cache add bash \
    && apk --no-cache add --virtual build-deps curl py3-six \
    && cd /usr/local/share \
    && curl -sSL "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz" -o gcloud.tar.gz \
    && echo "374f960c9f384f88b6fc190b268ceac5dcad777301390107af63782bfb5ecbc7  gcloud.tar.gz" | sha256sum -c - \
    && tar xf gcloud.tar.gz \
    && ./google-cloud-sdk/install.sh --quiet 2>/dev/null \
    && gcloud components install beta --quiet 2>/dev/null \
    && find / -type d -name \__pycache__ -depth -exec rm -rf {} \; \
    && rm -rf gcloud.tar.gz \
    && apk del --purge -r build-deps

ADD container/jupyter/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["jupyter-lab"]

RUN apk --no-cache add sudo \
    && adduser -S -G wheel jupyter \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
VOLUME /home/jupyter/config
WORKDIR /home/jupyter/notebook
ADD notebooks /home/jupyter/notebook
ADD resources /home/jupyter/notebook/resources
ADD container/jupyter/jupyter_server_config.py /home/jupyter/.jupyter/
RUN chown -R jupyter:wheel /home/jupyter
USER jupyter
