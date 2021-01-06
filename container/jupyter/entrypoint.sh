#!/bin/bash

function usage() {
  set -e
  cat <<EOM

  [ Google Cloud: API Gateway ハンズオン ]

  8080 番ポートで待機する JuputerLab が起動します。
  API Gateway の継続的デリバリー ハンズオンです。

  必要な環境変数:
      PROJECT_ID   Google Cloud プロジェクトの ID

  必要なホストからのマウント:
      /var/run/docker.sock          Docker の通信のため
      /home/jupyter/.config/gcloud  Google Cloud の認証済クレデンシャル
      /home/jupyter/config          設定ファイルを共有するため

  例:
      $ export PROJECT_ID=<your-google-cloud-project-id>
      $ docker run --rm -it -e PROJECT_ID \\
          -v /var/run/docker.sock:/var/run/docker.sock \\
          -v \$HOME/.config/gcloud:/home/jupyter/.config/gcloud \\
          -v \$(pwd):/home/jupyter/config \\
          -p 8080:8080 \\
          ghcr.io/pottava/apigateway:jupyter-v1.0

EOM
}

case "$1" in
  -h|--help|help)
    usage
    exit 2
  ;;
esac

if [ "${PROJECT_ID}" = "" ]; then
  echo "環境変数に PROJECT_ID（Google Cloud プロジェクトの ID）が指定されていません"
  exit 1
fi
if [ ! -e /home/jupyter/.config/gcloud ]; then
  echo "Google Cloud のクレデンシャル（/home/jupyter/.config/gcloud）がコンテナにマウントされていません"
  exit 1
fi
export ACCOUNT=$( gcloud config list account --format "value(core.account)" )
ret="$?"
if [ "${ret}" != "0" ] || [ "${ACCOUNT}" = "" ]; then
  echo "Google Cloud の有効なクレデンシャル（gcloud auth login 済）がコンテナにマウントされていません"
  exit 1
fi

versions=$( sudo docker version | sed -e 's|Docker Engine.*||g' )
ret="$?"
if [ "${ret}" != "0" ]; then
  echo "Docker ホストとの通信に問題があります"
  exit "${ret}"
fi

if [ ! -e /home/jupyter/config/.env ]; then
  cat << EOF > /home/jupyter/config/.env
export RANDOM_KEY=$( python3 -c "import uuid;print(uuid.uuid4())" )
EOF
fi
# shellcheck disable=SC1091
source /home/jupyter/config/.env

cat << EOT

  [ Google Cloud 環境情報 ]

  Project ID: ${PROJECT_ID}
  Account:    ${ACCOUNT}
  SDK ver:    $(gcloud --version | grep Cloud)

  [ Docker 情報 ]

  ClientVer: $( echo "${versions}" | yq -r '.Client.Version' )
  ServerVer: $( echo "${versions}" | yq -r '.Server.Engine.Version' )

EOT

exec "$@"
