# Google Cloud: API Gateway ハンズオン

この git リポジトリを clone する必要はありませんし、任意のディレクトリで動作します。  
Docker クライアントを操作できる端末を起動し、以下のステップを実行してください。

## ハンズオン環境の起動

### 1. ハンズオン環境を起動します

```sh
$ docker run --rm -it -p 8080:8080 \
    -e PROJECT_ID="$(gcloud config get-value project)" \
    -v $HOME/.config/gcloud:/home/jupyter/.config/gcloud \
    -v $(pwd):/home/jupyter/config \
    ghcr.io/pottava/apigateway:jupyter-v1.0
```

### 2. ブラウザで環境に接続します

ブラウザで http://localhost:8080/lab/tree/0-overview.ipynb を開いてください。  
パスワードを聞かれるので **google** と入力してください。

### 3. ハンズオンの実施

ハンズオンはブラウザ内の JupyterLab で行います。  
以下の順序でハンズオンを進めてください。

```
- 0-overview.ipynb
- 1-deploy-apigateway.ipynb
- 2-secure-apis.ipynb
- 5-teardown-resources.ipynb
```

### 4. 後片付け

`Ctrl + C` でコンテナに停止シグナルを送ると、JupyterLab から  
`Shutdown this Jupyter server (y/[n])?` と聞かれます。 
`y` と入力してコンテナを終了しましょう。
