FROM docker:20.10.1-dind

ENV JUPYTER_LAB_VERSION=3.0.0 \
    GCLOUD_VERSION=321.0.0 \
    LANG=ja_JP.UTF-8 \
    PATH=/usr/local/share/google-cloud-sdk/bin:$PATH

# Install JupyterLab
RUN apk --no-cache add python3 py3-pyzmq py3-six py3-requests tini jq \
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
    && echo "673f8d4af5e524dcf06547f6c2debcc02ff6678f47f67812d7f90c696cd76e96  gcloud.tar.gz" | sha256sum -c - \
    && tar xvf gcloud.tar.gz \
    && ./google-cloud-sdk/install.sh --quiet \
    && gcloud components install beta --quiet \
    && find / -type d -name \__pycache__ -depth -exec rm -rf {} \; \
    && rm -rf gcloud.tar.gz \
    && apk del --purge -r build-deps

ADD notebooks /root/notebook
ADD resources /root/notebook/resources
WORKDIR /root/notebook

VOLUME /root/config

ADD container/jupyter/jupyter_server_config.py /root/.jupyter/
ADD container/jupyter/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["jupyter-lab"]