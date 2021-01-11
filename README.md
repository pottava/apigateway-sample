# Google Cloud: API Gateway ハンズオン

この git リポジトリを clone する必要はありませんし、任意のディレクトリで動作します。  
Docker クライアントを操作できる端末を起動し、以下のステップを実行してください。

## ハンズオン環境の起動

### 1. プロジェクト ID を変数に設定します

```
$ export PROJECT_ID=<あなたの Google Cloud プロジェクト ID>
```

### 2. ハンズオン環境を起動します

```
$ docker run --rm -it -e PROJECT_ID \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.config/gcloud:/home/jupyter/.config/gcloud \
    -v $(pwd):/home/jupyter/config \
    -p 8080:8080 \
    ghcr.io/pottava/apigateway:jupyter-v1.0
```

### 3. ブラウザで環境に接続します

ブラウザで http://localhost:8080/lab/tree/0-overview.ipynb を開いてください。  
パスワードを聞かれるので **google** と入力してください。

### 4. ハンズオンの実施

ハンズオンはブラウザ内の JupyterLab で行います。  
以下の順序でハンズオンを進めてください。

```
- 0-overview.ipynb
- 1-deploy-apigateway.ipynb
- 2-secure-apis.ipynb
- 5-teardown-resources.ipynb
```

### 5. 後片付け

`Ctrl + C` でコンテナに停止シグナルを送ると、JupyterLab から  
`Shutdown this Jupyter server (y/[n])?` と聞かれます。 
`y` と入力してコンテナを終了しましょう。
